package core

import conf "../config"
import cookie "../cookie_api"
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

handle_loop :: proc() {
	config := &conf.current_config

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

		for accumulator >= FIXED_TIMESTEP {
			lua_fixed_update(lua.Number(FIXED_TIMESTEP))
			accumulator -= FIXED_TIMESTEP

		}

		lua_update(lua_dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		lua_draw(lua_dt)
		rl.EndDrawing()
	}
}

initalize_lua :: proc(path: string) -> bool {
	L = lua.L_newstate()
	lua.L_openlibs(L)

	file_path, j_err := filepath.join({path, "main.lua"})
	if j_err != nil {
		fmt.println("Error joining file path:", j_err)
		return false
	}

	err := lua.L_dofile(L, strings.clone_to_cstring(file_path))
	if err != 0 {
		fmt.println("Error loading main.lua:", err)
		return false
	}

	// Get configuration from _config function
	if !conf.read_config(L) {
		lua.close(L)
		return false
	}

	// Load my bindings here
	cookie.set_cookie_data(conf.current_config, is_dev)
	cookie_success := cookie.load(L)
	if !cookie_success {
		lua.close(L)
		return false
	}
	// gfx.load(L)
	// audio.load(L)
	// input.load(L)

	// debugging only
	return true
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
