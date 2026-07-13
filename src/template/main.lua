local sheet = gfx.load_sheet(16, 16, "sprites.png")

local chicken = {
	x = 0,
    y = 0,
	size = 16
}

local index = 0

local sounds = {}
sounds.hurt = sfx.load("sfx/hitHurt.wav")
sounds.jump = sfx.load("sfx/jump.wav")
sounds.coin = sfx.load("sfx/pickupCoin.wav")

function _init()
    cookie.scale_window(2)
    chicken.x = (cookie.WIDTH / 2) - (chicken.size / 2)
    chicken.y = (cookie.HEIGHT / 2) - (chicken.size / 2)

    local val = utils.approximately(1,1.01, 0.1)
    print(val)

end

function _update(dt)

    if input.key_pressed(input.KEY_SPACE) then
        index = (index + 1) % 3
        sfx.play(index)
    end


end

function _draw()
	gfx.clear(gfx.WATERMELON)

	gfx.rectangle(0, 0, 100, 100, gfx.JADE)
	gfx.sprite(sheet, 2, chicken.x, chicken.y)
end
