package event

import h "../helper"
import runtime "base:runtime"
import "core:fmt"
import lua "vendor:lua/5.4"

Event :: struct {
	callback: i32, // Lua ref (luaL_ref)
	alive:    b32,
}
Listeners :: map[int][dynamic]Event

// better name for this...
listeners: Listeners

queue: [dynamic]int

load :: proc(L: ^lua.State) {
	listeners: Listeners = make(Listeners)
	//queue = make([dynamic]int)

	lua.newtable(L)
	h.register_function(L, "connect", connect)
	h.register_function(L, "call", call)
	h.register_function(L, "disconnect", disconnect)

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
		alive    = true,
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

disconnect :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		lua.L_error(L, "event_id must be integer")
		return 0
	}

	if !lua.isfunction(L, 2) {
		lua.L_error(L, "callback must be function")
		return 0
	}

	event_id := int(lua.tointeger(L, 1))

	if listeners[event_id] == nil {
		return 0
	}

	context = runtime.default_context()
	for event, index in listeners[event_id] {
		if !event.alive {
			continue
		}
		lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(event.callback))

		if lua.rawequal(L, 2, -1) {
			listeners[event_id][index].alive = false
			//unordered_remove_dynamic_array(&listeners[event_id], index)
			return 0
		}

		lua.pop(L, 1)
	}
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
	if len(queue) == 0 {
		return 0
	}

	// swap queue so new emits go into a fresh buffer
	current := queue
	context = runtime.default_context()
	queue = make([dynamic]int)

	for val in current {
		listener := listeners[val]
		for event in listener {
			lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(event.callback))
			lua.call(L, 0, 0)
		}
	}

	// for val in current {
	// 	fmt.println("EVENT:", val)
	// 	listener := listeners[val]
	// 	fmt.println("LISTENER COUNT:", len(listener))

	// 	for event in listener {
	// 		fmt.println("CALLBACK REF:", event.callback)
	// 	}
	// }

	return 0
}

clean_queue :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()

	for event_id, listener in listeners {
		i := len(listener) - 1
		for i >= 0 {
			if !listener[i].alive {
				unordered_remove_dynamic_array(&listeners[event_id], i)
			}
			i -= 1
		}
	}

	return 0
}
