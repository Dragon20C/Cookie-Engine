---@meta

---@class Cookie
---@field GAME_W      number   game width resolution
---@field GAME_H      number   game height resolution
---@field PLATFORM    string   build target: "web" | "macos" | "linux" | "windows" | "unknown"
---@field IS_DEV      boolean  true under `cookie dev`; false for `cookie run` and compiled binaries
---@field elapsed     number   wall-clock seconds since session start; updated once per frame before _update
cookie = {}

---config is read once at the begining of game load before init.
---@class Cookie.Config
---@field game_title string
---@field game_id string
---@field width? number
---@field height? number

---config is read once at the begining of game load before init.
--- @return Cookie.Config?
function _config() end

---init runs once at the start of game load.
function _init() end

---update is called each frame.
---@param dt number delta-time duration between lastframe.
function _update(dt) end

---dedicated function for drawing graphics to the screen.
---@param dt number delta-time duration between lastframe.
function _draw(dt) end

---@class Cookie.Gfx
---@field COLOR_WHITE	integer 0
---@field COLOR_BLACK	integer 1
---@field COLOR_RED		integer 2
---@field COLOR_GREEN	integer 3
---@field COLOR_BLUE	integer 4
---@field COLOR_YELLOW 	integer 5
gfx = {}

---clears the screen with a given color.
---@param color integer
function gfx.clear(color) end

---Draws a rectangle outline.
---@param x     number  left edge in game-space pixels
---@param y     number  top edge in game-space pixels
---@param w     number  width in pixels
---@param h     number  height in pixels
---@param color integer  a gfx.COLOR_* constant
function gfx.rect(x, y, w, h, color) end

--function gfx.get_fps()end
