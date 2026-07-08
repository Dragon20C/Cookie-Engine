local sheet = gfx.load_sheet(16, 16, "sprites.png")

function _init()
	cookie.scale_window(2)
	---input.bind("Jump", input.KEY_SPACE)
	print(input.KEY_SPACE)
end

function _update(dt)
end

function _draw()
	gfx.clear(gfx.WATERMELON)

	gfx.rectangle(0, 0, 100, 100, gfx.JADE)
	gfx.sprite(sheet, 2, 0, 0)
end
