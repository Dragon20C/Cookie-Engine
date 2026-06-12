---@meta
--- The graphics module definitions.

---@class Cookie.Gfx
---@field COLOR_WHITE	integer 0
---@field COLOR_BLACK	integer 1
---@field COLOR_RED		integer 2
---@field COLOR_GREEN	integer 3
---@field COLOR_BLUE	integer 4
---@field COLOR_YELLOW 	integer 5

gfx = {}

---clears the whole screen with a given color.
---@param color integer
function gfx.clear(color) end

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
