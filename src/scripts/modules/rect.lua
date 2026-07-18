local rect = {}
rect.__index = rect

function rect.new(x, y, width, height)
    local self = {}
    setmetatable(self, rect)

    self.x = x
    self.y = y
    self.width = width
    self.height = height

	return self
end

function rect:__tostring()
	return string.format("Rect(x: %d, y: %d, width: %d, height: %d)", self.x, self.y, self.width, self.height)
end

function rect:intersects(other)
	return self.x < other.x + other.width and
		self.x + self.width > other.x and
		self.y < other.y + other.height and
		self.y + self.height > other.y
end

function rect:containsPoint(x, y)
	return x >= self.x and
		x <= self.x + self.width and
		y >= self.y and
		y <= self.y + self.height
end

function rect:setPosition(x, y)
	self.x = x
	self.y = y
end

function rect:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

return rect
