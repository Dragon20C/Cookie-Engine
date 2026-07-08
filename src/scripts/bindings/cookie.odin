package bindings
// Cookie script.

import conf "../../config"
import engine "../../engine"
import "base:runtime"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

register_cookie :: proc(L: ^lua.State) {

	is_dev := b32(conf.Config.is_dev)
	width := lua.Integer(conf.Config.game_width)
	height := lua.Integer(conf.Config.game_height)

	lua.newtable(L)

	lua.pushinteger(L, width)
	lua.setfield(L, -2, "WIDTH")

	lua.pushinteger(L, height)
	lua.setfield(L, -2, "HEIGHT")

	lua.pushboolean(L, is_dev)
	lua.setfield(L, -2, "IS_DEV")

	lua.pushnumber(L, 0)
	lua.setfield(L, -2, "Elapsed")

	register_function(L, "FPS", get_fps)
	register_function(L, "scale_window", scale_window)

	lua.setglobal(L, "cookie")

}

scale_window :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) {
		return 0
	}
	context = runtime.default_context()
	engine.scale_window(i32(lua.tonumber(L, 1)))

	return 0
}

update_elapsed_time :: proc(L: ^lua.State) {

	// Pushes the Cookie table onto the stack
	lua.getglobal(L, "cookie")

	// If the Cookie table exists, update the elapsed field
	if lua.istable(L, -1) {
		lua.pushnumber(L, lua.Number(rl.GetTime()))
		lua.setfield(L, -2, "Elapsed")
	}
	// Pops the Cookie table from the stack
	lua.pop(L, 1)
}

get_fps :: proc "c" (L: ^lua.State) -> i32 {
	// Pushes the FPS value onto the stack
	lua.pushinteger(L, lua.Integer(rl.GetFPS()))

	// Returns the FPS value
	return 1
}
