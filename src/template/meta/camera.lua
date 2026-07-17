---@meta

camera = {}

--- enables a state where things drawn after are attached to the camera
function camera.start() end

--- stops things attaching to the camera, after.
function camera.stop() end

---moves the viewport to this position.
---@param x number
---@param y number
function camera.position(x, y) end

---scales the viewport
---@param scale number
function camera.scale(scale) end

---rotates the viewport based on a radian angle.
---@param angle number
function camera.rotate(angle) end

---offsets the camera so target is center
---@param x number
---@param y number
function camera.offset(x,y) end
