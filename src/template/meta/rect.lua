---@meta

---@class Rect
---@field x number
---@field y number
---@field width number
---@field height number

---@class Rect
--- 
rect = {}

---Creates a rect table
---@param x number
---@param y number
---@param width number
---@param height number
---@return Rect
function rect.new(x, y, width, height) end


---Checks if there is an overlap between two rects.
---@param other Rect
---@return boolean
function rect:intersects(other) end

---Checks if a point exists inside the rect.
---@param x number
---@param y number
---@return boolean
function rect:containsPoint(x, y) end

---Sets the position of the rect (Top left).
---@param x number
---@param y number
function rect:setPosition(x, y) end

---Moves the rectangle
---@param dx number
---@param dy number
function rect:move(dx, dy) end
