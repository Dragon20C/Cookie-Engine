---@meta
--- The graphics module definitions.

---Palette of colors available for use in the graphics module.

gfx = {}
gfx.COLOR_BLACK = 0
gfx.COLOR_BROWN = 1
gfx.COLOR_TANG = 2
gfx.COLOR_ORANGE = 3
gfx.COLOR_CARDBOARD = 4
gfx.COLOR_YELLOW = 5
gfx.COLOR_WHITE = 6
gfx.COLOR_LEAF = 7
gfx.COLOR_MINT = 8
gfx.COLOR_GREEN = 9
gfx.COLOR_DARK_BLUE = 10
gfx.COLOR_BLUE = 11
gfx.COLOR_PURPLE = 12
gfx.COLOR_PINK = 13
gfx.COLOR_RED = 14
gfx.COLOR_DARK_RED = 15

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
