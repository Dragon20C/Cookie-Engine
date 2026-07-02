package config
// Config script.

import err "../error"
import "core:os"
import "core:path/filepath"
import lua "vendor:lua/5.4"


L: ^lua.State

read_project_config :: proc(project_dir: string) -> err.Error {

	config_file, join_err := filepath.join({project_dir, "config.lua"})
	if join_err != nil {
		return err.Error {
			kind = err.ErrorType.Warning,
			message = "Failed to join project directory and conf.lua together, defaults are being used instead.",
		}
	}

	if !os.is_file(config_file) {
		return err.Error {
			kind = err.ErrorType.Warning,
			message = "No conf.lua file found in project directory, defaults are being used instead.",
		}
	}


	L = lua.L_newstate()


	lua.close(L)
	return err.Error{kind = err.ErrorType.None, message = ""}
}
