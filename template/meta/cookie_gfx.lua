---@meta
--- The graphics module definitions.

---@class Cookie.Gfx
---@field COLOR_BLACK		integer 0
---@field COLOR_BROWN		integer 1
---@field COLOR_TANG		integer 2
---@field COLOR_ORANGE		integer 3
---@field COLOR_CARDBOARD	integer 4
---@field COLOR_YELLOW		integer 5
---@field COLOR_WHITE		integer 6
---@field COLOR_LEAF		integer 7
---@field COLOR_MINT		integer 8
---@field COLOR_GREEN		integer 9
---@field COLOR_DARK_BLUE	integer 10
---@field COLOR_BLUE		integer 11
---@field COLOR_PURPLE		integer 12
---@field COLOR_PINK		integer 13
---@field COLOR_RED			integer 14
---@field COLOR_DARK_RED	integer 15

gfx = {}

---clears the whole screen with a given color.
---@param color integer
function gfx.clear(color) end

---draws a sprite on the screen.
---@param index integer
---@param x integer
---@param y integer
function gfx.sprite(index, x, y) end

---draws text on the screen.
---@param text string
---@param x integer
---@param y integer
---@param size integer
---@param color integer
function gfx.text(text, x, y, size, color) end

---draws a rectangle on the screen.
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param color integer
function gfx.rect(x, y, width, height, color) end

---fills a rectangle on the screen with a given color.
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param color integer
function gfx.rect_fill(x, y, width, height, color) end

---draws a circle on the screen.
---@param x integer
---@param y integer
---@param radius integer
---@param color integer
function gfx.circle(x, y, radius, color) end

---fills a circle on the screen with a given color.
---@param x integer
---@param y integer
---@param radius integer
---@param color integer
function gfx.circle_fill(x, y, radius, color) end
