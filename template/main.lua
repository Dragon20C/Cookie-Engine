function _config()
	---@type Cookie.Config
	return {
		game_title = "my game",
		game_id = "GameID",
		width = 640,
		height = 360,
	}
end

function _init()
	print("Init started!")
end

function _update(dt)

end

function _draw(dt)
	gfx.clear(gfx.COLOR_GREEN) --gfx.COLOR_BLUE
end
