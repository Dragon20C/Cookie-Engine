---@meta

---@class Utils
---@field TAU number
---@field DEG2RAD number
---@field RAD2DEG number

utils = {}

--- Linearly interpolates between two numbers.
---@param a number
---@param b number
---@param t number
---@return number
function utils.lerp(a, b, t) end

--- Clamps a value between min and max.
---@param value number
---@param min number
---@param max number
---@return number
function utils.clamp(value, min, max) end

--- Clamps a value between 0.0 and 1.0.
---@param value number
---@return number
function utils.clamp_01(value) end

--- Returns the sign of a number.
---@param value number
---@return integer
function utils.sign(value) end

--- Rounds to the nearest integer.
---@param value number
---@return integer
function utils.round(value) end

--- Maps a value from one range to another.
---@param value number
---@param in_min number
---@param in_max number
---@param out_min number
---@param out_max number
---@return number
function utils.map(value, in_min, in_max, out_min, out_max) end

--- Returns the distance between two points.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function utils.distance(x1, y1, x2, y2) end

--- Returns the squared distance between two points.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function utils.distance_squared(x1, y1, x2, y2) end

--- Returns the dot product of two vectors.
---@param ax number
---@param ay number
---@param bx number
---@param by number
---@return number
function utils.dot_product(ax, ay, bx, by) end

--- Returns the angle of a vector in radians.
---@param x number
---@param y number
---@return number
function utils.angle(x, y) end

--- Returns the angle from (x1, y1) to (x2, y2).
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function utils.angle_to(x1, y1, x2, y2) end

--- Wraps a value into the range [min, max).
---@param value number
---@param min number
---@param max number
---@return number
function utils.wrap(value, min, max) end

--- Checks if two numbers are approximately equal.
---@param a number
---@param b number
---@param epsilon? number
---@return boolean
function utils.approximately(a, b, epsilon) end

--- Returns a normalized vector.
---@param x number
---@param y number
---@return number nx
---@return number ny
function utils.normalize(x, y) end

return utils
