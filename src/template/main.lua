
local traits = {
	draw = trait.required("draw")
}

local chicken = {}
chicken.sheet_id = gfx.load_sheet(16, 16, "sprites.png")
chicken.rect = rect.new((cookie.WIDTH * 0.5) - 8,(cookie.HEIGHT * 0.5) - 8,16,16)
chicken.speed = 100.0
chicken.flip = false

trait.implement(chicken, traits)

local rot_speed = 32
local rot = 0.0

function chicken:draw()
	gfx.sprite(self.sheet_id,2,chicken.rect.x,chicken.rect.y,chicken.flip,rot)
end

function _init()
	print(chicken.rect.x)
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

    chicken.rect:move((dir.x * chicken.speed * dt),(dir.y * chicken.speed * dt))

    camera.position(chicken.rect.x, chicken.rect.y)

    rot = rot + rot_speed * dt

    rot = utils.wrap(rot,0,360)

end

function _draw()
    gfx.clear(gfx.MINT)


    camera.start()

    gfx.rectangle(0.0, 0.0, cookie.WIDTH, 32, gfx.WATERMELON)
    gfx.rectangle(0.0, cookie.HEIGHT - 32, cookie.WIDTH, 32, gfx.WATERMELON)

    chicken:draw()

    camera.stop()

end
