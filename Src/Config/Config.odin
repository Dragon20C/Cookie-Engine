package Config

import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"

CONF_L := lua.L_newstate()

Config :: struct {
	game_path: string,
	is_dev:    bool,
	title:     string,
	id:        string,
	width:     i32,
	height:    i32,
}

make_config :: proc() -> Config {
	return Config {
		game_path = "",
		is_dev = false,
		title = "Cookie Engine",
		id = "UserName:GameTitle",
		width = 640,
		height = 480,
	}
}

read_config :: proc(project_dir: string, is_dev: bool) -> (conf: Config, ok: bool, err: string) {

	conf_data := make_config()

	conf_data.game_path = project_dir
	conf_data.is_dev = is_dev

	conf_lua, join_err := filepath.join({project_dir, "conf.lua"})

	if join_err != nil {
		return conf_data, false, "Failed to join conf.lua path."
	}

	if !os.is_file(conf_lua) {
		return conf_data, false, "conf.lua not found."
	}

	lua.L_openlibs(CONF_L)
	lua.L_dofile(CONF_L, strings.clone_to_cstring(conf_lua))
	lua.getglobal(CONF_L, "_config")

	if !lua.isfunction(CONF_L, -1) {
		lua.pop(CONF_L, 1)
		lua.close(CONF_L)
		return conf_data, false, "lua did not return a function."
	}

	lua.call(CONF_L, 0, 1)

	if !lua.istable(CONF_L, -1) {
		lua.pop(CONF_L, 1)
		lua.close(CONF_L)
		return conf_data, false, "_config did not return a table."
	}

	lua.getfield(CONF_L, -1, "title")

	if lua.isstring(CONF_L, -1) {
		conf_data.title = strings.clone_from_cstring(lua.tostring(CONF_L, -1))
	}

	lua.pop(CONF_L, 1)

	lua.getfield(CONF_L, -1, "id")

	if lua.isstring(CONF_L, -1) {
		conf_data.id = strings.clone_from_cstring(lua.tostring(CONF_L, -1))
	}

	lua.pop(CONF_L, 1)

	if !game_id_valid(conf_data.id) {
		return conf_data, false, "id is invalid, valid example : UserName.GameTitle"
	}

	lua.getfield(CONF_L, -1, "width")
	if lua.isinteger(CONF_L, -1) {
		conf_data.width = i32(lua.tointeger(CONF_L, -1))
	}

	lua.pop(CONF_L, 1)

	lua.getfield(CONF_L, -1, "height")
	if lua.isinteger(CONF_L, -1) {
		conf_data.height = i32(lua.tointeger(CONF_L, -1))
	}

	lua.pop(CONF_L, 1)

	lua.close(CONF_L)

	return conf_data, true, ""
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
