package Bindings

import "base:runtime"
import "core:c"
import "core:fmt"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

COLORS: [16]u32 = {
	0x000000FF, // 0 black
	0xBA6B4AFF, // 1 clay
	0xF47F57FF, // 2 coral
	0xFF8A35FF, // 3 orange
	0xECC895FF, // 4 sand
	0xFFE57DFF, // 5 honey
	0xFDFDFCFF, // 6 ivory
	0xBAC867FF, // 7 olive
	0x98DBBEFF, // 8 mint
	0x0D9B76FF, // 9 jade
	0x164475FF, // 10 navy
	0x1673FFFF, // 11 azure
	0x9872AFFF, // 12 amethyst
	0xFFB1CBFF, // 13 candy
	0xFE3648FF, // 14 watermelon
	0xDA4D52FF, // 15 rose
}
COLORS_NAME: [16]cstring = {
	"BLACK",
	"CLAY",
	"CORAL",
	"ORANGE",
	"SAND",
	"HONEY",
	"IVORY",
	"OLIVE",
	"MINT",
	"JADE",
	"NAVY",
	"AZURE",
	"AMETHYST",
	"CANDY",
	"WATERMELON",
	"ROSE",
}
thickness := f32(2)

register_gfx :: proc(L: ^lua.State) {
	lua.newtable(L)

	for color, index in COLORS_NAME {
		register_color(L, color, lua.Integer(index))
	}

	register_function(L, "clear", clear)
	register_function(L, "rectangle", rectangle)
	register_function(L, "line", line)
	register_function(L, "circle", circle)

	lua.setglobal(L, "gfx")
}

register_color :: proc(L: ^lua.State, name: cstring, index: lua.Integer) {
	lua.pushinteger(L, index)
	lua.setfield(L, -2, name)
}

clear :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	if !lua.isinteger(L, 1) {
		return 0
	}

	color_index := lua.tointeger(L, 1)

	if color_index < 0 || color_index >= 16 {

		return 0
	}

	color := COLORS[color_index]
	rl.ClearBackground(rl.GetColor(color))

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
	color := lua.tointeger(L, 6)

	rect := rl.Rectangle {
		x      = r_x,
		y      = r_y,
		width  = r_width,
		height = r_height,
	}

	raylib_color := rl.GetColor(COLORS[color])

	if filled {
		rl.DrawRectangleRec(rect, raylib_color)
	} else {
		rl.DrawRectangleLinesEx(rect, thickness, raylib_color)
	}

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

	raylib_color := rl.GetColor(COLORS[color])
	pos := rl.Vector2{x, y}
	if filled {
		rl.DrawCircleV(pos, radius, raylib_color)
	} else {
		rl.DrawCircleLinesV(pos, radius, raylib_color)
	}

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

	x1 := f32(lua.tonumber(L, 1))
	y1 := f32(lua.tonumber(L, 2))
	x2 := f32(lua.tonumber(L, 3))
	y2 := f32(lua.tonumber(L, 4))
	color := lua.tointeger(L, 5)

	raylib_color := rl.GetColor(COLORS[color])
	start := rl.Vector2{x1, y1}
	end := rl.Vector2{x2, y2}
	rl.DrawLineEx(start, end, thickness, raylib_color)

	return 0
}
