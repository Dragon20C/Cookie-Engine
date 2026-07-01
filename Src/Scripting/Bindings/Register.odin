package Bindings

import "core:fmt"
import lua "vendor:lua/5.4"

register_all_bindings :: proc(L: ^lua.State) {
	register_cookie(L)
	register_gfx(L)
	register_input(L)
	register_audio(L)
	Register_event_system(L)

}

register_function :: proc(L: ^lua.State, name: cstring, fn: lua.CFunction) {
	lua.pushcfunction(L, fn)
	lua.setfield(L, -2, name)
}

debug_type :: proc(L: ^lua.State, idx: i32) {
	fmt.println(lua.type(L, idx))
}
