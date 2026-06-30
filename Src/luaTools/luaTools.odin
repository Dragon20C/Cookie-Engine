package LuaTools

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"

tools_local: string = "./Src/luaTools"

load_tools :: proc(L: ^lua.State) {
	load_file(L, "rect.lua")
	// load_file(L, "utils.lua")
	//
	utils_ok, util_path := lua_file_exists("utils.lua")

	if !utils_ok {
		fmt.println("Failed to find utils.lua in tools directory.")
		return
	}

	status := lua.L_loadfile(L, strings.clone_to_cstring(util_path))
	if status != lua.Status.OK {
		fmt.println("Failed to load ", "utils.lua", " from: ", util_path)
		return
	}
	call_status := lua.pcall(L, 0, 1, 0)
	if call_status != 0 {
		fmt.println("Failed to run ", "utils.lua", " from: ", util_path)
		return
	}

	lua.setglobal(L, "utils")


}

load_file :: proc(L: ^lua.State, filename: string) {
	rect_ok, rect_path := lua_file_exists(filename)

	if !rect_ok {
		fmt.println("Failed to find ", filename, " in tools directory.")
		return
	}

	fmt.println("Loading ", filename, " from: ", rect_path)

	status := lua.L_loadfile(L, strings.clone_to_cstring(rect_path))
	if status != lua.Status.OK {
		fmt.println("Failed to load ", filename, " from: ", rect_path)
		return
	}

	call_status := lua.pcall(L, 0, lua.MULTRET, 0)
	if call_status != 0 {
		fmt.println("Failed to run ", filename, " from: ", rect_path)
		return
	}
}

lua_file_exists :: proc(title: string) -> (b32, string) {
	path, err := filepath.join({tools_local, title})
	if err != nil {
		return false, ""
	}

	if os.is_file(path) {
		return true, path
	}

	return false, ""
}
