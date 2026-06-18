--- main.lua file

local size = 64
local red_box = {
	x = cookie.Width / 2 - size / 2,
	y = cookie.Height / 2 - size / 2,
	speed = 150,
}



local timer = 0.0
local reset_number = 0.25

--- Events should be defined globally and not use the same values
local events = { set_pos = 0 }

function _init()
	print("Width", cookie.Width, "Height", cookie.Height)
	event.connect(events.set_pos, Set_box_position)
	--- Recommend connecting events at init time to make sure functions are already.
end

function _update(dt)
	-- timer = timer + dt
	-- if timer >= reset_number then
	-- 	timer = 0.0
	-- 	local x, y = input.mouse_position()
	-- 	print("Mouse position x = ", x, "y = ", y)
	-- end
end

local counter = 0

function _fixed_update(dt)
	local x, y = input.mouse_position()
	if input.pressed(input.SPACE) then
		event.call(events.set_pos, x - size / 2, y - size / 2)
		--- Currently, params are not supported, yet...
		-- event.call(events.reset)
		-- event.disconnect(events.reset, Do_something_else)
		if counter == 0 then
			sfx.play("jump")
		elseif counter == 1 then
			sfx.play("hitHurt")
		elseif counter == 2 then
			sfx.play("pickupCoin")
		end
		counter = (counter + 1) % 3
	end


	if input.held(input.LEFT) then
		red_box.x = red_box.x - red_box.speed * dt
	elseif input.held(input.RIGHT) then
		red_box.x = red_box.x + red_box.speed * dt
	end
	if input.held(input.UP) then
		red_box.y = red_box.y - red_box.speed * dt
	elseif input.held(input.DOWN) then
		red_box.y = red_box.y + red_box.speed * dt
	end
end

function _draw(dt)
	gfx.clear(gfx.COLOR_CARDBOARD)
	gfx.rect(red_box.x, red_box.y, size, size, gfx.COLOR_RED)
	-- gfx.rect(100, 100, 100, 100, gfx.COLOR_WHITE)
	-- gfx.rect_fill(200, 100, 100, 100, gfx.COLOR_LEAF)
	-- gfx.text("Hello, World!", 100, 80, 24, gfx.COLOR_BLACK)
	-- gfx.circle(300, 100, 50, gfx.COLOR_WHITE)
	-- gfx.circle_fill(300, 100, 50, gfx.COLOR_RED)
end

function Print_hello()
	print("Hello")
end

function Set_box_position(x, y)
	print("Setting box position to x = ", x, "y = ", y)
	red_box.x = x
	red_box.y = y
end
