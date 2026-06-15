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
	print("Elapsed: " .. cookie.Elapsed)
end

function _fixed_update(dt)
end

function _draw(dt)
end
