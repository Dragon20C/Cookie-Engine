function _config()
	---@type Cookie.Config
	return {
		title = "Cookie Game",
		id = "Dragon20C.CookieGame",
		width = 640,
		height = 360,
		scale = 1.2
	}
end

function _init()
end

function _update(dt)
end

function _fixed_update(dt)
end

function _draw(dt)
	gfx.clear(gfx.COLOR_CARDBOARD)
	gfx.rect(100, 100, 100, 100, gfx.COLOR_WHITE)
	gfx.rect_fill(200, 100, 100, 100, gfx.COLOR_LEAF)
	gfx.text("Hello, World!", 100, 80, 24, gfx.COLOR_BLACK)
	gfx.circle(300, 100, 50, gfx.COLOR_WHITE)
	gfx.circle_fill(300, 100, 50, gfx.COLOR_RED)
end
