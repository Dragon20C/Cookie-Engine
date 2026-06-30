print("Rect in main:", Rect)

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


	local width, height = 16, 16
	sprites = gfx.load_sheet(width, height, "sprites.png")
	--- Debug feature, scale the window to 2x for low resolution games,
	--- Only works in window mode.
	gfx.scale_window(4)
end

function _update(dt)
	-- timer = timer + dt
	if timer >= frame_rate then
		timer = 0.0
		frames = frames + 1
		if frames >= 4 then
			frames = 0
		end
	end

	if input.pressed(input.SPACE) then
		sfx.play(hurt_sfx)
		print("Space pressed")
	end

	if input.held(input.LEFT) then
		box.rect:move(-box.speed * dt, 0)
	end

	if input.held(input.RIGHT) then
		box.rect:move(box.speed * dt, 0)
	end

	if input.held(input.UP) then
		box.rect:move(0, -box.speed * dt)
	end

	if input.held(input.DOWN) then
		box.rect:move(0, box.speed * dt)
	end
	---print("x :", box.x, " y :", box.y)

	-- if box.x + box.width > cookie.WIDTH then
	-- 	box.x = cookie.WIDTH - box.width
	-- end
	-- if box.x - 1 < 0 then
	-- 	box.x = 1
	-- end

	-- if box.y + box.height > cookie.HEIGHT then
	-- 	box.y = cookie.HEIGHT - box.height
	-- end
	-- if box.y - 1 < 0 then
	-- 	box.y = 1
	-- end
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
