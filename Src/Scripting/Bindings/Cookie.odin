package Bindings

import lua "vendor:lua/5.4"

width: i32 = 0
height: i32 = 0
is_dev: b32 = false
elapsed: f32 = 0.0

register_cookie :: proc(L: ^lua.State) {
	lua.newtable(L)

	lua.pushinteger(L, lua.Integer(width))
	lua.setfield(L, -2, "Width")
	lua.pushinteger(L, lua.Integer(height))
	lua.setfield(L, -2, "Height")
	lua.pushboolean(L, is_dev)
	lua.setfield(L, -2, "IsDev")
	lua.pushnumber(L, lua.Number(elapsed))
	lua.setfield(L, -2, "Elapsed")

	lua.setglobal(L, "Cookie")
}

set_cookie_defaults :: proc(_width: i32, _height: i32, _is_dev: b32) {
	width = _width
	height = _height
	is_dev = _is_dev
}

update_elapsed :: proc(L: ^lua.State, delta: f32) {
	elapsed += delta

	// Pushes the Cookie table onto the stack
	lua.getglobal(L, "Cookie")

	// If the Cookie table exists, update the elapsed field
	if lua.istable(L, -1) {
		lua.pushnumber(L, lua.Number(elapsed))
		lua.setfield(L, -2, "elapsed")
	}

	// Pops the Cookie table from the stack
	lua.pop(L, 1)
}
