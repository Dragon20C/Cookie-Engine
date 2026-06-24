local box = {
	color = gfx.MINT,
	x = 0,
	y = 0,
	width = 100,
	height = 100,
}

local mouse_pos = { x = 0, y = 0 }

function _init()
	box.x = cookie.WIDTH / 2 - box.width / 2
	box.y = cookie.HEIGHT / 2 - box.height / 2

	print("box.x: " .. box.x .. " box.y: " .. box.y)
end

function _update(dt)
end

function _fixed_update(dt)
	mouse_pos.x, mouse_pos.y = input.mouse_position()

	if input.pressed(input.SPACE) then
		box.color = gfx.AMETHYST
		print("Pressed once")
	elseif input.held(input.SPACE) then
		print("Held")
	elseif input.released(input.SPACE) then
		box.color = gfx.CANDY
		print("Released")
	end
end

function _draw(dt)
	-- Clears the screen with watermelon color.
	gfx.clear(gfx.WATERMELON)
	gfx.rectangle(true, box.x, box.y, box.width, box.height, box.color)
	gfx.line(0, 0, cookie.WIDTH, cookie.HEIGHT, gfx.AMETHYST)
	local desired_color = gfx.HONEY
	local held_down = input.mouse_held(input.MOUSE_LEFT)
	if held_down then
		desired_color = gfx.NAVY
	end

	gfx.circle(false, mouse_pos.x, mouse_pos.y, 80, desired_color)
end
