local utils = {}

--- Clamps a value between a minimum and maximum.
---@param value number
---@param min number
---@param max number
---@return number
function utils.clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

--- Linearly interpolates between two numbers.
---@param a number
---@param b number
---@param t number
---@return number
function utils.lerp(a, b, t)
	return a + (b - a) * t
end

--- Maps a value from one range to another.
function utils.map(value, in_min, in_max, out_min, out_max)
	return out_min + (value - in_min) * (out_max - out_min) / (in_max - in_min)
end

--- Returns the sign of a number.
---@return number
function utils.sign(value)
	if value > 0 then
		return 1
	elseif value < 0 then
		return -1
	end
	return 0
end

--- Rounds to the nearest integer.
function utils.round(value)
	return math.floor(value + 0.5)
end

--- Returns the distance between two points.
function utils.distance(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return math.sqrt(dx * dx + dy * dy)
end

--- Returns the squared distance (avoids sqrt).
function utils.distanceSquared(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return dx * dx + dy * dy
end

--- Returns the length of a vector.
function utils.vec2_length(x, y)
	return math.sqrt(x * x + y * y)
end

--- Normalizes a vector.
function utils.vec2_normalize(x, y)
	local length = utils.vec2_length(x, y)

	if length == 0 then
		return 0, 0
	end

	return x / length, y / length
end

--- Returns the dot product of two vectors.
function utils.vec2_dot(ax, ay, bx, by)
	return ax * bx + ay * by
end

--- Returns the angle of a vector in radians.
function utils.vec2_angle(x, y)
	return math.atan(y, x)
end

--- Rotates a vector by an angle (radians).
function utils.vec2_rotate(x, y, angle)
	local c = math.cos(angle)
	local s = math.sin(angle)

	return x * c - y * s,
		x * s + y * c
end

--- Checks if a value lies between min and max.
function utils.between(value, min, max)
	return value >= min and value <= max
end

--- Moves a value toward a target by a maximum amount.
function utils.moveTowards(current, target, maxDelta)
	if math.abs(target - current) <= maxDelta then
		return target
	end

	return current + utils.sign(target - current) * maxDelta
end

--- Checks if two numbers are approximately equal.
function utils.approximately(a, b, epsilon)
	epsilon = epsilon or 0.00001
	return math.abs(a - b) < epsilon
end

return utils
