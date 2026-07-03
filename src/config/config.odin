package config
// Config script.

import err "../error"
import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"

Configuration :: struct {
	project_dir: string,
	title:       string,
	id:          string,
	is_dev:      bool,
	game_width:  int,
	game_height: int,
}

Config := Configuration {
	project_dir = "",
	title       = "Cookie Engine Game",
	id          = "com.cookieengine.game",
	is_dev      = true,
	game_width  = 800,
	game_height = 600,
}

L: ^lua.State

read_project_config :: proc() -> err.Error {

	config_file, join_err := filepath.join({Config.project_dir, "config.lua"})
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

	lua.L_openlibs(L)
	lua.L_dofile(L, strings.clone_to_cstring(config_file))
	lua.getglobal(L, "_config")

	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		lua.close(L)
		return err.Error {
			kind = err.ErrorType.Warning,
			message = "No _config function found in config.lua, defaults are being used instead.",
		}
	}

	lua.call(L, 0, 1)

	if !lua.istable(L, -1) {
		lua.pop(L, 1)
		lua.close(L)
		return err.Error {
			kind = err.ErrorType.Warning,
			message = "No table returned from _config function in config.lua, defaults are being used instead.",
		}
	}

	lua.getfield(L, -1, "title")

	if lua.isstring(L, -1) {
		set_project_title(strings.clone_from_cstring(lua.tostring(L, -1)))
	}

	lua.pop(L, 1)

	lua.getfield(L, -1, "id")

	if lua.isstring(L, -1) {
		id_err := set_project_id(strings.clone_from_cstring(lua.tostring(L, -1)))
		if id_err.kind != err.ErrorType.None {
			lua.pop(L, 1)
			lua.close(L)
			return id_err
		}
	}

	lua.pop(L, 1)
	width: int = 0
	height: int = 0

	lua.getfield(L, -1, "width")
	if lua.isinteger(L, -1) {
		width = int(lua.tointeger(L, -1))
	}

	lua.pop(L, 1)

	lua.getfield(L, -1, "height")
	if lua.isinteger(L, -1) {
		height = int(lua.tointeger(L, -1))
	}

	lua.pop(L, 1)

	set_project_game_resolution(width, height)
	lua.close(L)

	return err.Error{kind = err.ErrorType.None, message = ""}
}

set_project_dir :: proc(project_dir: string) {
	Config.project_dir = project_dir
}

set_project_title :: proc(title: string) {
	Config.title = title
}

set_project_id :: proc(id: string) -> err.Error {
	if !game_id_valid(id) {
		return err.Error {
			kind = err.ErrorType.Warning,
			message = "Invalid game ID, defaults are being used instead.",
		}
	}
	Config.id = id

	return err.Error{kind = err.ErrorType.None, message = ""}
}

set_project_is_dev :: proc(is_dev: bool) {
	Config.is_dev = is_dev
}

set_project_game_resolution :: proc(width: int, height: int) {
	if width <= 0 || height <= 0 {
		return
	}
	Config.game_width = width
	Config.game_height = height
}

game_id_valid :: proc(id: string) -> bool {
	if strings.contains_space(id) {
		return false
	}
	if id == "" {
		return false
	}

	return true
}
