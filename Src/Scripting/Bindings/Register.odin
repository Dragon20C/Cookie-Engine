package Bindings

import "core:fmt"
import lua "vendor:lua/5.4"

register_all_bindings :: proc(L: ^lua.State) {
	register_cookie(L)
	register_gfx(L)
	register_input(L)

}

register_function :: proc(L: ^lua.State, name: cstring, fn: lua.CFunction) {
	lua.pushcfunction(L, fn)
	lua.setfield(L, -2, name)
}

get_int :: proc(L: ^lua.State, idx: i32) -> (i32, b32) {
	if !lua.isinteger(L, idx) {
		return 0, false
	}
	return i32(lua.tointeger(L, idx)), true
}


get_float :: proc(L: ^lua.State, idx: i32) -> (f64, b32) {
	if !lua.isnumber(L, idx) {
		return 0, false
	}
	return f64(lua.tonumber(L, idx)), true
}

get_string :: proc(L: ^lua.State, idx: i32) -> (string, b32) {
	if !lua.isstring(L, idx) {
		return "", false
	}
	return string(lua.tostring(L, idx)), true
}

get_bool :: proc(L: ^lua.State, idx: i32) -> (b32, b32) {
	if lua.isboolean(L, idx) {
		return lua.toboolean(L, idx), true
	}
	return false, false
}

debug_type :: proc(L: ^lua.State, idx: i32) {
	fmt.println(lua.type(L, idx))
}
