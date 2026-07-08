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

---@class Cookie
cookie = {}

--- @return Cookie.Config Expects configuration to be returned.
function _config() end

--- The initialization step of the program.
function _init() end

--- Update is called each frame.
---@param dt number Delta time is the time interval between the current frame and the previous frame.
function _update(dt) end

--- Draw is called each frame specifically for drawing onto the screen.
---@param dt number Delta time is the time interval between the current frame and the previous frame.
function _draw(dt) end

--- Gets the current fps of the game.
--- @return number
function cookie.FPS() end

--- --- Scales the window by the specified multiplier.
--- @param multiplier number The multiplier to scale the window by.
function cookie.scale_window(multiplier) end
