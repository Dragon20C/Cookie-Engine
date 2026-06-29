package Bindings

import audio "../../Resource"
import "base:runtime"
import "core:fmt"
import "core:strings"
import lua "vendor:lua/5.4"

register_audio :: proc(L: ^lua.State) {
	// This needs to happen now, because we load bindings then main.lua which may call audio functions.
	audio.init_audio_devices()
	lua.newtable(L)

	register_function(L, "load", load_sfx)
	register_function(L, "play", play_sfx)
	register_function(L, "unload", unload_sfx)

	lua.setglobal(L, "sfx")
}

load_sfx :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isstring(L, 1) {
		return 0
	}
	context = runtime.default_context()

	path := lua.tostring(L, 1)
	id := audio.load_sfx(strings.clone_from_cstring(path))
	lua.pushinteger(L, lua.Integer(id))
	return 1
}

play_sfx :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}
	context = runtime.default_context()

	id := i32(lua.tointeger(L, 1))
	audio.play_sfx(id)
	return 0
}

unload_sfx :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}
	context = runtime.default_context()

	id := i32(lua.tointeger(L, 1))
	audio.unload_sfx(id)
	return 0
}
