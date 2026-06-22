package RunTime


import lua "vendor:lua/5.4"
import rl "vendor:raylib"

game_loop :: proc(L: ^lua.State, title: cstring, width: i32, height: i32) {


	rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE, rl.ConfigFlag.VSYNC_HINT})
	rl.InitWindow(width, height, title)
	rl.SetWindowMinSize(320, 240)

	target := rl.LoadRenderTexture(width, height)
	rl.SetTextureFilter(target.texture, rl.TextureFilter.POINT)


	rl.SetTargetFPS(60)
	defer lua.close(L)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		lua_dt := lua.Number(dt)

		scale: f32 = min(
			f32(rl.GetScreenWidth()) / f32(width),
			f32(rl.GetScreenHeight()) / f32(height),
		)

		mouse_pos := rl.GetMousePosition()
		virtual_mouse := rl.Vector2{}
		offset_x := (f32(rl.GetScreenWidth()) - (f32(width) * scale)) * 0.5
		offset_y := (f32(rl.GetScreenHeight()) - (f32(height) * scale)) * 0.5

		virtual_mouse.x = (mouse_pos.x - offset_x) / scale
		virtual_mouse.y = (mouse_pos.y - offset_y) / scale

		virtual_mouse = rl.Vector2Clamp(
			virtual_mouse,
			rl.Vector2{0, 0},
			rl.Vector2{f32(width), f32(height)},
		)

		rl.BeginTextureMode(target)
		rl.ClearBackground(rl.BLUE)
		rl.DrawText(
			rl.TextFormat("Default Mouse: X : %i,Y : %i", int(mouse_pos.x), int(mouse_pos.y)),
			300,
			25,
			20,
			rl.GREEN,
		)
		rl.DrawText(
			rl.TextFormat(
				"Virtual Mouse: X : %i,Y : %i",
				int(virtual_mouse.x),
				int(virtual_mouse.y),
			),
			300,
			55,
			20,
			rl.YELLOW,
		)
		rl.EndTextureMode()

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		rl.DrawTexturePro(
			target.texture,
			rl.Rectangle{0, 0, f32(target.texture.width), -f32(target.texture.height)},
			rl.Rectangle {
				(f32(rl.GetScreenWidth()) - (f32(width) * scale)) * 0.5,
				(f32(rl.GetScreenHeight()) - (f32(height) * scale)) * 0.5,
				f32(width) * scale,
				f32(height) * scale,
			},
			rl.Vector2{0, 0},
			0,
			rl.WHITE,
		)
		rl.EndDrawing()
	}
}


lua_init :: proc(L: ^lua.State) {
	lua.getglobal(L, "_init")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.call(L, 0, 0)
}

lua_update :: proc(L: ^lua.State, dt: lua.Number) {
	lua.getglobal(L, "_update")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.pushnumber(L, dt)
	lua.call(L, 1, 0)
}

lua_fixed_update :: proc(L: ^lua.State, dt: lua.Number) {
	lua.getglobal(L, "_fixed_update")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.pushnumber(L, dt)
	lua.call(L, 1, 0)
}

lua_draw :: proc(L: ^lua.State, dt: lua.Number) {
	lua.getglobal(L, "_draw")
	if !lua.isfunction(L, -1) {
		lua.pop(L, 1)
		return
	}
	lua.pushnumber(L, dt)

	lua.call(L, 1, 0)
}
