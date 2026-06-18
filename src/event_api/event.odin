package event

import h "../helper"
import runtime "base:runtime"
import "core:fmt"
import "core:strings"

import lua "vendor:lua/5.4"

Event_Arg :: union {
	i64,
	f64,
	bool,
	string,
}

Event :: struct {
	callback: i32, // Lua ref (luaL_ref)
	alive:    b32,
}
Listeners :: map[int][dynamic]Event

// better name for this...
listeners: Listeners

Queue_Data :: struct {
	event_id: int,
	args:     [dynamic]Event_Arg,
}

queue: [dynamic]Queue_Data

load :: proc(L: ^lua.State) {
	listeners = make(Listeners)
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
	q_data := Queue_Data {
		event_id = event_id,
		args     = make([dynamic]Event_Arg),
	}

	create_args(L, &q_data)
	append_elem(&queue, q_data)
	for arg in q_data.args {
		fmt.println("after append", arg)
	}
	return 0
}

create_args :: proc "c" (L: ^lua.State, q_data: ^Queue_Data) {
	context = runtime.default_context()
	for i: i32 = 2; i <= lua.gettop(L); i += 1 {
		result: Event_Arg

		if lua.isinteger(L, i) {
			result = i64(lua.tointeger(L, i))
		} else if lua.isnumber(L, i) {
			result = f64(lua.tonumber(L, i))
		} else if lua.isstring(L, i) {
			result = strings.clone_from_cstring(lua.tostring(L, i))
		} else if lua.isboolean(L, i) {
			result = bool(lua.toboolean(L, i))
		} else {
			result = nil
		}
		fmt.println("RESULT:", result)
		append_elem(&q_data.args, result)
	}
}

process_queue :: proc "c" (L: ^lua.State) -> i32 {
	if len(queue) == 0 {
		return 0
	}

	// swap queue so new emits go into a fresh buffer
	current := queue
	context = runtime.default_context()
	queue = make([dynamic]Queue_Data)

	for val in current {
		listener := listeners[val.event_id]
		args := val.args
		size := i32(len(args))
		fmt.println("EVENT:", val.event_id, "ARGS:", args)
		for event in listener {
			lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(event.callback))
			for arg in args {
				switch v in arg {
				case i64:
					lua.pushinteger(L, lua.Integer(v))
				case f64:
					lua.pushnumber(L, lua.Number(v))
				case bool:
					lua.pushboolean(L, b32(v))
				case string:
					lua.pushstring(L, strings.clone_to_cstring(v))
				case:
					lua.pushnil(L)
				}
			}
			lua.call(L, size, 0)
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
