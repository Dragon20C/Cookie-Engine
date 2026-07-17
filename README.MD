# <p align ="center"> Cookie Engine </p>

Cookie engine is a 2D game engine perfect for making pixel art games using lua 5.4, **Cookie** uses Odin lang + raylib to run your games, it is powerful and easy to use, it is made by me Dragon20C.

<p align="center">WARNING</p> 
<p align="center"> Cookie engine is experimental, I welcome contributors to improve the engine </p>

<p align="center"> This project is licensed under the GNU GPL v3.0. See the LICENSE file for details. </p>

>Cookie Features:
- Hot-reloading by pressing F5
- Lua 5.4 based scripting
- 16 Colors with the ability to change it based on a hex file (Im really running out of things to write)

## Installation

>For the people who don't like downloading unknown scripts, the install.sh script is located in the repo in installers directory.


**(Linux/MacOS)**

Downloading the install script, run these commands in your terminal:

```sh
curl -LO https://raw.githubusercontent.com/Dragon20C/Cookie-Engine/main/dev/unix_install.sh
chmod +x unix_install.sh
./unix_install.sh
```

**(Windows)**

>[!NOTE] umm sorry, I have not made one yet...

## Building

>Linux / MacOS

first clone the repo

`git clone https://github.com/Dragon20C/Cookie-Engine`

change directory into it

`cd ./Cookie-Engine`

give permission to execute

`chmod +x ./dev/unix_dev.sh`

run the script

`./dev/unix_dev.sh`


>Windows

Sorry im a linux user so making for windows is a little more difficult.
Sorry for treating you like a second class citizen...

## Cookie Usage
Cookie has multiple commands that you can use.

`new, dev, run, export, version`

Replace [value] with the actual value for example [title] becomes game_title

`cookie new [title] [path]` Creates a new project.

`cookie run [path]` Runs the project in release mode, cookie.IS_DEV is false.

`cookie dev [path]` Runs the project in dev mode, cookie.IS_DEV becomes true.

`cookie export` Exports the game project into a export directory inside the project.

`cookie version` Prints the version of cookie currently installed.

**Game Loop**

config.lua
>config.lua is where the project stores data about the project, the title of the game, id and the width and height

```lua
function _config()
	---@type Cookie.Config
	return {
		title = "Game Title",
		id = "UserName.GameTitle",
		width = 426,
		height = 240,
	}
end
```
main.lua
> main.lua is the entry point of the game, everything starts from here
```lua
function _init()
	cookie.scale_window(2)
end

function _update(dt)
end

function _draw()
    gfx.clear(gfx.WATERMELON)
end
```

## Cheatsheet

```lua
cookie.WIDTH
cookie.HEIGHT
cookie.IS_DEV
cookie.Elapsed

cookie.FPS() -- gets the fps of the engine
cookie.scale_window(multiplier) -- scales the window based on a multiplier (integer)
cookie.set_fullscreen(enable) -- sets it fullscreen or not based on enable (bool)

-- 16 colors avaliable out of the box

gfx.BLACK gfx.CLAY gfx.CORAL gfx.ORANGE gfx.SAND gfx.HONEY gfx.IVORY gfx.OLIVE gfx.MINT
gfx.JADE gfx.NAVY gfx.AZURE gfx.AMETHYST gfx.CANDY gfx.WATERMELON gfx.ROSE

gfx.clear(color) -- clears the whole screen with a color e.g gfx.WATERMELON
gfx.rectangle(x, y, width, height, color) -- draws a filled rectangle onto the screen
gfx.circle(x, y, radius, color) -- draws a filled circle onto the screen
gfx.line(x1, y1, x2, y2, color) -- draws a line between two points
gfx.text(text, x, y, size, color) -- renders text

gfx.load_sheet(cell_width, cell_height, path) -- Loads a sprite sheet into the engine, returns an sheet id
gfx.unload_sheet(sheet) -- unloads the sprite sheet from the engine saving memory
gfx.sprite(sheet, frame_id, x, y, flip) -- draws the sprite sheet based on frame id or index

sfx.load(path) -- loads a sound effect into the engine, this returns an id
sfx.unload(sound_id) -- using the id you get from sfx.load you can unload the sound to save memory
sfx.play(sound_id) -- plays a sound effect based on the id that sfx.load provides

input.KEY_A .. input.KEY_9

input.KEY_ENTER input.KEY_ESCAPE input.KEY_SPACE input.KEY_TAB input.KEY_BACKSPACE
input.KEY_LEFT input.KEY_RIGHT input.KEY_UP input.KEY_DOWN input.KEY_LEFT_SHIFT
input.KEY_RIGHT_SHIFT input.KEY_LEFT_CTRL input.KEY_RIGHT_CTRL input.KEY_LEFT_ALT
input.KEY_RIGHT_ALT input.KEY_INSERT input.KEY_DELETE input.KEY_HOME input.KEY_END
input.KEY_PAGE_UP input.KEY_PAGE_DOWN

input.MOUSE_LEFT
input.MOUSE_RIGHT
input.MOUSE_MIDDLE

input.mouse_position() -- returns the mouse position inside the window
input.create_action(action) -- creates an blank input map
input.bind(action, key) -- binds an action to a input.KEY
input.unbind(action, key) -- unbinds a key on an action
input.get_keycodes(action) -- gets all keys attached to the action

input.pressed(action) -- checks if an action has been pressed
input.held(action) -- checks if the action is currently being held down
input.released(action) -- checks if the action has been released

input.key_pressed(key_code) -- checks directly to a key, not recommened, use only for debugging
input.key_held(key_code) -- checks if a key is held down input.KEY
input.key_released(key_code) -- checks for release of a key

camera.start() -- sprites drawn after dont follow the camera
camera.stop() -- sprites drawn after follow the camera
camera.position(x, y) -- sets the camera position follow target e.g player
camera.scale(scale) -- scales the camera
camera.rotate(angle) -- rotates the camera to the angle
camera.offset(x,y) -- offsets the camera by taking away from position

utils.TAU
utils.DEG2RAD -- degrees to radians
utils.RAD2DEG -- radians to degrees

utils.lerp(a, b, t) -- linearly interpolates between two numbers
utils.clamp(value, min, max) -- clamps the value between min and max
utils.clamp_01(value) -- clamps the value between 0.0 and 1.0
utils.sign(value) -- returns the sign of the value either 1 or -1
utils.round(value) -- brings value to the closet whole number
utils.map(value, in_min, in_max, out_min, out_max) -- maps a range onto another
utils.distance(x1, y1, x2, y2) -- returns the distance between two points
utils.distance_squared(x1, y1, x2, y2) -- returns the squared distance between two points
utils.dot_product(ax, ay, bx, by) -- returns the dot product of two points
utils.angle(x, y) -- returns the angle of a vector, useful for moving in 2d space
utils.angle_to(x1, y1, x2, y2) -- returns the angle from point 1 to point 2
utils.wrap(value, min, max) -- wraps the value around if its lower or higher
utils.approximately(a, b, epsilon) -- checks if a and b are close, epsilon is optional
utils.normalize(x, y) -- limits the vectors length to 1

rect.new(x, y, width, height) -- creates a rect table
rect:intersects(other) -- returns true if a rect is overlapping
rect:containsPoint(x, y) -- returns true if a point exists inside the rect
rect:setPosition(x, y) -- sets the top left position of the rect
rect:move(dx, dy) -- this applys motion to the rects x and y
```
