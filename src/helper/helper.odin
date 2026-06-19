package helper

import "core:fmt"
import lua "vendor:lua/5.4"

register_function :: proc(L: ^lua.State, name: cstring, fn: lua.CFunction) {
	lua.pushcfunction(L, fn)
	lua.setfield(L, -2, name)
}
