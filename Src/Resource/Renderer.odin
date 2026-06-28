package Resource

import "base:runtime"
import "core:fmt"
import "core:path/filepath"
import "core:strings"
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

sheet_texture :: struct {
	cell_width:  u32,
	cell_height: u32,
	rows:        i32,
	cols:        i32,
	texture:     rl.Texture2D,
}

sheets: map[u32]sheet_texture
draw_thickness: i32 = 2

clear :: proc(color_index: i32) {
	context = runtime.default_context()

	if color_index < 0 || color_index >= len(COLORS) {
		fmt.println("Out of bounds color index: ", color_index)
	}

	color := rl.GetColor(COLORS[color_index])
	rl.ClearBackground(color)
}

rectangle :: proc(filled: b32, r_x: f32, r_y: f32, r_width: f32, r_height: f32, color_index: u32) {


	if color_index >= len(COLORS) {
		return
	}

	rect := rl.Rectangle {
		x      = r_x,
		y      = r_y,
		width  = r_width,
		height = r_height,
	}

	raylib_color := rl.GetColor(COLORS[color_index])

	if filled {
		rl.DrawRectangleRec(rect, raylib_color)
	} else {
		rl.DrawRectangleLinesEx(rect, f32(draw_thickness), raylib_color)
	}
}

line :: proc(x1: i32, y1: i32, x2: i32, y2: i32, color_index: i32) {

	if color_index >= len(COLORS) {
		return
	}
	color := rl.GetColor(COLORS[color_index])
	start := rl.Vector2{f32(x1), f32(y1)}
	end := rl.Vector2{f32(x2), f32(y2)}
	rl.DrawLineEx(start, end, f32(draw_thickness), color)
}

circle :: proc(filled: b32, x: f32, y: f32, radius: f32, color_index: i32) {

	if color_index >= len(COLORS) {
		return
	}

	color := rl.GetColor(COLORS[color_index])

	pos := rl.Vector2{x, y}
	if filled {
		rl.DrawCircleV(pos, radius, color)
	} else {
		rl.DrawCircleLinesV(pos, radius, color)
	}
}

text :: proc(text: cstring, x: i32, y: i32, size: i32, color_index: i32) {
	if color_index < 0 || color_index >= 16 {
		return
	}

	color := COLORS[color_index]
	rl.DrawText(text, i32(x), i32(y), i32(size), rl.GetColor(color))
}

load_sheet :: proc(cell_width: u32, cell_height: u32, path: cstring) -> u32 {
	context = runtime.default_context()

	sheet_path, err := filepath.join({game_dir, strings.clone_from_cstring(path)})
	if err != nil {
		fmt.println("Failed to join sheet path: ", err)
		return 0
	}

	texture := rl.LoadTexture(strings.clone_to_cstring(sheet_path))
	id := texture.id

	columns := f32(texture.width) / f32(cell_width)
	rows := f32(texture.height) / f32(cell_height)

	sheet := sheet_texture {
		cell_width  = cell_width,
		cell_height = cell_height,
		rows        = i32(rows),
		cols        = i32(columns),
		texture     = texture,
	}
	sheets[id] = sheet
	return id
}

unload_sheet :: proc(sheet_id: u32) {
	if sheet_id in sheets {
		rl.UnloadTexture(sheets[sheet_id].texture)
		delete_key(&sheets, sheet_id)
	}
}

unload_all_sheets :: proc() {
	for _, sheet in sheets {
		rl.UnloadTexture(sheet.texture)
	}
	clear_map(&sheets)
}


sprite :: proc(sheet_id: u32, frame_id: i32, x: f32, y: f32) {
	context = runtime.default_context()

	if !(sheet_id in sheets) {
		fmt.println("Sheet not found: ", sheet_id)
	}

	sheet := sheets[sheet_id]

	cell_x := f32((frame_id % sheet.cols) * i32(sheet.cell_width))
	cell_y := f32((frame_id / sheet.cols) * i32(sheet.cell_height))

	rect := rl.Rectangle{cell_x, cell_y, f32(sheet.cell_width), f32(sheet.cell_height)}
	rl.DrawTextureRec(sheet.texture, rect, rl.Vector2{x, y}, rl.WHITE)
}

scale_window :: proc(scale: i32) {
	rl.SetWindowSize(game_width * scale, game_height * scale)
}
