local utils = {}

utils.TAU = 2.0 * math.pi
utils.DEG2RAD = math.pi / 180
utils.RAD2DEG = 180 / math.pi

--- Linearly interpolates between two numbers.
---@param a number
---@param b number
---@param t number
---@return number
function utils.lerp(a, b, t)
	return a + (b - a) * t
end

--- Clamps a value between min and max.
--- @param value number
--- @param min number
--- @param max number
--- @return number
function utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

--- Clamps a value between 0.0 and 1.0.
--- @param value number
---@return number
function utils.clamp_01(value)
	return math.max(0.0, math.min(1.0, value))
end

--- Returns the sign of a number.
--- @param value number
---@return integer
function utils.sign(value)
	if value > 0 then
		return 1
	elseif value < 0 then
		return -1
	end
	return 0
end

--- Rounds to the nearest integer.
--- @param value number
---@return integer
function utils.round(value)
    if value >= 0 then
        return math.floor(value + 0.5)
    else
        return math.ceil(value - 0.5)
    end
end

--- Maps a value from one range to another.
--- @param value number target value you want to switch.
--- @param in_min number the initial min range.
--- @param in_max number the initial max range.
--- @param out_min number the final min range.
--- @param out_max number the final max range.
--- @return number
function utils.map(value, in_min, in_max, out_min, out_max)
	assert(in_max ~= in_min, "wrap: in min and in max cannot be equal")
	return out_min + (value - in_min) * (out_max - out_min) / (in_max - in_min)
end

--- Returns the distance between two points.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number
function utils.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

--- Returns the distance between two points.
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number
function utils.distance_squared(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return dx * dx + dy * dy
end

--- Returns the dot product of two vectors.
--- @param ax number
--- @param ay number
--- @param bx number
--- @param by number
function utils.dot_product(ax, ay, bx, by)
	return ax * bx + ay * by
end

--- Returns the angle of a vector in radians.
--- @param x number
--- @param y number
--- @return number
function utils.angle(x, y)
    return math.atan(y, x)
end

--- Returns the angle from (x1, y1) to (x2, y2).
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number
function utils.angle_to(x1, y1, x2, y2)
    return math.atan(y2 - y1, x2 - x1)
end

--- Wraps a value into the range [min, max).
--- @param value number
--- @param min number
--- @param max number
--- @return number
function utils.wrap(value, min, max)
	assert(min ~= max, "wrap: min and max cannot be equal")
    local range = max - min
    return ((value - min) % range) + min
end

--- Checks if two numbers are approximately equal.
--- @param a number first number.
--- @param b number second number.
--- @param epsilon? number how close the number needs to be.
--- @return boolean
function utils.approximately(a, b, epsilon)
	epsilon = epsilon or 1e-6
	return math.abs(a - b) < epsilon
end

--- Returns a normalized vector.
--- @param x number
--- @param y number
--- @return number nx
--- @return number ny
function utils.normalize(x, y)
    local length = math.sqrt(x * x + y * y)

    if length == 0 then
        return 0, 0
    end

    return x / length, y / length
end

return utils
