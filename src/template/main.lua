
local sprite_sheet = gfx.load_sheet(16,16,"sprites.png")

local x, y = 0.0, 0.0

x = (cookie.WIDTH * 0.5) - (16 * 0.5)
y = (cookie.HEIGHT * 0.5) - (16 * 0.5)
local flip = false

function _init()
	cookie.scale_window(2)
end

function _update(dt)
    if input.key_held(input.KEY_A) then
        flip = true
    elseif input.key_held(input.KEY_D) then
        flip = false
    end
    local mx, my = input.mouse_position()
    print("x : " .. mx .." y : " .. my)
end

function _draw()
    gfx.clear(gfx.WATERMELON)
	gfx.sprite(sprite_sheet,1,x,y,flip)
end
