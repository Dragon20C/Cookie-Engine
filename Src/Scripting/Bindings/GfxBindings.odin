package Bindings

import renderer "../../Resource"
import "base:runtime"
import lua "vendor:lua/5.4"

register_gfx :: proc(L: ^lua.State) {
	lua.newtable(L)

	for color, index in &renderer.COLORS_NAME {
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

	register_function(L, "scale_window", scale_window)

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

	color_index := i32(lua.tointeger(L, 1))
	renderer.clear(color_index)

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
	renderer.text(text, x, y, size, color_index)
	return 0
}

rectangle :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isboolean(L, 1) ||
	   !lua.isnumber(L, 2) ||
	   !lua.isnumber(L, 3) ||
	   !lua.isnumber(L, 4) ||
	   !lua.isnumber(L, 5) ||
	   !lua.isinteger(L, 6) {
		return 0
	}

	filled := lua.toboolean(L, 1)
	r_x := f32(lua.tonumber(L, 2))
	r_y := f32(lua.tonumber(L, 3))
	r_width := f32(lua.tonumber(L, 4))
	r_height := f32(lua.tonumber(L, 5))
	color := u32(lua.tointeger(L, 6))

	context = runtime.default_context()
	renderer.rectangle(filled, r_x, r_y, r_width, r_height, color)

	return 0
}

circle :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isboolean(L, 1) ||
	   !lua.isnumber(L, 2) ||
	   !lua.isnumber(L, 3) ||
	   !lua.isnumber(L, 4) ||
	   !lua.isinteger(L, 5) {
		return 0
	}

	filled := lua.toboolean(L, 1)
	x := f32(lua.tonumber(L, 2))
	y := f32(lua.tonumber(L, 3))
	radius := f32(lua.tonumber(L, 4))
	color := lua.tointeger(L, 5)

	context = runtime.default_context()
	renderer.circle(filled, x, y, radius, i32(color))

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
	renderer.line(x1, y1, x2, y2, color)

	return 0
}

load_sheet :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) || !lua.isinteger(L, 2) || !lua.isstring(L, 3) {
		return 0
	}
	context = runtime.default_context()

	id := renderer.load_sheet(
		u32(lua.tointeger(L, 1)),
		u32(lua.tointeger(L, 2)),
		lua.tostring(L, 3),
	)

	lua.pushinteger(L, lua.Integer(id))
	return 1
}

sprite :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isinteger(L, 1) || !lua.isinteger(L, 2) || !lua.isnumber(L, 3) || !lua.isnumber(L, 4) {
		return 0
	}
	context = runtime.default_context()
	renderer.sprite(
		u32(lua.tointeger(L, 1)),
		i32(lua.tointeger(L, 2)),
		f32(lua.tonumber(L, 3)),
		f32(lua.tonumber(L, 4)),
	)
	return 0
}

unload_sheet :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}

	sheet_id := u32(lua.tointeger(L, 1))
	context = runtime.default_context()
	renderer.unload_sheet(sheet_id)
	return 0
}

unload_all_sheets :: proc "c" () {
	context = runtime.default_context()
	renderer.unload_all_sheets()
}

scale_window :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}
	context = runtime.default_context()
	renderer.scale_window(i32(lua.tointeger(L, 1)))

	return 0
}
