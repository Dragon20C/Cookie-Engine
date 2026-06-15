package input

import h "../helper"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

keys: [4]rl.KeyboardKey = {}
key_strings: [4]cstring = {"left", "right", "up", "down"}

load :: proc(L: ^lua.State) {
	// This is temporary.
	keys[0] = rl.KeyboardKey.A
	keys[1] = rl.KeyboardKey.D
	keys[2] = rl.KeyboardKey.W
	keys[3] = rl.KeyboardKey.S

	lua.newtable(L)
	register_keys(L)
	h.register_function(L, "pressed", pressed)
	h.register_function(L, "released", released)
	h.register_function(L, "held", held)
	h.register_function(L, "to_string", to_string)

	lua.setglobal(L, "input")
}

register_keys :: proc(L: ^lua.State) {
	register_key_map(L, 0, "LEFT")
	register_key_map(L, 1, "RIGHT")
	register_key_map(L, 2, "UP")
	register_key_map(L, 3, "DOWN")
}

register_key_map :: proc(L: ^lua.State, index: lua.Integer, key: cstring) {
	lua.pushinteger(L, index)
	lua.setfield(L, -2, key)
}

pressed :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "expected integer key index")
	}
	key_index := lua.tointeger(L, 1)
	if key_index < 0 || key_index >= 4 {
		lua.L_error(L, "key index out of range")
	}
	if rl.IsKeyPressed(keys[key_index]) {
		lua.pushboolean(L, true)
	} else {
		lua.pushboolean(L, false)
	}
	return 1
}

released :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "expected integer key index")
	}
	key_index := lua.tointeger(L, 1)
	if key_index < 0 || key_index >= 4 {
		lua.L_error(L, "key index out of range")
	}
	if rl.IsKeyReleased(keys[key_index]) {
		lua.pushboolean(L, true)
	} else {
		lua.pushboolean(L, false)
	}
	return 1
}

held :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "expected integer key index")
	}
	key_index := lua.tointeger(L, 1)
	if key_index < 0 || key_index >= 4 {
		lua.L_error(L, "key index out of range")
	}
	if rl.IsKeyDown(keys[key_index]) {
		lua.pushboolean(L, true)
	} else {
		lua.pushboolean(L, false)
	}
	return 1
}

to_string :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "expected integer key index")
	}
	key_index := lua.tointeger(L, 1)
	if key_index < 0 || key_index >= 4 {
		lua.L_error(L, "key index out of range")
	}
	lua.pushstring(L, key_strings[key_index])
	return 1
}
