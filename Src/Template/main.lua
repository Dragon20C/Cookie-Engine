local box = {
	color = gfx.MINT,
	x = 0,
	y = 0,
	width = 100,
	height = 100,
	speed = 100
}

local cookie_sprite = 0

function _init()
	box.x = cookie.WIDTH / 2 - box.width / 2
	box.y = cookie.HEIGHT / 2 - box.height / 2
	cookie_sprite = gfx.load_sprite("cookie.png")
end

function _update(dt)
end

function _fixed_update(dt)
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

function _draw(dt)
	-- Clears the screen with watermelon color.
	gfx.clear(gfx.WATERMELON)
	gfx.rectangle(false, box.x, box.y, box.width, box.height, box.color)
	gfx.draw_sprite(cookie_sprite, 0, 0, 16, 16, box.x, box.y)
end
