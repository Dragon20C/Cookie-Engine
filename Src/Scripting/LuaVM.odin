package LuaVM

import "core:strings"
import lua "vendor:lua/5.4"

LuaVM :: struct {
	L: ^lua.State,
}

make_lua_vm :: proc() -> LuaVM {

	_L := lua.L_newstate()
	lua.L_openlibs(_L)

	return LuaVM{L = _L}
}


read_lua_file :: proc(L: ^lua.State, path: string) -> (ok: bool, err: string) {
	lua_ok := lua.L_dofile(L, strings.clone_to_cstring(path))

	if lua_ok != 0 {
		msg := lua.tostring(L, -1)
		lua.pop(L, 1)
		lua.close(L)
		return false, strings.clone_from_cstring(msg)
	}
	return true, ""
}
