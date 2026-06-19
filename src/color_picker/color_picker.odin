package color_picker

import "base:runtime"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

Title: cstring = "Color Picker"
Width: i32 = 640
Height: i32 = 480

color_palette: [16]rl.Color = [16]rl.Color{}

Palette_Item :: struct {
	rect:  rl.Rectangle,
	color: rl.Color,
	hex:   cstring,
	index: i32,
}

palette_data: [16]Palette_Item = {}

main :: proc() {
	run("./")
}

run :: proc(path: string) {
	fmt.println("Path : ", path)
	// Check if the directory exists
	if !os.is_dir(path) {
		fmt.println("directory not found")
		return
	}
	// Join the path to the palette file
	palette_path, err := os.join_path({path, "palette.hex"}, context.allocator)
	// handle failed join errors
	if err != nil {
		fmt.println(err)
		return
	}
	// Check if the palette file exists
	if !os.is_file(palette_path) {
		fmt.println("palette.hex not found")
		return
	}
	color_palette = load_palette(palette_path)
	build_palette_data()
	game_loop()
}

load_palette :: proc(path: string) -> [16]rl.Color {

	palette := [16]rl.Color{}

	data, err := os.read_entire_file(path, context.allocator)
	if err != nil {
		// could not read file
		return palette
	}
	defer delete(data, context.allocator)

	index := 0
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		value, ok := strconv.parse_uint(line, 16)
		if !ok {
			fmt.println("Invalid hex:", line)
			continue
		}

		value = (value << 8) | 0xFF
		color := rl.GetColor(cast(u32)value)

		palette[index] = color
		index += 1
		if index >= 16 {
			break
		}
	}


	return palette
}

game_loop :: proc() {
	rl.SetConfigFlags(rl.ConfigFlags{.WINDOW_RESIZABLE})
	rl.InitWindow(Width, Height, Title)
	rl.SetTargetFPS(12)
	defer rl.CloseWindow()
	for !rl.WindowShouldClose() {
		update()
		draw()
	}
}

update :: proc() {

}
draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.GRAY)

	rl.DrawText(
		"Color Picker",
		Width / 2 - rl.MeasureText("Color Picker", 20) / 2,
		10,
		20,
		rl.WHITE,
	)

	for data in palette_data {
		rl.DrawRectangleRec(data.rect, data.color)

		rl.DrawText(
			data.hex,
			cast(i32)data.rect.x,
			cast(i32)(data.rect.y + data.rect.height + 2),
			10,
			rl.WHITE,
		)
	}
	rl.EndDrawing()
}

build_palette_data :: proc() {
	cols: i32 = 8
	rows: i32 = (len(color_palette) + cols - 1) / cols
	padding: i32 = 12
	cell: i32 = 64
	text_h: i32 = 16
	block_h: i32 = cell + text_h + padding
	grid_w := cols * (cell + padding) - padding
	grid_h := rows * (block_h + padding) - padding
	offset_x := (Width - grid_w) / 2
	offset_y := (Height - grid_h) / 2

	for index: i32 = 0; index < len(color_palette); index += 1 {
		color := color_palette[index]

		col := index % cols
		row := index / cols

		x := offset_x + col * (cell + padding)
		y := offset_y + row * (block_h + padding)

		rect := rl.Rectangle{f32(x), f32(y), f32(cell), f32(cell)}

		palette_data[index] = Palette_Item {
			rect,
			color,
			strings.clone_to_cstring(color_to_hex(color)),
			index,
		}
	}

}

color_to_hex :: proc(c: rl.Color) -> string {
	// assuming rl.Color has r, g, b fields
	return fmt.tprintf("#%02X%02X%02X", c.r, c.g, c.b)
}
