package gfx

import h "../helper"
import palette "../palette"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

import lua "vendor:lua/5.4"
import rl "vendor:raylib"

sprites: rl.Texture2D

load :: proc(L: ^lua.State) {
	lua.newtable(L)
	register_color_palette(L)
	h.register_function(L, "clear", clear)
	h.register_function(L, "sprite", sprite)
	h.register_function(L, "text", text)
	h.register_function(L, "rect", rect)
	h.register_function(L, "rect_fill", rect_fill)
	h.register_function(L, "circle", circle)
	h.register_function(L, "circle_fill", circle_fill)

	lua.setglobal(L, "gfx")

}

register_color :: proc(L: ^lua.State, name: cstring, index: lua.Integer) {
	lua.pushinteger(L, index)
	lua.setfield(L, -2, name)
}

register_color_palette :: proc(L: ^lua.State) {
	register_color(L, "COLOR_BLACK", 0)
	register_color(L, "COLOR_BROWN", 1)
	register_color(L, "COLOR_TANG", 2)
	register_color(L, "COLOR_ORANGE", 3)
	register_color(L, "COLOR_CARDBOARD", 4)
	register_color(L, "COLOR_YELLOW", 5)
	register_color(L, "COLOR_WHITE", 6)
	register_color(L, "COLOR_LEAF", 7)
	register_color(L, "COLOR_MINT", 8)
	register_color(L, "COLOR_GREEN", 9)
	register_color(L, "COLOR_DARK_BLUE", 10)
	register_color(L, "COLOR_BLUE", 11)
	register_color(L, "COLOR_PURPLE", 12)
	register_color(L, "COLOR_PINK", 13)
	register_color(L, "COLOR_RED", 14)
	register_color(L, "COLOR_DARK_RED", 15)
}

clear :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) {
		lua.L_error(L, "gfx.clear expects 1 argument")
		return 0
	}

	color := cast(i32)lua.tonumber(L, 1)
	if color < 0 || color >= len(palette.color_palette) {
		lua.L_error(L, "gfx.clear: color index out of range")
		return 0
	}

	rl.ClearBackground(palette.color_palette[color])
	return 0
}

sprite :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	if !lua.isinteger(L, 1) {
		fmt.println("Sprite id was not an integer")
		return 0
	}

	id := cast(i32)lua.tointeger(L, 1)

	if !lua.isnumber(L, 2) || !lua.isnumber(L, 3) {
		fmt.println("Sprite position was not an integer")
		return 0
	}

	x := cast(f32)lua.tonumber(L, 2)
	y := cast(f32)lua.tonumber(L, 3)

	// I shouldnt be hard coding it here, but im lazy and the whole system is a mess lol
	cell_size: f32 = 16

	cols := f32(sprites.width) / cell_size
	rows := f32(sprites.height) / cell_size
	// fmt.println("cols:", cols, "rows:", rows)
	sprite_x := i32(id) % i32(cols)
	sprite_y := f32(id) / cols
	rect := rl.Rectangle{cast(f32)sprite_x, sprite_y, cell_size, cell_size}
	rl.DrawTextureRec(sprites, rect, rl.Vector2{x, y}, rl.WHITE)
	return 0
}

rect :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) || !lua.isnumber(L, 2) || !lua.isnumber(L, 3) || !lua.isnumber(L, 4) {
		lua.L_error(L, "gfx.rect expects 4 arguments")
		return 0
	}

	x := cast(i32)lua.tonumber(L, 1)
	y := cast(i32)lua.tonumber(L, 2)
	w := cast(i32)lua.tonumber(L, 3)
	h := cast(i32)lua.tonumber(L, 4)

	if !lua.isnumber(L, 5) {
		lua.L_error(L, "gfx.rect: color index out of range")
		return 0
	}

	color := cast(i32)lua.tonumber(L, 5)
	if color < 0 || color >= len(palette.color_palette) {
		lua.L_error(L, "gfx.rect: color index out of range")
		return 0
	}

	rl.DrawRectangleLines(x, y, w, h, palette.color_palette[color])
	return 0
}

rect_fill :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) || !lua.isnumber(L, 2) || !lua.isnumber(L, 3) || !lua.isnumber(L, 4) {
		lua.L_error(L, "gfx.rect expects 4 arguments")
		return 0
	}

	x := cast(i32)lua.tonumber(L, 1)
	y := cast(i32)lua.tonumber(L, 2)
	w := cast(i32)lua.tonumber(L, 3)
	h := cast(i32)lua.tonumber(L, 4)

	if !lua.isnumber(L, 5) {
		lua.L_error(L, "gfx.rect: color index out of range")
		return 0
	}

	color := cast(i32)lua.tonumber(L, 5)
	if color < 0 || color >= len(palette.color_palette) {
		lua.L_error(L, "gfx.rect: color index out of range")
		return 0
	}

	rl.DrawRectangle(x, y, w, h, palette.color_palette[color])
	return 0
}

text :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isstring(L, 1) ||
	   !lua.isnumber(L, 2) ||
	   !lua.isnumber(L, 3) ||
	   !lua.isnumber(L, 4) ||
	   !lua.isnumber(L, 5) {
		lua.L_error(L, "gfx.text expects 5 arguments")
		return 0
	}

	str := lua.tostring(L, 1)
	x := cast(i32)lua.tonumber(L, 2)
	y := cast(i32)lua.tonumber(L, 3)
	size := cast(i32)lua.tonumber(L, 4)
	color := cast(i32)lua.tonumber(L, 5)

	if color < 0 || color >= len(palette.color_palette) {
		lua.L_error(L, "gfx.text: color index out of range")
		return 0
	}

	rl.DrawText(str, x, y, size, palette.color_palette[color])
	return 0
}

circle :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) || !lua.isnumber(L, 2) || !lua.isnumber(L, 3) || !lua.isnumber(L, 4) {
		lua.L_error(L, "gfx.circle: expects 4 arguments")
		return 0
	}

	x := cast(i32)lua.tonumber(L, 1)
	y := cast(i32)lua.tonumber(L, 2)
	radius := cast(f32)lua.tonumber(L, 3)
	color := cast(i32)lua.tonumber(L, 4)

	if color < 0 || color >= len(palette.color_palette) {
		lua.L_error(L, "gfx.circle: color index out of range")
		return 0
	}

	rl.DrawCircle(x, y, radius, palette.color_palette[color])
	return 0
}

circle_fill :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isnumber(L, 1) || !lua.isnumber(L, 2) || !lua.isnumber(L, 3) || !lua.isnumber(L, 4) {
		lua.L_error(L, "gfx.circle_fill: expects 4 arguments")
		return 0
	}

	x := cast(i32)lua.tonumber(L, 1)
	y := cast(i32)lua.tonumber(L, 2)
	radius := cast(f32)lua.tonumber(L, 3)
	color := cast(i32)lua.tonumber(L, 4)

	if color < 0 || color >= len(palette.color_palette) {
		lua.L_error(L, "gfx.circle_fill: color index out of range")
		return 0
	}

	rl.DrawCircleLines(x, y, radius, palette.color_palette[color])
	return 0
}

load_sprites :: proc(path: string) {
	sprites_path, err := filepath.join({path, "sprites.png"})

	if err != nil {
		fmt.println("Failed to join sprites path: %s", err)
		return
	}

	if os.is_file(sprites_path) {
		sprites = rl.LoadTexture(strings.clone_to_cstring(sprites_path))
	} else {
		fmt.println("Failed to load sprites: %s", sprites_path)
		return
	}
}
