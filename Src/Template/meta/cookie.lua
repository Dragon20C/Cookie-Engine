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

-- --- Loads a sprite from a given path.
-- --- @param path string
-- --- @return integer
-- function gfx.load_sprite(path) end

-- --- Unloads a sprite from memory.
-- --- @param id integer
-- function gfx.unload_sprite(id) end

-- --- Draws a sprite on the screen.
-- --- @param id integer
-- --- @param src_x number
-- --- @param src_y number
-- --- @param width number
-- --- @param height number
-- --- @param dest_x number
-- --- @param dest_y number
-- function gfx.draw_sprite(id, src_x, src_y, width, height, dest_x, dest_y) end

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

utils = {}

--- @Class Utils
---
--- @class Utils.Rect
--- @field x number
--- @field y number
--- @field width number
--- @field height number
---
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @return Utils.Rect
function utils.rect(x, y, width, height) end
