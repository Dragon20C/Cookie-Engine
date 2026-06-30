---@meta

---@class Cookie
---@field WIDTH integer
---@field HEIGHT integer
---@field IS_DEV boolean
---@field Elapsed number

---@class Cookie.Config
---@field title string
---@field id string
---@field width? integer
---@field height? integer

cookie = {}

---@return number Returns the current FPS.
function cookie.get_fps() end

--- @return Cookie.Config Expects configuration to be returned.
function _config() end

--- The initialization step of the program.
function _init() end

--- Update is called each frame.
---@param dt number Delta time is the time interval between the current frame and the previous frame.
function _update(dt) end

--- Fixed update is called at a fixed delta time.
---@param dt number Delta time is the time interval between the current frame and the previous frame.
function _fixed_update(dt) end

--- Draw is called each frame specifically for drawing onto the screen.
---@param dt number Delta time is the time interval between the current frame and the previous frame.
function _draw(dt) end

gfx            = {}

gfx.BLACK      = 0  --- #000000
gfx.CLAY       = 1  --- #BA6B4A
gfx.CORAL      = 2  --- #F47F57
gfx.ORANGE     = 3  --- #FF8A35
gfx.SAND       = 4  --- #ECC895
gfx.HONEY      = 5  --- #FFE57D
gfx.IVORY      = 6  --- #FDFDFC
gfx.OLIVE      = 7  --- #BAC867
gfx.MINT       = 8  --- #98DBBE
gfx.JADE       = 9  --- #0D9B76
gfx.NAVY       = 10 --- #164475
gfx.AZURE      = 11 --- #1673FF
gfx.AMETHYST   = 12 --- #9872AF
gfx.CANDY      = 13 --- #FFB1CB
gfx.WATERMELON = 14 --- #FE3648
gfx.ROSE       = 15 --- #DA4D52



---Clears the screen with a given color.
---@param color integer
function gfx.clear(color) end

---Draws a rectangle on the screen.
--- @param filled  boolean
---@param x number
---@param y number
---@param width number
---@param height number
---@param color integer
function gfx.rectangle(filled, x, y, width, height, color) end

---Draws a circle on the screen.
--- @param filled  boolean
---@param x number
---@param y number
---@param radius number
---@param color integer
function gfx.circle(filled, x, y, radius, color) end

---Draws a line on the screen.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param color integer
function gfx.line(x1, y1, x2, y2, color) end

--- Loads a sprite sheet from a given path.
--- @param width number The width of each sprite in the sheet.
--- @param height number The height of each sprite in the sheet.
--- @param path string The path to the sprite sheet image.
--- @return integer The sprite sheet ID.
function gfx.load_sheet(width, height, path) end

--- Draws a sprite from a sprite sheet on the screen.
--- @param sheet integer The sprite sheet to draw from.
--- @param frame_id number The frame of the sprite to draw on the sheet.
--- @param x number The x-coordinate to draw the sprite at.
--- @param y number The y-coordinate to draw the sprite at.
function gfx.sprite(sheet, frame_id, x, y) end

--- Unloads a sprite sheet from memory.
--- @param sheet integer The sprite sheet to unload.
function gfx.unload_sheet(sheet) end

--- Draws text on the screen.
--- @param text string The text to draw.
--- @param x number The x-coordinate to draw the text at.
--- @param y number The y-coordinate to draw the text at.
--- @param size number The size of the text.
--- @param color integer The color of the text.
function gfx.text(text, x, y, size, color) end

--- Scales the window size. NOTE: This needs to be improved.
--- @param scale number The scale factor to apply to the window size.
function gfx.scale_window(scale) end

input              = {}

input.ENTER        = 0
input.ESCAPE       = 1
input.SPACE        = 2
input.LEFT         = 3
input.RIGHT        = 4
input.UP           = 5
input.DOWN         = 6

input.MOUSE_LEFT   = 0
input.MOUSE_RIGHT  = 1
input.MOUSE_MIDDLE = 2

--- Returns the mouse position.
--- @return number x
--- @return number y
function input.mouse_position() end

--- Returns whether the mouse button is pressed.
--- @param mouse_code integer
--- @return boolean
function input.mouse_pressed(mouse_code) end

--- Returns whether the mouse button is held down.
--- @param mouse_code integer
--- @return boolean
function input.mouse_held(mouse_code) end

--- Returns whether the mouse button is released.
--- @param mouse_code integer
--- @return boolean
function input.mouse_released(mouse_code) end

--- Pressed once.
--- @param key_code integer
--- @return boolean
function input.pressed(key_code) end

--- Held down.
--- @param key_code integer
--- @return boolean
function input.held(key_code) end

--- Released once.
--- @param key_code integer
--- @return boolean
function input.released(key_code) end

sfx = {}

---Loads the sound into memory
---@param path string  The path to the sound file.
---@return integer  The sound ID.
function sfx.load(path) end

---Unloads the sound from memory.
---@param sound_id integer The sound ID to unload.
function sfx.unload(sound_id) end

---Plays the sound effect.
---@param sound_id integer The sound ID to play.
function sfx.play(sound_id) end

---@class Rect
---@field x number
---@field y number
---@field width number
---@field height number

---@class Rect
Rect = {}

---Creates a new rectangle.
---@param x number
---@param y number
---@param width number
---@param height number
---@return Rect
function Rect.new(x, y, width, height) end

---Checks if this rectangle intersects another.
---@param other Rect
---@return boolean
function Rect:intersects(other) end

---Checks whether a point is inside the rectangle.
---@param x number
---@param y number
---@return boolean
function Rect:containsPoint(x, y) end

---Moves the rectangle.
---@param x number
---@param y number
function Rect:setPosition(x, y) end

---Moves the rectangle
---@param dx number
---@param dy number
function Rect:move(dx, dy) end

utils = {}

--- limits the length of the vec to 1.
---@param x number
---@param y number
--- @return number nx, number ny
function utils.vec2_normalize(x, y) end
