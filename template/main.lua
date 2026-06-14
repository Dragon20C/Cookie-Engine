function _config()
	---@type Cookie.Config
	return {
		game_title = "my game",
		game_id = "GameID",
		width = 640,
		height = 360,
		scale = 1
	}
end

function _init()
	print("Init started!")
	print("platform =", cookie.PLATFORM)
	if cookie.IS_DEV then
		print("Cookie is dev is on!")
	else
		print("Cookie is dev is off!")
	end
end

function _update(dt)
	--print("Update: elapsed =", cookie.elapsed)
end

function _draw(dt)
	local selected_color = gfx.COLOR_DARK_RED

	if cookie.IS_DEV then
		selected_color = gfx.COLOR_MINT
	end
	gfx.rect(0, 0, cookie.Width, cookie.Height, selected_color)
	gfx.clear(selected_color)
	gfx.rect(100, 50, 32, 32, gfx.COLOR_PINK)
end
