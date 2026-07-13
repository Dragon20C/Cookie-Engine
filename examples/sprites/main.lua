--- Loading a sprite from a sprite sheet.

local interval = 0.4
local timer = 0.0

local cell_size = 16
local index = 0
local center_x = (cookie.WIDTH * 0.5) - (cell_size * 0.5)
local center_y = (cookie.HEIGHT * 0.5) - (cell_size * 0.5)
--- load_sheet sets up the sprite sheet in the engine, it does the splitting automatic
--- by changing the cell sizes, note this is 16x16 but support for different sizes works.
local sheet = gfx.load_sheet(cell_size, cell_size, "sprites.png")

--- if there is a situation where you no longer need a sheet you can unload it to save memory.
--- gfx.unload_sheet(sheet)

function _init()
    cookie.scale_window(2)

end

function _update(dt)
    timer = timer + dt
	if timer >= interval then
        timer = 0
        --- Wrap the index around, note that the engine automatically wraps it around
        --- but its better if you handle it here.
        index = (index + 1) % 4
end
end

function _draw()
    gfx.clear(gfx.WATERMELON)
	gfx.sprite(sheet,index,center_x,center_y)
end
