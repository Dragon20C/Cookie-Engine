package session
// Session script.

import conf "../config"
import engine "../engine"
import err "../error"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

start_session :: proc() {
	err.on_fatal_error = close_session

	session()

}

session :: proc() {
	fmt.println("Session in progress.")
	title: cstring = strings.clone_to_cstring(conf.Config.title)
	width: i32 = i32(conf.Config.game_width)
	height: i32 = i32(conf.Config.game_height)

	rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE, rl.ConfigFlag.VSYNC_HINT})
	rl.SetTargetFPS(60)
	rl.InitWindow(width, height, title)
	rl.SetWindowMinSize(244, 144)

	engine.create_frame_buffer()

	for !rl.WindowShouldClose() {

		rl.BeginTextureMode(engine.render_texture)
		rl.ClearBackground(rl.BLUE)
		rl.EndTextureMode()

		engine.render_frame_buffer()

	}

	close_session()

}

close_session :: proc() {
	rl.CloseWindow()
	fmt.println("Session closed.")
}
