local trait = {}

local function required(name)
    return function()
        error(("Required trait method '%s' was not implemented."):format(name), 2)
    end
end

function trait.required(name)
    return required(name)
end

function trait.implement(object, ...)
    local traits = { ... }

    for _, definition in ipairs(traits) do
        for name, fn in pairs(definition) do
            if object[name] == nil then
                object[name] = fn
            end
        end
    end
end

return trait
