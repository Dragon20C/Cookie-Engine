local box        = {
	color = gfx.MINT,
	x = 0.0,
	y = 0.0,
	width = 64,
	height = 64,
	speed = 50.0
}

local sprites    = 0

local frames     = 0
local timer      = 0.0
local frame_rate = 0.35

function _init()
	box.x = cookie.WIDTH / 2 - box.width / 2
	box.y = cookie.HEIGHT / 2 - box.height / 2
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

	if input.held(input.LEFT) then
		box.x = box.x - box.speed * dt
	end

	if input.held(input.RIGHT) then
		box.x = box.x + box.speed * dt
	end

	if input.held(input.UP) then
		box.y = box.y - box.speed * dt
	end

	if input.held(input.DOWN) then
		box.y = box.y + box.speed * dt
	end
end

function _fixed_update(dt)
end

function _draw(dt)
	gfx.clear(gfx.WATERMELON)
	gfx.rectangle(false, box.x, box.y, box.width, box.height, box.color)


	gfx.sprite(sprites, frames, box.x, box.y)
	gfx.sprite(sprites, (frames + 1) % 4, box.x + box.width - 16, box.y)
	gfx.sprite(sprites, (frames + 2) % 4, box.x, box.y + box.height - 16)
	gfx.sprite(sprites, (frames + 3) % 4, box.x + box.width - 16, box.y + box.height - 16)

	gfx.text("FPS: " .. tostring(cookie.get_fps()), 0, 0, 8, gfx.OLIVE)
end
