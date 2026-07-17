package module_loader

import lua "vendor:lua/5.4"
import "core:fmt"
import err "../../error"

LUA_UTILS :: cstring(#load("utils.lua",cstring))
RECT_UTILS :: cstring(#load("rect.lua",cstring))

load_modules :: proc(L : ^lua.State) {
	load_module(L, LUA_UTILS, "utils")
	load_module(L, RECT_UTILS, "rect")
}

load_module :: proc(L : ^lua.State, lib : cstring, title : cstring) {
	load_err := lua.L_loadstring(L,lib)

	if load_err != .OK{
		err.report_error(err.Error{err.ErrorType.Runtime,"Failed to load module"})
		fmt.println("Module: ", title)
		return
	}

	call_status := lua.pcall(L, 0, 1, 0)
	if call_status != 0 {
		err.report_error(err.Error{err.ErrorType.Runtime,"Failed to run the module"})
		fmt.println("Module: ", title)
		return
	}

	if lua.isnil(L, -1) {
		fmt.println(title, " returned nil")
		lua.pop(L, 1)
		return
	}

	lua.setglobal(L, title)

}
