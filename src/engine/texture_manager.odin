package engine
// Texture manager script.

import conf "../config"
import err "../error"
import "base:runtime"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"

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
