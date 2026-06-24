local utils = {}

function utils.clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function utils.lerp(a, b, t)
	return a + (b - a) * t
end

function utils.vec2_normalize(x, y)
	local length = math.sqrt(x * x + y * y)
	if length == 0 then
		return 0, 0
	end
	return x / length, y / length
end

function utils.map(value, in_min, in_max, out_min, out_max)
	return out_min + (value - in_min) * (out_max - out_min) / (in_max - in_min)
end
