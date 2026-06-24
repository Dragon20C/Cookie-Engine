package Bindings

import lua "vendor:lua/5.4"
import rl "vendor:raylib"

key_string := [7]cstring{"ENTER", "ESCAPE", "SPACE", "LEFT", "RIGHT", "UP", "DOWN"}

key_index := [7]rl.KeyboardKey {
	rl.KeyboardKey.ENTER,
	rl.KeyboardKey.ESCAPE,
	rl.KeyboardKey.SPACE,
	rl.KeyboardKey.LEFT,
	rl.KeyboardKey.RIGHT,
	rl.KeyboardKey.UP,
	rl.KeyboardKey.DOWN,
}

virtual_mouse_pos := rl.Vector2{0, 0}

register_input :: proc(L: ^lua.State) {
	lua.newtable(L)
	for key, index in key_string {
		register_input_key(L, key, lua.Integer(index))
	}

	register_input_key(L, "MOUSE_LEFT", 0)
	register_input_key(L, "MOUSE_RIGHT", 1)
	register_input_key(L, "MOUSE_MIDDLE", 2)

	register_function(L, "mouse_position", mouse_position)
	register_function(L, "pressed", key_pressed)
	register_function(L, "released", key_released)
	register_function(L, "held", key_held)
	register_function(L, "mouse_pressed", mouse_pressed)
	register_function(L, "mouse_held", mouse_held)
	register_function(L, "mouse_released", mouse_released)


	lua.setglobal(L, "input")
}

mouse_position :: proc "c" (L: ^lua.State) -> i32 {
	lua.pushnumber(L, lua.Number(virtual_mouse_pos.x))
	lua.pushnumber(L, lua.Number(virtual_mouse_pos.y))
	return 2
}

mouse_pressed :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, -1) {
		return 0
	}
	key := lua.tointeger(L, -1)
	if key < 0 || key >= 3 {
		return 0
	}

	mouse_button := rl.MouseButton(key)

	if rl.IsMouseButtonPressed(mouse_button) {
		lua.pushboolean(L, true)
		return 1
	}
	lua.pushboolean(L, false)
	return 1
}

mouse_held :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, -1) {
		return 0
	}
	key := lua.tointeger(L, -1)
	if key < 0 || key >= 3 {
		return 0
	}

	mouse_button := rl.MouseButton(key)

	if rl.IsMouseButtonDown(mouse_button) {
		lua.pushboolean(L, true)
		return 1
	}
	lua.pushboolean(L, false)
	return 1
}

mouse_released :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, -1) {
		return 0
	}
	key := lua.tointeger(L, -1)
	if key < 0 || key >= 3 {
		return 0
	}

	mouse_button := rl.MouseButton(key)

	if rl.IsMouseButtonReleased(mouse_button) {
		lua.pushboolean(L, true)
		return 1
	}
	lua.pushboolean(L, false)
	return 1
}

key_pressed :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, -1) {
		return 0
	}
	key := lua.tointeger(L, -1)
	if key < 0 || key >= 7 {
		return 0
	}

	if rl.IsKeyPressed(key_index[key]) {
		lua.pushboolean(L, true)
		return 1
	}
	lua.pushboolean(L, false)
	return 1
}

key_released :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, -1) {
		return 0
	}
	key := lua.tointeger(L, -1)
	if key < 0 || key >= 7 {
		return 0
	}

	if rl.IsKeyReleased(key_index[key]) {
		lua.pushboolean(L, true)
		return 1
	}
	lua.pushboolean(L, false)
	return 1
}

key_held :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, -1) {
		return 0
	}
	key := lua.tointeger(L, -1)
	if key < 0 || key >= 7 {
		return 0
	}

	if rl.IsKeyDown(key_index[key]) {
		lua.pushboolean(L, true)
		return 1
	}
	lua.pushboolean(L, false)
	return 1
}


update_virtual_mouse_pos :: proc(mouse_pos: rl.Vector2) {
	virtual_mouse_pos = mouse_pos
}

register_input_key :: proc(L: ^lua.State, name: cstring, index: lua.Integer) {
	lua.pushinteger(L, index)
	lua.setfield(L, -2, name)
}
