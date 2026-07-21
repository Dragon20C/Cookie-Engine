package bindings
// Graphics bindings.

import conf "../../config"
import engine "../../engine"
import err "../../error"
import "base:runtime"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

register_graphics :: proc(L: ^lua.State) {
	lua.newtable(L)

	for color, index in engine.COLORS_NAME {
		register_color(L, color, lua.Integer(index))
	}

	register_function(L, "clear", clear)
	register_function(L, "rectangle", rectangle)
	register_function(L, "line", line)
	register_function(L, "circle", circle)
	register_function(L, "text", text)

	register_function(L, "load_sheet", load_sheet)
	register_function(L, "sprite", sprite)
	register_function(L, "unload_sheet", unload_sheet)

	lua.setglobal(L, "gfx")

}


register_color :: proc(L: ^lua.State, name: cstring, index: lua.Integer) {
	lua.pushinteger(L, index)
	lua.setfield(L, -2, name)
}

clear :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "clear: color index must be an integer")
		return 0
	}

	color_index: i32 = i32(lua.tointeger(L, 1))

	engine.clear(color_index)

	return 0
}

text :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isstring(L, 1) ||
	   !lua.isnumber(L, 2) ||
	   !lua.isnumber(L, 3) ||
	   !lua.isnumber(L, 4) ||
	   !lua.isnumber(L, 5) {
		return 0
	}

	text := lua.tostring(L, 1)
	x := i32(lua.tonumber(L, 2))
	y := i32(lua.tonumber(L, 3))
	size := i32(lua.tonumber(L, 4))
	color_index := i32(lua.tointeger(L, 5))

	context = runtime.default_context()
	engine.text(text, x, y, size, color_index)
	return 0
}

rectangle :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) ||
	   !lua.isnumber(L, 2) ||
	   !lua.isnumber(L, 3) ||
	   !lua.isnumber(L, 4) ||
	   !lua.isinteger(L, 5) {
		return 0
	}

	r_x := f32(lua.tonumber(L, 1))
	r_y := f32(lua.tonumber(L, 2))
	r_width := f32(lua.tonumber(L, 3))
	r_height := f32(lua.tonumber(L, 4))
	color := i32(lua.tointeger(L, 5))
	filled := true

	if lua.gettop(L) >= 6 && lua.isboolean(L,6) {
		filled = bool(lua.toboolean(L,6))
	}

	context = runtime.default_context()
	engine.rectangle(r_x, r_y, r_width, r_height, color,filled)

	return 0
}

circle :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) || !lua.isnumber(L, 2) || !lua.isnumber(L, 3) || !lua.isinteger(L, 4) {
		return 0
	}

	x := i32(lua.tonumber(L, 1))
	y := i32(lua.tonumber(L, 2))
	radius := f32(lua.tonumber(L, 3))
	color := i32(lua.tointeger(L, 4))

	context = runtime.default_context()
	engine.circle(x, y, radius, color)

	return 0
}

line :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) ||
	   !lua.isnumber(L, 2) ||
	   !lua.isnumber(L, 3) ||
	   !lua.isnumber(L, 4) ||
	   !lua.isinteger(L, 5) {
		return 0
	}

	x1 := i32(lua.tonumber(L, 1))
	y1 := i32(lua.tonumber(L, 2))
	x2 := i32(lua.tonumber(L, 3))
	y2 := i32(lua.tonumber(L, 4))
	color := i32(lua.tointeger(L, 5))

	context = runtime.default_context()
	engine.line(x1, y1, x2, y2, color)

	return 0
}

load_sheet :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) || !lua.isinteger(L, 2) || !lua.isstring(L, 3) {
		return 0
	}
	context = runtime.default_context()

	id := engine.load_sheet(i32(lua.tointeger(L, 1)), i32(lua.tointeger(L, 2)), lua.tostring(L, 3))

	lua.pushinteger(L, lua.Integer(id))
	return 1
}

sprite :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isinteger(L, 1) || !lua.isinteger(L, 2) || !lua.isnumber(L, 3) || !lua.isnumber(L, 4) {
		return 0
	}

	flipped : b32 = false
	rot : f32 = 0.0

	if lua.gettop(L) >= 5 && lua.isboolean(L,5) {
		flipped = lua.toboolean(L,5)
	}

	if lua.gettop(L) >= 6 && lua.isnumber(L,6) {
		rot = f32(lua.tonumber(L,6))
	}

	context = runtime.default_context()
	engine.draw_sprite(
		i32(lua.tointeger(L, 1)),
		i32(lua.tointeger(L, 2)),
		f32(lua.tonumber(L, 3)),
		f32(lua.tonumber(L, 4)),
		flipped,
		rot
	)
	return 0
}

unload_sheet :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}

	sheet_id := i32(lua.tointeger(L, 1))
	context = runtime.default_context()
	engine.unload_sheet(sheet_id)
	return 0
}

unload_all_sheets :: proc "c" () {
	context = runtime.default_context()
	engine.unload_all_sheets()
}
