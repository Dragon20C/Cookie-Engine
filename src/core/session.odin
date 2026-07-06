package session
// Session script.

import conf "../config"
import engine "../engine"
import err "../error"
import bindings "../scripts/bindings"
import "core:fmt"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

L: ^lua.State

start_session :: proc() {
	err.on_fatal_error = close_session

	start_lua_vm()

	title: cstring = strings.clone_to_cstring(conf.Config.title)
	width: i32 = i32(conf.Config.game_width)
	height: i32 = i32(conf.Config.game_height)

	rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE, rl.ConfigFlag.VSYNC_HINT})
	rl.SetTargetFPS(60)
	rl.InitWindow(width, height, title)
	rl.SetWindowMinSize(244, 144)

	engine.create_frame_buffer()

	session()
}

session :: proc() {
	fmt.println("Session in progress.")

	width: i32 = i32(conf.Config.game_width)
	height: i32 = i32(conf.Config.game_height)

	// Order of execution, init(Once) -> update -> draw
	init()
	for !rl.WindowShouldClose() {
		window_scale := calculate_scale(width, height)
		mouse_position := calculate_virtual_mouse(width, height, window_scale)
		delta_time: f32 = rl.GetFrameTime()

		update(delta_time)

		rl.BeginTextureMode(engine.render_texture)
		draw(delta_time)
		rl.EndTextureMode()

		engine.render_frame_buffer(window_scale)
	}

	close_session()

}

close_session :: proc() {
	rl.CloseWindow()
	fmt.println("Session closed.")
}

init :: proc() {}

update :: proc(dt: f32) {}

draw :: proc(dt: f32) {
	rl.ClearBackground(rl.BLUE)
}

start_lua_vm :: proc() {
	L = lua.L_newstate()
	lua.L_openlibs(L)

	bindings.register_bindings(L)
}

calculate_scale :: proc(width: i32, height: i32) -> f32 {
	return min(f32(rl.GetScreenWidth()) / f32(width), f32(rl.GetScreenHeight()) / f32(height))
}


calculate_virtual_mouse :: proc(width: i32, height: i32, scale: f32) -> rl.Vector2 {

	mouse_pos := rl.GetMousePosition()

	virtual_mouse := rl.Vector2{0, 0}

	offset_x := (f32(rl.GetScreenWidth()) - (f32(width) * scale)) * 0.5
	offset_y := (f32(rl.GetScreenHeight()) - (f32(height) * scale)) * 0.5

	virtual_mouse.x = (mouse_pos.x - offset_x) / scale
	virtual_mouse.y = (mouse_pos.y - offset_y) / scale

	return rl.Vector2Clamp(virtual_mouse, rl.Vector2{0, 0}, rl.Vector2{f32(width), f32(height)})
}
