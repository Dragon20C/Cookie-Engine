package core

import conf "../config"
import cookie "../cookie_api"
import event "../event_api"
import gfx "../gfx_api"
import input "../input_api"

import palette "../palette"
import "core:fmt"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

FIXED_TIMESTEP: f32 = 1.0 / 60.0
L: ^lua.State
game_dir: string = ""
is_dev: bool = false

run :: proc(path: string, dev: bool) {
	game_dir = path
	is_dev = dev

	if is_dev {
		fmt.println("Running in dev mode")
		fmt.println("Running project from", game_dir)
	}


	if !initalize_lua(path) {
		fmt.println("Failed to initialize Lua.")
		return
	}

	handle_loop()

}

initalize_lua :: proc(path: string) -> bool {
	L = lua.L_newstate()
	lua.L_openlibs(L)

	file_path, j_err := filepath.join({path, "main.lua"})
	if j_err != nil {
		fmt.println("Error joining file path:", j_err)
		return false
	}

	// Load the color palette from the hex file.
	if !palette.load_palette_from_file(path) {
		lua.close(L)
		return false
	}

	conf_path, conf_err := filepath.join({path, "conf.lua"})
	if conf_err != nil {
		fmt.println("Error joining file path:", conf_err)
		return false
	}
	// Create a lua state for getting the config
	CONF_L := lua.L_newstate()
	lua.L_openlibs(CONF_L)
	lua.L_dofile(CONF_L, strings.clone_to_cstring(conf_path))
	// read and update the config file from the _config function
	if !conf.read_config(CONF_L) {
		lua.close(CONF_L)
		lua.close(L)
		return false
	}
	lua.close(CONF_L)

	// Load the cookie bindings and also use the config from the _config function
	cookie.set_cookie_data(conf.current_config, is_dev)
	cookie_success := cookie.load(L)
	if !cookie_success {
		lua.close(L)
		return false
	}
	gfx.load(L)
	input.load(L)
	event.load(L)
	// UNIMPLEMENTED
	// audio.load(L)
	// input.load(L)

	err := lua.L_dofile(L, strings.clone_to_cstring(file_path))

	if err != 0 {
		msg := lua.tostring(L, -1)
		fmt.println("Lua error:", msg)
		lua.pop(L, 1)
		lua.close(L)
		return false
	}
	return true
}

handle_loop :: proc() {
	config := &conf.current_config

	rl.SetConfigFlags(rl.ConfigFlags{.WINDOW_RESIZABLE})
	rl.InitWindow(i32(config.width), i32(config.height), strings.clone_to_cstring(config.title))

	defer lua.close(L)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)


	lua_init()
	accumulator: f32 = 0.0
	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		lua_dt := lua.Number(dt)
		cookie.update_elapsed(L, f64(dt))

		accumulator += dt
		event.process_queue(L)
		for accumulator >= FIXED_TIMESTEP {
			lua_fixed_update(lua.Number(FIXED_TIMESTEP))
			accumulator -= FIXED_TIMESTEP

		}

		lua_update(lua_dt)

		rl.BeginDrawing()
		//rl.ClearBackground(rl.BLUE)
		lua_draw(lua_dt)
		rl.EndDrawing()
	}
}


lua_update :: proc(dt: lua.Number) {
	lua.getglobal(L, "_update")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.pushnumber(L, dt)
	lua.call(L, 1, 0)
}

lua_fixed_update :: proc(dt: lua.Number) {
	lua.getglobal(L, "_fixed_update")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.pushnumber(L, dt)
	lua.call(L, 1, 0)
}

lua_draw :: proc(dt: lua.Number) {
	lua.getglobal(L, "_draw")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.pushnumber(L, dt)

	lua.call(L, 1, 0)
}

lua_init :: proc() {
	lua.getglobal(L, "_init")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.call(L, 0, 0)
}
