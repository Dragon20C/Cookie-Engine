---@meta

---@class Cookie
---@field Width integer
---@field Height integer
---@field IsDev boolean IsDev Turns true when running the project with the debug flag "dev".
---@field Elasped number

---@class Cookie.Config
---@field title string
---@field id string
---@field width? integer
---@field height? integer

Cookie = {}

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
function _draw(dt)

end
