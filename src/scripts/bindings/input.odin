package bindings
// Input script.
import "core:fmt"

import engine "../../engine"
import "base:runtime"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

Input_Constant :: struct {
	name:  cstring,
	value: i32,
}

Input_Constants :: []Input_Constant {
	// Keyboard - Letters
	{"KEY_A", i32(rl.KeyboardKey.A)},
	{"KEY_B", i32(rl.KeyboardKey.B)},
	{"KEY_C", i32(rl.KeyboardKey.C)},
	{"KEY_D", i32(rl.KeyboardKey.D)},
	{"KEY_E", i32(rl.KeyboardKey.E)},
	{"KEY_F", i32(rl.KeyboardKey.F)},
	{"KEY_G", i32(rl.KeyboardKey.G)},
	{"KEY_H", i32(rl.KeyboardKey.H)},
	{"KEY_I", i32(rl.KeyboardKey.I)},
	{"KEY_J", i32(rl.KeyboardKey.J)},
	{"KEY_K", i32(rl.KeyboardKey.K)},
	{"KEY_L", i32(rl.KeyboardKey.L)},
	{"KEY_M", i32(rl.KeyboardKey.M)},
	{"KEY_N", i32(rl.KeyboardKey.N)},
	{"KEY_O", i32(rl.KeyboardKey.O)},
	{"KEY_P", i32(rl.KeyboardKey.P)},
	{"KEY_Q", i32(rl.KeyboardKey.Q)},
	{"KEY_R", i32(rl.KeyboardKey.R)},
	{"KEY_S", i32(rl.KeyboardKey.S)},
	{"KEY_T", i32(rl.KeyboardKey.T)},
	{"KEY_U", i32(rl.KeyboardKey.U)},
	{"KEY_V", i32(rl.KeyboardKey.V)},
	{"KEY_W", i32(rl.KeyboardKey.W)},
	{"KEY_X", i32(rl.KeyboardKey.X)},
	{"KEY_Y", i32(rl.KeyboardKey.Y)},
	{"KEY_Z", i32(rl.KeyboardKey.Z)},

	// Keyboard - Numbers
	{"KEY_0", i32(rl.KeyboardKey.ZERO)},
	{"KEY_1", i32(rl.KeyboardKey.ONE)},
	{"KEY_2", i32(rl.KeyboardKey.TWO)},
	{"KEY_3", i32(rl.KeyboardKey.THREE)},
	{"KEY_4", i32(rl.KeyboardKey.FOUR)},
	{"KEY_5", i32(rl.KeyboardKey.FIVE)},
	{"KEY_6", i32(rl.KeyboardKey.SIX)},
	{"KEY_7", i32(rl.KeyboardKey.SEVEN)},
	{"KEY_8", i32(rl.KeyboardKey.EIGHT)},
	{"KEY_9", i32(rl.KeyboardKey.NINE)},

	// Keyboard - Common
	{"KEY_ENTER", i32(rl.KeyboardKey.ENTER)},
	{"KEY_ESCAPE", i32(rl.KeyboardKey.ESCAPE)},
	{"KEY_SPACE", i32(rl.KeyboardKey.SPACE)},
	{"KEY_TAB", i32(rl.KeyboardKey.TAB)},
	{"KEY_BACKSPACE", i32(rl.KeyboardKey.BACKSPACE)},

	// Keyboard - Navigation
	{"KEY_LEFT", i32(rl.KeyboardKey.LEFT)},
	{"KEY_RIGHT", i32(rl.KeyboardKey.RIGHT)},
	{"KEY_UP", i32(rl.KeyboardKey.UP)},
	{"KEY_DOWN", i32(rl.KeyboardKey.DOWN)},
	{"KEY_INSERT", i32(rl.KeyboardKey.INSERT)},
	{"KEY_DELETE", i32(rl.KeyboardKey.DELETE)},
	{"KEY_HOME", i32(rl.KeyboardKey.HOME)},
	{"KEY_END", i32(rl.KeyboardKey.END)},
	{"KEY_PAGE_UP", i32(rl.KeyboardKey.PAGE_UP)},
	{"KEY_PAGE_DOWN", i32(rl.KeyboardKey.PAGE_DOWN)},

	// Keyboard - Modifiers
	{"KEY_LEFT_SHIFT", i32(rl.KeyboardKey.LEFT_SHIFT)},
	{"KEY_RIGHT_SHIFT", i32(rl.KeyboardKey.RIGHT_SHIFT)},
	{"KEY_LEFT_CTRL", i32(rl.KeyboardKey.LEFT_CONTROL)},
	{"KEY_RIGHT_CTRL", i32(rl.KeyboardKey.RIGHT_CONTROL)},
	{"KEY_LEFT_ALT", i32(rl.KeyboardKey.LEFT_ALT)},
	{"KEY_RIGHT_ALT", i32(rl.KeyboardKey.RIGHT_ALT)},

	// Keyboard - Function Keys
	{"KEY_F1", i32(rl.KeyboardKey.F1)},
	{"KEY_F2", i32(rl.KeyboardKey.F2)},
	{"KEY_F3", i32(rl.KeyboardKey.F3)},
	{"KEY_F4", i32(rl.KeyboardKey.F4)},
	{"KEY_F5", i32(rl.KeyboardKey.F5)},
	{"KEY_F6", i32(rl.KeyboardKey.F6)},
	{"KEY_F7", i32(rl.KeyboardKey.F7)},
	{"KEY_F8", i32(rl.KeyboardKey.F8)},
	{"KEY_F9", i32(rl.KeyboardKey.F9)},
	{"KEY_F10", i32(rl.KeyboardKey.F10)},
	{"KEY_F11", i32(rl.KeyboardKey.F11)},
	{"KEY_F12", i32(rl.KeyboardKey.F12)},

	// Mouse
	{"MOUSE_LEFT", i32(rl.MouseButton.LEFT)},
	{"MOUSE_RIGHT", i32(rl.MouseButton.RIGHT)},
	{"MOUSE_MIDDLE", i32(rl.MouseButton.MIDDLE)},
}

register_inputs :: proc(L: ^lua.State) {
	lua.newtable(L)

	for constant in Input_Constants {
		register_key(L, constant.name, constant.value)
	}

	register_function(L, "bind", bind)
	register_function(L, "unbind", unbind)
	register_function(L, "pressed", pressed)
	register_function(L, "released", released)
	register_function(L, "held", held)
	register_function(L, "key_pressed", key_pressed)
	register_function(L, "key_released", key_released)
	register_function(L, "key_held", key_held)
	register_function(L, "create_action",create_action)
	register_function(L, "get_keycodes",get_keycodes)
	lua.setglobal(L, "input")

}

register_key :: proc(L: ^lua.State, key_str: cstring, index: i32) {
	lua.pushinteger(L, lua.Integer(index))
	lua.setfield(L, -2, key_str)
}

get_keycodes :: proc "c"(L : ^lua.State) -> i32 {

	if !lua.isinteger(L,1){
		return 0
	}

	action := i32(lua.tointeger(L,1))
	context = runtime.default_context()
	keycodes := engine.get_keycodes(action)
	lua.createtable(L, i32(len(keycodes)), 0)


	for key, i in keycodes {
	    lua.pushinteger(L, lua.Integer(key))
	    lua.rawseti(L, -2, lua.Integer(i + 1)) // Lua arrays are 1-based
	}

	return 1
}

create_action :: proc "c"(L :^lua.State) -> i32 {

	if !lua.isstring(L,1) {
		return 0
	}

	context = runtime.default_context()
	action := strings.clone_from_cstring(lua.tostring(L,1))
	engine.create_action(action)

	id := lua.Integer(engine.action_index - 1)
	lua.pushinteger(L,id)
	return 1
}

bind :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isinteger(L, 1) || !lua.isinteger(L, 2) {
		return 0
	}

	context = runtime.default_context()

	action := i32(lua.tointeger(L, 1))
	index := i32(lua.tointeger(L, 2))

	engine.bind(action, index)

	return 0
}

unbind :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) || !lua.isinteger(L, 2) {
		return 0
	}
	context = runtime.default_context()

	action := i32(lua.tointeger(L, 1))
	index := i32(lua.tointeger(L, 2))

	engine.unbind(action, index)

	return 0
}

pressed :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isinteger(L, 1) {
		return 0
	}
	context = runtime.default_context()
	action := i32(lua.tointeger(L,1))

	result := b32(engine.pressed(action))
	lua.pushboolean(L, result)
	return 1
}

released :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isinteger(L, 1) {
		return 0
	}
	context = runtime.default_context()
	action := i32(lua.tointeger(L,1))

	result := b32(engine.released(action))
	lua.pushboolean(L, result)
	return 1
}

held :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isstring(L, 1) {
		return 0
	}
	context = runtime.default_context()
	action := i32(lua.tointeger(L, 1))

	result := b32(engine.held(action))
	lua.pushboolean(L, result)
	return 1
}

key_pressed :: proc "c" (L : ^lua.State) -> i32 {
	if !lua.isinteger(L,1) {
		return 0
	}

	key_code : i32 = i32(lua.tointeger(L,1))
	context = runtime.default_context()
	result := b32(engine.key_pressed(key_code))
	lua.pushboolean(L,result)
	return 1
}

key_held :: proc "c" (L : ^lua.State) -> i32 {
	if !lua.isinteger(L,1) {
		return 0
	}

	key_code : i32 = i32(lua.tointeger(L,1))
	context = runtime.default_context()
	result := b32(engine.key_held(key_code))
	lua.pushboolean(L,result)
	return 1
}

key_released :: proc "c" (L : ^lua.State) -> i32 {
	if !lua.isinteger(L,1) {
		return 0
	}

	key_code : i32 = i32(lua.tointeger(L,1))
	context = runtime.default_context()
	result := b32(engine.key_released(key_code))
	lua.pushboolean(L,result)
	return 1
}
