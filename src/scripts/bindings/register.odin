package bindings
// Register script.

import lua "vendor:lua/5.4"

register_bindings :: proc(L: ^lua.State) {
	register_cookie(L)
	register_graphics(L)

}

register_function :: proc(L: ^lua.State, name: cstring, fn: lua.CFunction) {
	lua.pushcfunction(L, fn)
	lua.setfield(L, -2, name)
}
