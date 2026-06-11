---@meta

---@class Cookie
---@field GAME_W      number   game width resolution
---@field GAME_H      number   game height resolution
---@field PLATFORM    string   build target: "web" | "macos" | "linux" | "windows" | "unknown"
---@field IS_DEV      boolean  true under `usagi dev`; false for `usagi run` and compiled binaries
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
