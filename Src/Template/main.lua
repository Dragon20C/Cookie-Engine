local box        = {
	color = gfx.MINT,
	rect = Rect.new(0.0, 0.0, 64, 64),
	speed = 50.0
}

local sprites    = 0
local hurt_sfx   = sfx.load("sfx/hitHurt.ogg")
local frames     = 0
local timer      = 0.0
local frame_rate = 0.35

function _init()
	local x_pos = cookie.WIDTH / 2 - box.rect.width / 2
	local y_pos = cookie.HEIGHT / 2 - box.rect.height / 2
	box.rect:setPosition(x_pos, y_pos)


	local cell_width, cell_height = 16, 16
	sprites = gfx.load_sheet(cell_width, cell_height, "sprites.png")
	--- Debug feature, scale the window to 4x for low resolution games,
	--- Only works in window mode.
	gfx.scale_window(4)
end

function _update(dt)
	timer = timer + dt
	if timer >= frame_rate then
		timer = 0.0
		frames = frames + 1
		if frames >= 4 then
			frames = 0
		end
	end
	local x, y = 0, 0
	if input.pressed(input.SPACE) then
		sfx.play(hurt_sfx)
	end

	if input.held(input.LEFT) then
		x = -1
		-- box.rect:move(-box.speed * dt, 0)
	elseif input.held(input.RIGHT) then
		x = 1
	else
		x = 0
	end

	if input.held(input.UP) then
		y = -1
		-- box.rect:move(-box.speed * dt, 0)
	elseif input.held(input.DOWN) then
		y = 1
	else
		y = 0
	end
	x, y = utils.vec2_normalize(x, y)
	print("x: " .. x .. " y: " .. y)
	box.rect:move(x * box.speed * dt, y * box.speed * dt)


	if box.rect.x + box.rect.width > cookie.WIDTH then
		box.rect.x = cookie.WIDTH - box.rect.width
	end
	if box.rect.x < 0 then
		box.rect.x = 0
	end

	if box.rect.y + box.rect.height > cookie.HEIGHT then
		box.rect.y = cookie.HEIGHT - box.rect.height
	end
	if box.rect.y < 0 then
		box.rect.y = 0
	end
end

function _fixed_update(dt)
end

function _draw(dt)
	gfx.clear(gfx.WATERMELON)
	local x_pos, y_pos = box.rect.x, box.rect.y
	local width, height = box.rect.width, box.rect.height

	gfx.rectangle(false, x_pos, y_pos, width, height, box.color)


	gfx.sprite(sprites, frames, x_pos, y_pos)
	gfx.sprite(sprites, (frames + 1) % 4, x_pos + width - 16, y_pos)
	gfx.sprite(sprites, (frames + 2) % 4, x_pos, y_pos + height - 16)
	gfx.sprite(sprites, (frames + 3) % 4, x_pos + width - 16, y_pos + height - 16)

	gfx.text("FPS: " .. tostring(cookie.get_fps()), 0, 0, 8, gfx.OLIVE)
end
