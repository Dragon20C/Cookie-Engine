
local chicken = {}
chicken.sheet_id = gfx.load_sheet(16, 16, "sprites.png")
chicken.x = (cookie.WIDTH * 0.5) - 8
chicken.y = (cookie.HEIGHT * 0.5) - 8
chicken.speed = 100.0
chicken.flip = false

function chicken:draw()
	gfx.sprite(self.sheet_id,2,chicken.x,chicken.y,chicken.flip)
end

function _init()
    cookie.scale_window(2)
    camera.offset(cookie.WIDTH * 0.5,cookie.HEIGHT * 0.5)
end

function _update(dt)
    local dir = { x = 0, y = 0 }

    if input.key_held(input.KEY_A) then
        dir.x = -1
        chicken.flip = true
    end

    if input.key_held(input.KEY_D) then
        dir.x = 1
        chicken.flip = false
    end

    if input.key_held(input.KEY_W) then
        dir.y = -1
    end

    if input.key_held(input.KEY_S) then
    	dir.y = 1
    end

    dir.x, dir.y = utils.normalize(dir.x, dir.y)

    chicken.x = chicken.x + (dir.x * chicken.speed * dt)
    chicken.y = chicken.y + (dir.y * chicken.speed * dt)

    camera.position(chicken.x,chicken.y)

end

function _draw()
    gfx.clear(gfx.MINT)


    camera.start()

    gfx.rectangle(0.0, 0.0, cookie.WIDTH, 32, gfx.WATERMELON)
    gfx.rectangle(0.0, cookie.HEIGHT - 32, cookie.WIDTH, 32, gfx.WATERMELON)

    chicken:draw()

    camera.stop()

end
