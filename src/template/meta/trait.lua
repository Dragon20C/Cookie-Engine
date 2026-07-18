---@meta

trait = {}

---creates a trait ready for use
---@param name string
---@return function
function trait.required(name) end

---adds traits to the object
---@param obj table
---@param ... any
function trait.implement(obj, ...) end
