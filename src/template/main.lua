local sheet = gfx.load_sheet(16, 16, "sprites.png")

local chicken = {
	x = 0,
	y = 0
}
Actions = {}
--- Change this from using string to an integer for performance.
Actions.Left = input.create_action("Left")
Actions.Right = input.create_action("Right")
Actions.Up = input.create_action("Up")
Actions.Down = input.create_action("Down")

function _init()
	cookie.scale_window(2)
	input.bind(Actions.Right, input.KEY_D)
	input.bind(Actions.Left, input.KEY_A)
	input.bind(Actions.Up, input.KEY_W)
	input.bind(Actions.Down, input.KEY_S)
end

function _update(dt)
	if input.held(Actions.Right) then
		chicken.x = chicken.x + 100 * dt
	end
	if input.held(Actions.Left) then
		chicken.x = chicken.x - 100 * dt
	end
	if input.held(Actions.Up) then
		chicken.y = chicken.y - 100 * dt
	end
    if input.held(Actions.Down) then
        chicken.y = chicken.y + 100 * dt
    end

    if input.released(Actions.Right) then
	print("Release the demons!")
    end
end

function _draw()
	gfx.clear(gfx.WATERMELON)

	gfx.rectangle(0, 0, 100, 100, gfx.JADE)
	gfx.sprite(sheet, 2, chicken.x, chicken.y)
end
