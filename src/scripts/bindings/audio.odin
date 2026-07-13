package bindings

import engine "../../engine"
import "core:fmt"
import "base:runtime"
import lua "vendor:lua/5.4"

register_audio :: proc(L : ^lua.State) {

	lua.newtable(L)

	register_function(L,"unload",sfx_unload)
	register_function(L,"load",sfx_load)
	register_function(L,"play",sfx_play)


	lua.setglobal(L,"sfx")

	// lua.newtable(L)

	// register_function(L,"unload")
	// register_function(L,"load")
	// register_function(L,"play")
	// register_function(L,"stop")


	// lua.setglobal(L,"music")

}

sfx_unload :: proc "c"(L :^lua.State) -> i32 {

	if !lua.isinteger(L,1){
		return 0
	}

	id := i32(lua.tointeger(L,1))
	context = runtime.default_context()
	engine.sfx_unload(id)

	return 0
}

sfx_load :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isstring(L, 1) {
		return 0
	}
	context = runtime.default_context()

	path := lua.tostring(L, 1)

	id := engine.sfx_load(path)

	if id < 0 {
		return 0
	}

	lua.pushinteger(L, lua.Integer(id))
	return 1
}

sfx_play :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}
	context = runtime.default_context()

	id := i32(lua.tointeger(L, 1))
	engine.sfx_play(id)
	return 0
}
