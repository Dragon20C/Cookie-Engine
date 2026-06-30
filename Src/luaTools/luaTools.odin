package LuaTools

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"

tools_local: string = "./Src/luaTools"

load_tools :: proc(L: ^lua.State) {
	load_rect_class(L)

}

load_rect_class :: proc(L: ^lua.State) {
	rect_ok, rect_path := lua_file_exists("rect.lua")

	if !rect_ok {
		fmt.println("Failed to find rect.lua in tools directory.")
		return
	}

	fmt.println("Loading rect.lua from: ", rect_path)

	status := lua.L_loadfile(L, strings.clone_to_cstring(rect_path))
	if status != lua.Status.OK {
		fmt.println("Failed to load rect.lua")
		return
	}

	// IMPORTANT: actually execute the chunk
	call_status := lua.pcall(L, 0, lua.MULTRET, 0)
	if call_status != 0 {
		fmt.println("Failed to run rect.lua")
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
