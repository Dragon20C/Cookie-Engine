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
	register_function(L, "rect", rect)

	lua.setglobal(L, "gfx")

}

clear :: proc "c" (L: ^lua.State) -> i32 {
	// default clear always happens
	current_color := colors[0]

	if !lua.isnumber(L, 1) {
		lua.L_error(L, "gfx.clear expects 1 argument")
		return 0
	}

	if lua.gettop(L) >= 1 {
		v := lua.tointeger(L, 1)
		// make sure its in range of 0 to colors length - 1
		if v <= len(colors) - 1 {
			current_color = colors[v]
		}

	}

	rl.ClearBackground(current_color)
	return 0
}

rect :: proc "c" (L: ^lua.State) -> i32 {
	if lua.gettop(L) != 5 {
		lua.L_error(L, "gfx.rect(x, y, width, height, color) expects 5 arguments")
	}

	if !lua.isnumber(L, 1) {
		lua.L_error(L, "gfx.rect: x must be a number")
	}

	if !lua.isnumber(L, 2) {
		lua.L_error(L, "gfx.rect: y must be a number")
	}

	if !lua.isnumber(L, 3) {
		lua.L_error(L, "gfx.rect: width must be a number")
	}

	if !lua.isnumber(L, 4) {
		lua.L_error(L, "gfx.rect: height must be a number")
	}

	if !lua.isnumber(L, 5) {
		lua.L_error(L, "gfx.rect: color must be a number")
	}

	x := cast(i32)lua.tonumber(L, 1)
	y := cast(i32)lua.tonumber(L, 2)
	width := cast(i32)lua.tonumber(L, 3)
	height := cast(i32)lua.tonumber(L, 4)
	color := cast(i32)lua.tonumber(L, 5)

	if color < 0 || color >= len(colors) {
		lua.L_error(L, "gfx.rect: color index out of range")
		return 0
	}

	rl.DrawRectangle(x, y, width, height, colors[color])
	return 0
}
