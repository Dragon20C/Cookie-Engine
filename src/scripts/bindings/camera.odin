package bindings
// Camera script

import conf "../../config"
import engine "../../engine"
import "base:runtime"
import lua "vendor:lua/5.4"

register_camera :: proc(L : ^lua.State){
	lua.newtable(L)

	register_function(L,"start",start)
	register_function(L,"stop",stop)
	register_function(L,"translate",translate)
	register_function(L,"offset", offset)
	register_function(L,"scale",scale)
	register_function(L,"rotate",rotate)

	lua.setglobal(L,"camera")

}

start :: proc"c"(L :^lua.State) -> i32 {
	context = runtime.default_context()
	engine.start_camera()
	return 0
}

stop :: proc"c"(L :^lua.State) -> i32 {
	context = runtime.default_context()
	engine.stop_camera()
	return 0
}

offset :: proc"c"(L :^lua.State) -> i32 {

	if !lua.isnumber(L,1) || !lua.isnumber(L,2){
		return 0
	}

	x := f32(lua.tonumber(L,1))
	y := f32(lua.tonumber(L,2))

	context = runtime.default_context()

	engine.camera_offset(x,y)

	return 0
}

translate :: proc"c"(L :^lua.State) -> i32{

	if !lua.isnumber(L, 1) || !lua.isnumber(L,2) {
		return 0
	}

	x := f32(lua.tonumber(L,1))
	y := f32(lua.tonumber(L,2))

	context = runtime.default_context()
	engine.translate_camera(x,y)

	return 0
}

scale :: proc"c"(L :^lua.State) -> i32{
	if !lua.isnumber(L, 1){
		return 0
	}

	scale := f32(lua.tonumber(L,1))

	context = runtime.default_context()
	engine.scale_camera(scale)

	return 0
}

rotate :: proc"c"(L :^lua.State) -> i32{
	if !lua.isnumber(L, 1){
		return 0
	}

	angle := f32(lua.tonumber(L,1))

	context = runtime.default_context()
	engine.rotate_camera(angle)

	return 0
}
