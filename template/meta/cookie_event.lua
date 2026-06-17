--- @meta

event = {}

--- create an event to the event queue
--- param event_id integer
-- function event.create(event_id) end

--- connects a callback to an event
--- @param event_id integer
--- @param callback function
function event.connect(event_id, callback) end

--- disconnects a callback from an event
--- Note: when not in use, callback needs to be removed else it lives forever
--- @param event_id integer
--- @param callback function
function event.disconnect(event_id, callback) end

--- calls all callbacks connected to an event
--- @param event_id integer
--- @param ... any
function event.call(event_id, ...) end
