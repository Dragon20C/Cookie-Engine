package engine
// Palette script.

import conf "../config"
import err "../error"
import "base:runtime"
import "core:os"
import "core:path/filepath"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

palette: [16]rl.Color = [16]rl.Color{}

COLORS :: [16]u32 {
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
COLORS_NAME :: [16]cstring {
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

setup_color_palette :: proc() {
	path := conf.Config.project_dir

	palette_path, join_err := filepath.join({path, "palette.hex"})
	if join_err != runtime.Allocator_Error.None {
		err.report_error(
			err.Error{err.ErrorType.Warning, "Failed to join project path to palette.hex."},
		)
		return
	}

	if !os.is_file(palette_path) {
		err.report_error(
			err.Error {
				err.ErrorType.Warning,
				"palette.hex file does not exist in the project directory.",
			},
		)
		palette = load_default_palette()
		return
	}
	palette = load_palette(palette_path)

}

load_default_palette :: proc() -> [16]rl.Color {
	palette := [16]rl.Color{}

	for hex, index in COLORS {
		color := rl.GetColor(hex)
		palette[index] = color
	}

	return palette
}

load_palette :: proc(path: string) -> [16]rl.Color {

	palette := [16]rl.Color{}

	data, read_err := os.read_entire_file(path, context.allocator)
	if read_err != nil {
		err.report_error(err.Error{err.ErrorType.Warning, "Failed to read the path."})
		return palette
	}
	defer delete(data, context.allocator)

	index := 0
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		value, ok := strconv.parse_uint(line, 16)
		if !ok {
			msg := strings.concatenate({"Invalid hex found : ", line})
			err.report_error(err.Error{err.ErrorType.Warning, msg})
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
