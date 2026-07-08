package engine
// Texture manager script.

import conf "../config"
import err "../error"
import "base:runtime"
import "core:os"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"

sheet_texture :: struct {
	cell_width:  i32,
	cell_height: i32,
	rows:        i32,
	cols:        i32,
	texture:     rl.Texture2D,
}

sheets: map[i32]sheet_texture

load_project_icon :: proc() {
	path := conf.Config.project_dir

	if path == "" {
		err.report_error(
			err.Error{err.ErrorType.Warning, "Failed to load project icon because path is empty."},
		)
		return
	}

	icon_path, join_err := filepath.join({path, "icon.png"})
	if join_err != runtime.Allocator_Error.None {
		err.report_error(
			err.Error{err.ErrorType.Warning, "Failed to join the project path and icon.png."},
		)
		return
	}
	icon := rl.LoadImage(strings.clone_to_cstring(icon_path))
	rl.SetWindowIcon(icon)
}

clear :: proc(color_index: i32) {
	color := palette[color_index]
	rl.ClearBackground(color)
}

rectangle :: proc(x: i32, y: i32, width: i32, height: i32, color_index: i32) {
	color := palette[color_index]
	rl.DrawRectangle(x, y, width, height, color)
}

circle :: proc(x: i32, y: i32, radius: f32, color_index: i32) {
	color := palette[color_index]
	rl.DrawCircle(x, y, radius, color)
}

line :: proc(x1: i32, y1: i32, x2: i32, y2: i32, color_index: i32) {
	color := palette[color_index]
	rl.DrawLine(x1, y1, x2, y2, color)
}

text :: proc(text: cstring, x: i32, y: i32, size: i32, color_index: i32) {
	color := palette[color_index]
	rl.DrawText(text, x, y, size, color)
}

// Sheet procs //

load_sheet :: proc(cell_width: i32, cell_height: i32, sheet_path: cstring) -> i32 {
	context = runtime.default_context()
	path := conf.Config.project_dir

	sheet_path, join_err := filepath.join({path, strings.clone_from_cstring(sheet_path)})
	if join_err != nil {
		err.report_error(err.Error{err.ErrorType.Runtime, "Failed to join the path together"})
		return 0
	}

	texture := rl.LoadTexture(strings.clone_to_cstring(sheet_path))
	id := i32(texture.id)

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

unload_sheet :: proc(sheet_id: i32) {
	if sheet_id in sheets {
		rl.UnloadTexture(sheets[sheet_id].texture)
		delete_key(&sheets, sheet_id)
	}
}

draw_sprite :: proc(sheet_id: i32, frame_id: i32, x: i32, y: i32) {
	context = runtime.default_context()

	if !(sheet_id in sheets) {
		err.report_error(err.Error{err.ErrorType.Runtime, "Sheet id does not exist."})
		return
	}

	sheet := sheets[sheet_id]

	cell_x := f32((frame_id % sheet.cols) * i32(sheet.cell_width))
	cell_y := f32((frame_id / sheet.cols) * i32(sheet.cell_height))

	rect := rl.Rectangle{cell_x, cell_y, f32(sheet.cell_width), f32(sheet.cell_height)}
	rl.DrawTextureRec(sheet.texture, rect, rl.Vector2{f32(x), f32(y)}, rl.WHITE)
}

unload_all_sheets :: proc() {
	for _, sheet in sheets {
		rl.UnloadTexture(sheet.texture)
	}
	clear_map(&sheets)
}

scale_window :: proc(scale: i32) {
	width := i32(conf.Config.game_width) * scale
	height := i32(conf.Config.game_height) * scale

	monitor := rl.GetCurrentMonitor()
	screen_width := i32(rl.GetMonitorWidth(monitor))
	screen_height := i32(rl.GetMonitorHeight(monitor))

	rl.SetWindowSize(width, height)

	x := (screen_width - width) / 2
	y := (screen_height - height) / 2

	rl.SetWindowPosition(x, y)
}
