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
