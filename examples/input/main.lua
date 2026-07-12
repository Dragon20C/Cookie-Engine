--- Loading a sprite from a sprite sheet.


local cell_size = 16
local index = 0
local center_x = (cookie.WIDTH * 0.5) - (cell_size * 0.5)
local center_y = (cookie.HEIGHT * 0.5) - (cell_size * 0.5)
local sheet = gfx.load_sheet(cell_size, cell_size, "sprites.png")
--- I recommend you create a table to store your input maps
local action = {}
--- You first need to create an action which is stored in the engine, Note the string is used for debugging.
action.Left = input.create_action("left")
action.Right = input.create_action("right")
action.Up = input.create_action("up")
action.Down = input.create_action("down")
--- You then need to bind the keys to the action, note you can bind more then 1 key for one action.
input.bind(action.Left, input.KEY_A)
input.bind(action.Right, input.KEY_D)
input.bind(action.Up, input.KEY_W)
input.bind(action.Down,input.KEY_S)

--- If you need, you can get all keycodes assigned to an action
local keys = input.get_keycodes(action.Left)

--- You can unbind a key like this.
-- input.unbind(action.Left,input.KEY_A)

local player = {}
player.speed = 50
player.x = center_x
player.y = center_y

function _init()
    cookie.scale_window(2)
end

function _update(dt)

    if input.held(action.Left) then
        player.x = player.x - player.speed * dt
    elseif input.held(action.Right) then
        player.x = player.x + player.speed * dt
    end

    if input.held(action.Up) then
        player.y = player.y - player.speed * dt
    elseif input.held(action.Down) then
        player.y = player.y + player.speed * dt
    end

end

function _draw()
    gfx.clear(gfx.WATERMELON)
	gfx.sprite(sheet,index,player.x,player.y)
end
