_G.Rect = _G.Rect or {}
local Rect = _G.Rect
Rect.__index = Rect

function Rect.new(x, y, width, height)
	return setmetatable({
		x = x,
		y = y,
		width = width,
		height = height,
	}, Rect)
end

-- function Rect:__tostring()
-- 	return string.format("Rect(x: %d, y: %d, width: %d, height: %d)", self.x, self.y, self.width, self.height)
-- end

function Rect:intersects(other)
	return self.x < other.x + other.width and
		self.x + self.width > other.x and
		self.y < other.y + other.height and
		self.y + self.height > other.y
end

function Rect:containsPoint(x, y)
	return x >= self.x and
		x <= self.x + self.width and
		y >= self.y and
		y <= self.y + self.height
end

function Rect:setPosition(x, y)
	self.x = x
	self.y = y
end

---Moves the rectangle
---@param dx number
---@param dy number
function Rect:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

print("Rect loaded:", Rect)
