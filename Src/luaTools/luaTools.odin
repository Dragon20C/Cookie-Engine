package LuaTools

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"

tools_local: string = "./Src/luaTools"

load_tools :: proc(L: ^lua.State) {
	load_file(L, "rect.lua", "Rect")
	load_file(L, "utils.lua", "utils")

}

load_file :: proc(L: ^lua.State, filename: string, title: cstring) {
	ok, path := lua_file_exists(filename)

	if !ok {
		fmt.println("Failed to find ", filename, " in tools directory.")
		return
	}

	status := lua.L_loadfile(L, strings.clone_to_cstring(path))
	if status != lua.Status.OK {
		fmt.println("Failed to load ", filename, " from: ", path)
		return
	}

	call_status := lua.pcall(L, 0, 1, 0)
	if call_status != 0 {
		fmt.println("Failed to run ", filename, " from: ", path)
		return
	}

	// ❗ check stack top
	if lua.isnil(L, -1) {
		fmt.println(filename, " returned nil")
		lua.pop(L, 1)
		return
	}

	lua.setglobal(L, title)
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
