package config

import "core:fmt"
import "core:strings"
import lua "vendor:lua/5.4"

Config :: struct {
	title:   string,
	game_id: string,
	width:   int,
	height:  int,
	scale:   f32,
}


default_config: Config = {
	title   = "Cookie Engine",
	game_id = "Cookie.Game",
	width   = 640,
	height  = 360,
	scale   = 1.0,
}

current_config: Config = default_config

read_config :: proc(L: ^lua.State) -> bool {
	lua.getglobal(L, "_config")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		fmt.println("No _config function defined")
		return false
	}
	lua.call(L, 0, 1)

	if !lua.istable(L, -1) {
		lua.pop(L, 1)
		fmt.println("Config function did not return a table")
		return false
	}
	// Get the title field from the config table
	lua.getfield(L, -1, "title")
	if !lua.isstring(L, -1) {
		lua.pop(L, 2)
		fmt.println("Config table must have a title field")
		return false
	}
	// for some reason, lua.isstring returns true for numbers, why...
	if lua.isnumber(L, -1) {
		lua.pop(L, 2)
		fmt.println("Config table must have a title field")
		return false
	}

	current_config.title = strings.clone_from_cstring(lua.tostring(L, -1))
	lua.pop(L, 1)

	lua.getfield(L, -1, "id")
	if !lua.isstring(L, -1) {
		lua.pop(L, 2)
		fmt.println("Config table must have an id field")
		return false
	}
	// for some reason, lua.isstring returns true for numbers, why...
	if lua.isnumber(L, -1) {
		lua.pop(L, 2)
		fmt.println("Config table must have a id field")
		return false
	}

	current_config.game_id = strings.clone_from_cstring(lua.tostring(L, -1))
	lua.pop(L, 1)

	lua.getfield(L, -1, "width")
	if lua.isnumber(L, -1) {
		current_config.width = int(lua.tointeger(L, -1))
	}
	lua.pop(L, 1)

	lua.getfield(L, -1, "height")
	if lua.isnumber(L, -1) {
		current_config.height = int(lua.tointeger(L, -1))
	}
	lua.pop(L, 1)

	lua.getfield(L, -1, "scale")
	if lua.isnumber(L, -1) {
		current_config.scale = f32(lua.tonumber(L, -1))
	}

	// need to pop 2 to account for the table and the field
	lua.pop(L, 2)
	return true
}
