package event

import h "../helper"
import runtime "base:runtime"
import "core:fmt"
import lua "vendor:lua/5.4"

Event :: struct {
	callback: i32, // Lua ref (luaL_ref)
}
Listeners :: map[int][dynamic]Event

// better name for this...
listeners: Listeners

queue: [dynamic]int

load :: proc(L: ^lua.State) {
	listeners: Listeners = make(Listeners)
	queue = make([dynamic]int)

	lua.newtable(L)
	h.register_function(L, "connect", connect)
	h.register_function(L, "call", call)

	lua.setglobal(L, "event")
}

connect :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "event_id must be integer")
	}

	if !lua.isfunction(L, 2) {
		lua.L_error(L, "callback must be function")
	}

	event_id := int(lua.tointeger(L, 1))
	ref := lua.L_ref(L, lua.REGISTRYINDEX)


	if listeners[event_id] == nil {
		listeners[event_id] = make([dynamic]Event, 0)
	}
	event := Event {
		callback = ref,
	}
	listener := listeners[event_id]

	// check if listener already has this callback
	for val in listener {
		if val.callback == ref {
			return 0
		}
	}

	append_elem(&listener, event)
	listeners[event_id] = listener

	return 0
}

call :: proc "c" (L: ^lua.State) -> i32 {

	if !lua.isinteger(L, 1) {
		lua.L_error(L, "event_id must be integer")
		return 0
	}

	event_id := int(lua.tointeger(L, 1))


	if listeners[event_id] == nil {
		return 0
	}
	context = runtime.default_context()
	append_elem(&queue, event_id)
	// I should process params here but for now leave as is.
	return 0

}

process_queue :: proc "c" (L: ^lua.State) -> i32 {
	// if the queue is empty, do nothing
	if len(queue) == 0 {
		return 0
	}

	for val in queue {
		listener := listeners[val]
		for event in listener {
			lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(event.callback))
			lua.call(L, 0, 0)
		}
	}
	// I dont know enough about context...
	context = runtime.default_context()
	queue = make([dynamic]int)
	return 0
}
