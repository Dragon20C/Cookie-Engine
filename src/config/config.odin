package config
// Config script.

import si "core:sys/info"
import err "../error"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"

Platform :: enum {
	LINUX,
	WINDOWS,
	MAC_OS,
	UNKNOWN
}

Configuration :: struct {
	platform   : Platform,
	engine_dir : string,
	project_dir: string,
	title:       string,
	id:          string,
	is_dev:      bool,
	fullscreen:  bool,
	game_width:  int,
	game_height: int,
}

Config := Configuration {
	platform    = Platform.UNKNOWN,
	engine_dir  = "",
	project_dir = "",
	title       = "Cookie Engine Game",
	id          = "com.cookieengine.game",
	is_dev      = true,
	fullscreen  = false,
	game_width  = 800,
	game_height = 600,
}

L: ^lua.State

read_project_config :: proc() -> err.Error {

	if Config.project_dir == "" {
		return err.Error {
			kind = err.ErrorType.Fatal,
			message = "Project dir is empty or invalid, cookie engine can´t continue.",
		}
	}

	config_file, join_err := filepath.join({Config.project_dir, "config.lua"})
	if join_err != nil {
		err.report_error(
			err.Error {
				kind = err.ErrorType.Warning,
				message = "Failed to join project directory and conf.lua together, defaults are being used instead.",
			},
		)
	}

	if !os.is_file(config_file) {
		// No point in continuing if no config function exists.
		return err.Error {
			kind = err.ErrorType.Fatal,
			message = "No config.lua file found in project directory, defaults are being used instead.",
		}
	}

	L = lua.L_newstate()

	lua.L_openlibs(L)
	lua.L_dofile(L, strings.clone_to_cstring(config_file))
	lua.getglobal(L, "_config")

	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		lua.close(L)
		err.report_error(
			err.Error {
				kind = err.ErrorType.Warning,
				message = "No _config function found in config.lua, defaults are being used instead.",
			},
		)
	}

	lua.call(L, 0, 1)

	if !lua.istable(L, -1) {
		lua.pop(L, 1)
		lua.close(L)
		err.report_error(
			err.Error {
				kind = err.ErrorType.Warning,
				message = "No table returned from _config function in config.lua, defaults are being used instead.",
			},
		)
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
	if !os.is_dir(project_dir) {
		return
	}
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

get_main_lua_file :: proc() -> cstring {
	project_dir := Config.project_dir

	main_lua, join_err := filepath.join({project_dir, "main.lua"})

	if join_err != runtime.Allocator_Error.None {
		err.report_error(
			err.Error{err.ErrorType.Fatal, "Failed to join the project dir to main.lua"},
		)
		return ""
	}

	if os.is_file(main_lua) {
		return strings.clone_to_cstring(main_lua)
	} else {
		err.report_error(err.Error{err.ErrorType.Fatal, "main.lua not found in the project dir."})
		return ""
	}
}

set_platform:: proc(){
	set_os_type()
	set_engine_root()
}

set_os_type :: proc() {
	if version, version_ok := si.os_version(context.allocator); version_ok {
		defer si.destroy_os_version(version, context.allocator)

		#partial switch version.platform {
		case si.OS_Version_Platform.Windows:
			Config.platform = Platform.WINDOWS

		case si.OS_Version_Platform.Linux:
			Config.platform = Platform.LINUX

		case si.OS_Version_Platform.MacOS:
			Config.platform = Platform.MAC_OS

		case:
			Config.platform = Platform.UNKNOWN

		}
	}
}

set_engine_root :: proc(){
	switch Config.platform{
	case Platform.LINUX:
		result := os.get_env_alloc("COOKIE_ENGINE_ROOT",runtime.default_allocator())
		if result == ""{
			err.report_error(err.Error{err.ErrorType.Fatal,"Getting COOKIE_ENGINE_ROOT failed, did you install it correctly?"})
			return
		}
		Config.engine_dir = result

	case Platform.WINDOWS:
		err.report_error(err.Error{err.ErrorType.Fatal,"Sorry, not ready yet..."})
	case Platform.MAC_OS:
		err.report_error(err.Error{err.ErrorType.Fatal,"Sorry, not ready yet..."})
	case Platform.UNKNOWN:
		err.report_error(err.Error{err.ErrorType.Fatal,"Unknown platform found, sorry we dont support it or its not set correctly."})
	}
}

read_version :: proc() -> string {
	text_file , join_err := filepath.join({Config.engine_dir,"version.txt"})

	if join_err != .None{
		fmt.println("Failed to join engine dir to version.txt")
		return "NONE"
	}

	data, ok := os.read_entire_file(text_file, context.temp_allocator)
	if ok != .NONE {
		return "Failed to read the version text..."
	}

	text := string(data)

	if i := strings.index_byte(text, '\n'); i >= 0 {
		return text[:i]
	}

		return text
	}


print_configuration :: proc() {
	fmt.println("Platform :", Config.platform)
	fmt.println("Engine :", Config.engine_dir)
	fmt.println("Project Path :", Config.project_dir)
	fmt.println("Title :", Config.title)
	fmt.println("Game ID :", Config.id)
	fmt.println("Dev Mode :", Config.is_dev)
	fmt.println("Fullscreen:", Config.fullscreen)
	fmt.println("Resolution : X", Config.game_width, " Y", Config.game_height)
}
