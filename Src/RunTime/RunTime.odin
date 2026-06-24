package RunTime

import bindings "../Scripting/Bindings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

game_loop :: proc(L: ^lua.State, title: cstring, width: i32, height: i32) {

	start_raylib_window(width, height, title)

	target := create_render_texture(width, height)

	loop(L, target, width, height)
}

loop :: proc(L: ^lua.State, texture: rl.RenderTexture2D, width: i32, height: i32) {
	defer shutdown_engine(L, texture)

	lua_init(L)

	FIXED_TIMESTEP: f32 = 1.0 / 60.0
	accumulator: f32 = 0.0

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		lua_dt := lua.Number(dt)
		bindings.update_elapsed(L, dt)

		accumulator += dt

		window_scale := calculate_scale(width, height)
		virtual_mouse := calculate_virtual_mouse(width, height, window_scale)
		bindings.update_virtual_mouse_pos(virtual_mouse)

		for accumulator >= FIXED_TIMESTEP {
			lua_fixed_update(L, lua.Number(FIXED_TIMESTEP))
			accumulator -= FIXED_TIMESTEP
		}

		lua_update(L, lua_dt)

		rl.BeginTextureMode(texture)

		lua_draw(L, lua_dt)

		rl.EndTextureMode()

		render_texture(texture, window_scale)
	}
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

create_render_texture :: proc(width: i32, height: i32) -> rl.RenderTexture2D {
	target := rl.LoadRenderTexture(width, height)
	rl.SetTextureFilter(target.texture, rl.TextureFilter.POINT)
	return target
}

render_texture :: proc(texture: rl.RenderTexture2D, scale: f32) {

	tex_width := f32(texture.texture.width)
	tex_height := f32(texture.texture.height)
	render_width := f32(rl.GetScreenWidth())
	render_height := f32(rl.GetScreenHeight())

	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.DrawTexturePro(
		texture.texture,
		rl.Rectangle{0, 0, tex_width, -tex_height},
		rl.Rectangle {
			(render_width - (tex_width * scale)) * 0.5,
			(render_height - (tex_height * scale)) * 0.5,
			tex_width * scale,
			tex_height * scale,
		},
		rl.Vector2{0, 0},
		0,
		rl.WHITE,
	)
	rl.EndDrawing()
}

start_raylib_window :: proc(width: i32, height: i32, title: cstring) {
	rl.SetConfigFlags({rl.ConfigFlag.WINDOW_RESIZABLE, rl.ConfigFlag.VSYNC_HINT})
	rl.InitWindow(width, height, title)
	rl.SetWindowMinSize(244, 144)
	rl.SetTargetFPS(60)
}

shutdown_engine :: proc(L: ^lua.State, texture: rl.RenderTexture2D) {
	lua.close(L)
	rl.UnloadRenderTexture(texture)
	bindings.unload_all_sprites()
	rl.CloseWindow()
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
