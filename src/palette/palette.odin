package palette

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

color_palette: [16]rl.Color = [16]rl.Color{}

load_palette_from_file :: proc(path: string) -> bool {

	hex_file, hex_err := os.join_path({path, "palette.hex"}, context.allocator)
	if hex_err != nil {
		fmt.println("Could not join path:", hex_err)
		return false
	}

	if !os.is_file(hex_file) {
		fmt.println("No palette file found:", hex_file)
		return false
	}

	data, read_err := os.read_entire_file(hex_file, context.allocator)
	if read_err != nil {
		fmt.println("Could not read file:", read_err)
		return false
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

		color_palette[index] = color
		index += 1
		if index >= 16 {
			break
		}
	}

	return true
}
