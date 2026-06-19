--- @meta

input = {}

input.LEFT = 0
input.RIGHT = 1
input.UP = 2
input.DOWN = 3
input.SPACE = 4

--- Returns the current mouse position.
---@return integer x position of the mouse.
---@return integer y position of the mouse.
function input.mouse_position() end

--- Returns whether the given key is currently pressed.
---@param key integer the key to check.
---@return boolean once the key is pressed.
function input.pressed(key) end

--- Returns whether the given key is currently released.
---@param key integer the key to check.
---@return boolean once the key is released.
function input.released(key) end

--- Returns whether the given key is currently held.
---@param key integer the key to check.
---@return boolean returns true if the key is held else false otherwise.
function input.held(key) end

--- Converts the given key to a string representation.
---@param key integer the key to convert.
---@return string the string representation of the key.
function input.to_string(key) end
