package module_loader

import lua "vendor:lua/5.4"
import "core:fmt"
import "core:strings"
import "core:path/filepath"
import "core:os"
import err "../../error"

modules_path: string = "./src/scripts/modules"

load_modules :: proc(L : ^lua.State) {
	load_module(L, "utils.lua", "utils")
}

load_module :: proc(L : ^lua.State, module_title : string, title: cstring) {
	ok, path := lua_file_exists(module_title)

	if !ok {
		fmt.println("Failed to find ", module_title, " in tools directory.")
		return
	}

	status := lua.L_loadfile(L, strings.clone_to_cstring(path))
	if status != lua.Status.OK {
		fmt.println("Failed to load ", module_title, " from: ", path)
		return
	}

	call_status := lua.pcall(L, 0, 1, 0)
	if call_status != 0 {
		fmt.println("Failed to run ", module_title, " from: ", path)
		return
	}

	// ❗ check stack top
	if lua.isnil(L, -1) {
		fmt.println(module_title, " returned nil")
		lua.pop(L, 1)
		return
	}

	lua.setglobal(L, title)
}

lua_file_exists :: proc(title: string) -> (b32, string) {
	path, err := filepath.join({modules_path, title})
	if err != nil {
		return false, ""
	}

	if os.is_file(path) {
		return true, path
	}

	return false, ""
}
