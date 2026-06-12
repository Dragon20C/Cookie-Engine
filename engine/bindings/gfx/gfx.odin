package gfx

import "core:fmt"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

colors: [6]rl.Color = {rl.WHITE, rl.BLACK, rl.RED, rl.GREEN, rl.BLUE, rl.YELLOW}

register_function :: proc(L: ^lua.State, name: cstring, fn: lua.CFunction) {
	lua.pushcfunction(L, fn)
	lua.setfield(L, -2, name)
}

register_color :: proc(L: ^lua.State, name: cstring, index: lua.Integer) {
	lua.pushinteger(L, index)
	lua.setfield(L, -2, name)
}

register_gfx :: proc(L: ^lua.State) {
	lua.newtable(L)
	// registering color constants, I know there is a better way... just lazy.
	register_color(L, "COLOR_WHITE", 0)
	register_color(L, "COLOR_BLACK", 1)
	register_color(L, "COLOR_RED", 2)
	register_color(L, "COLOR_GREEN", 3)
	register_color(L, "COLOR_BLUE", 4)
	register_color(L, "COLOR_YELLOW", 5)

	register_function(L, "clear", clear)

	lua.setglobal(L, "gfx")

}

clear :: proc "c" (L: ^lua.State) -> i32 {
	// default clear always happens
	current_color := colors[0]

	if lua.gettop(L) >= 1 && lua.isnumber(L, 1) {
		v := lua.tointeger(L, 1)

		if v <= len(colors) {
			current_color = colors[v]
		}

	}

	rl.ClearBackground(current_color)
	return 0
}
