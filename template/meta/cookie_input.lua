--- @meta

input = {}

input.LEFT = 0
input.RIGHT = 1
input.UP = 2
input.DOWN = 3

--- Returns whether the given key is currently pressed.
---@param key string the key to check.
---@return boolean once the key is pressed.
function input.pressed(key) end

--- Returns whether the given key is currently released.
---@param key string the key to check.
---@return boolean once the key is released.
function input.released(key) end

--- Returns whether the given key is currently held.
---@param key string the key to check.
---@return boolean returns true if the key is held else false otherwise.
function input.held(key) end

--- Converts the given key to a string representation.
---@param key number the key to convert.
---@return string the string representation of the key.
function input.to_string(key) end
