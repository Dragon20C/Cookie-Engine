local box = {
	color = gfx.MINT,
	x = 0,
	y = 0,
	width = 100,
	height = 100,
}

function _init()
	box.x = cookie.WIDTH / 2 - box.width / 2
	box.y = cookie.HEIGHT / 2 - box.height / 2

	print("box.x: " .. box.x .. " box.y: " .. box.y)
end

function _update(dt)
end

function _fixed_update(dt)
end

function _draw(dt)
	-- Clears the screen with watermelon color.
	gfx.clear(gfx.WATERMELON)
	gfx.rectangle(false, box.x, box.y, box.width, box.height, box.color)
	gfx.line(0, 0, cookie.WIDTH, cookie.HEIGHT, gfx.AMETHYST)
	gfx.circle(false, cookie.WIDTH / 2, cookie.HEIGHT / 2, 80, gfx.HONEY)
end
