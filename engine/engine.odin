package engine

import gfx "/bindings/gfx"
import fmt "core:fmt"
import "core:os"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

Engine :: struct {
	L:          ^lua.State,
	game_title: cstring,
	game_id:    cstring,
	platform:   cstring,
	width:      lua.Integer,
	height:     lua.Integer,
	is_dev:     bool,
}

init_engine :: proc() -> Engine {
	L := lua.L_newstate()
	lua.L_openlibs(L)

	return Engine {
		L = L,
		game_title = "Unknown",
		game_id = "GameID",
		platform = "Unknown",
		width = 640,
		height = 360,
		is_dev = false,
	}
}

present_engine_config :: proc() {
	if engine.L == nil {
		fmt.println("Engine not initialized.")
		return
	}
	fmt.println("Title   : ", engine.game_title)
	fmt.println("ID      : ", engine.game_id)
	fmt.println("Platform: ", engine.platform)
	fmt.println("Width   : ", engine.width)
	fmt.println("Height  : ", engine.height)
	fmt.println("Dev Mode: ", engine.is_dev)
}

shutdown :: proc() {
	if engine.L != nil {
		lua.close(engine.L)
	}
}

engine: Engine

run :: proc(path: cstring, is_dev: bool) {
	// initialize the engine and lua state.
	engine = init_engine()

	engine.platform = ODIN_OS_STRING
	engine.is_dev = is_dev

	// register gfx functions.
	gfx.register_gfx(engine.L)


	// attempt to load the main.lua file.
	err := lua.L_dofile(engine.L, path)
	// if error returns non-zero we handle the error.
	if err != 0 {
		msg := lua.tostring(engine.L, -1)
		fmt.println("Lua error code:", err)
		fmt.println("Lua message:", msg)
		lua.pop(engine.L, 1)
		return
	}

	ok: bool = load_config()
	if ok && is_dev {
		present_engine_config()
	}

	if !ok {
		fmt.println("Failed to load config.")
		return
	}

	// register cookie this late because we need config to be loaded first.
	register_cookie()


	WIDTH: i32 = cast(i32)engine.width
	HEIGHT: i32 = cast(i32)engine.height

	rl.InitWindow(WIDTH, HEIGHT, engine.game_title)
	defer shutdown()
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	init()
	for !rl.WindowShouldClose() {
		update_elapsed_time()
		update()
		draw()
	}
}

load_config :: proc() -> bool {
	lua.getglobal(engine.L, "_config")

	if !lua.isfunction(engine.L, -1) {
		fmt.println("_config function not found.")
		lua.pop(engine.L, 1)
		return false
	}
	lua.call(engine.L, 0, 1)

	if !lua.istable(engine.L, -1) {
		fmt.println("Failed to load config data, no table found.")
		lua.pop(engine.L, 1)
		return false
	}

	// defer is like saying wait for next frame to do this.
	defer lua.pop(engine.L, 1)

	// Getting the first value, game_title
	lua.getfield(engine.L, -1, "game_title")

	if lua.isstring(engine.L, -1) {
		engine.game_title = lua.tostring(engine.L, -1)
	}

	lua.pop(engine.L, 1)

	// Getting game_id
	lua.getfield(engine.L, -1, "game_id")

	if lua.isstring(engine.L, -1) {
		engine.game_id = lua.tostring(engine.L, -1)
	}

	lua.pop(engine.L, 1)

	// Getting width.
	lua.getfield(engine.L, -1, "width")

	if lua.isinteger(engine.L, -1) {
		engine.width = lua.tointeger(engine.L, -1)
	}

	lua.pop(engine.L, 1)


	// Getting height.
	lua.getfield(engine.L, -1, "height")

	if lua.isinteger(engine.L, -1) {
		engine.height = lua.tointeger(engine.L, -1)
	}

	lua.pop(engine.L, 1)
	return true
}

update :: proc() {
	lua_update()
}

draw :: proc() {
	rl.BeginDrawing()
	lua_draw()
	rl.EndDrawing()

}
init :: proc() {
	// call the init function in lua.
	lua.getglobal(engine.L, "_init")
	// if _init is not a function or doesnt exist we error out.
	if !lua.isfunction(engine.L, -1) {
		fmt.println("(_init) function not found in main.lua")
		lua.pop(engine.L, 1)
		return
	}
	// call the _init function.
	lua.call(engine.L, 0, 0)
}

lua_draw :: proc() {
	lua.getglobal(engine.L, "_draw")
	if !lua.isfunction(engine.L, -1) {
		lua.pop(engine.L, 1)
		return
	}

	dt := lua.Number(rl.GetFrameTime())
	lua.pushnumber(engine.L, dt)

	lua.call(engine.L, 1, 0)
}

lua_update :: proc() {
	lua.getglobal(engine.L, "_update")
	if !lua.isfunction(engine.L, -1) {
		lua.pop(engine.L, 1)
		return
	}
	dt := lua.Number(rl.GetFrameTime())
	lua.pushnumber(engine.L, dt)

	lua.call(engine.L, 1, 0)
}

register_cookie :: proc() {
	lua.newtable(engine.L)

	lua.pushinteger(engine.L, engine.width)
	lua.setfield(engine.L, -2, "Width")

	lua.pushinteger(engine.L, engine.height)
	lua.setfield(engine.L, -2, "Height")

	lua.pushstring(engine.L, engine.platform)
	lua.setfield(engine.L, -2, "PLATFORM")

	lua.pushboolean(engine.L, cast(b32)engine.is_dev)
	lua.setfield(engine.L, -2, "IS_DEV")

	lua.pushnumber(engine.L, cast(lua.Number)rl.GetTime())
	lua.setfield(engine.L, -2, "elapsed")

	lua.setglobal(engine.L, "cookie")
}

update_elapsed_time :: proc() {
	lua.getglobal(engine.L, "cookie")

	lua.pushnumber(engine.L, cast(lua.Number)rl.GetTime())
	lua.setfield(engine.L, -2, "elapsed")

	lua.pop(engine.L, 1) // pop cookie table
}
