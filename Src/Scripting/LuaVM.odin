package LuaVM

import lua "vendor:lua/5.4"

LuaVM :: struct {
	L: ^lua.State,
}

make_lua_vm :: proc() -> LuaVM {
	return LuaVM{L = lua.L_newstate()}
}
