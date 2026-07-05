package engine
// frame buffer script.

import conf "../config"
import rl "vendor:raylib"


render_texture: rl.RenderTexture2D

create_frame_buffer :: proc() {
	width, height := i32(conf.Config.game_width), i32(conf.Config.game_height)
	render_texture = rl.LoadRenderTexture(width, height)
	rl.SetTextureFilter(render_texture.texture, rl.TextureFilter.BILINEAR)
}

render_frame_buffer :: proc() {
	tex_width := f32(render_texture.texture.width)
	tex_height := f32(render_texture.texture.height)
	render_width := f32(rl.GetScreenWidth())
	render_height := f32(rl.GetScreenHeight())

	scale := calculate_scale(i32(conf.Config.game_width), i32(conf.Config.game_height))

	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.DrawTexturePro(
		render_texture.texture,
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

calculate_scale :: proc(width: i32, height: i32) -> f32 {
	return min(f32(rl.GetScreenWidth()) / f32(width), f32(rl.GetScreenHeight()) / f32(height))
}
