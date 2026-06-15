function _config()
	---@type Cookie.Config
	return {
		title = "Cookie Game",
		id = "Dragon20C.CookieGame",
		width = 840,
		height = 560,
		scale = 1.2
	}
end

local size = 64

local red_box = {
	x = 840 / 2 - size / 2, --- Huh, cant access the classes yet... e.g cookie.Width
	y = 560 / 2 - size / 2,
	speed = 150,

}

function _init()
	print("Width", cookie.Width, "Height", cookie.Height)
end

function _update(dt)
end

function _fixed_update(dt)
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
