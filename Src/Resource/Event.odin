package Resource

import "base:runtime"
import "core:fmt"
import lua "vendor:lua/5.4"


Args :: union {
	i32,
	f32,
	b32,
	cstring,
}

listener :: struct {
	callback_ref: i32,
	alive:        b32,
}

QueuedEvent :: struct {
	event_id: i32,
	args:     [dynamic]Args,
}

event_id_counter: i32 = 0
events: map[i32][dynamic]listener

queue: [dynamic]QueuedEvent

has_dead_listeners: b32 = false

new_event :: proc() -> i32 {
	event_id_counter += 1
	return event_id_counter - 1
}

subscribe :: proc(event_id: i32, callback_ref: i32) {
	// Create a new listener struct with the callback reference and alive status.
	new_listener := listener{callback_ref, true}

	// if no event id exists, create a new array for it.
	if events[event_id] == nil {
		events[event_id] = [dynamic]listener{}
	}

	_, err := append(&events[event_id], new_listener)

	if err != nil {
		fmt.println("Failed to subscribe to event: ", err)
	}
}

unsubscribe :: proc(event_id: i32, L: ^lua.State) {
	listeners := events[event_id]

	for event, index in listeners {
		if !event.alive {
			continue
		}
		lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(event.callback_ref))

		if lua.rawequal(L, 2, -1) {
			events[event_id][index].alive = false
			break
		}

		lua.pop(L, 1)
	}
}

trigger :: proc(event_id: i32, L: ^lua.State) {
	if events[event_id] != nil {
		queued_event := QueuedEvent{event_id, [dynamic]Args{}}
		create_args(L, &queued_event)
		append_elem(&queue, queued_event)
	}
}

event_loop :: proc(L: ^lua.State) {
	activate_listeners(L)
	clear_dead_listeners()
}

create_args :: proc "c" (L: ^lua.State, q_data: ^QueuedEvent) {
	context = runtime.default_context()
	for i: i32 = 2; i <= lua.gettop(L); i += 1 {
		result: Args = nil

		if lua.isinteger(L, i) {
			result = i32(lua.tointeger(L, i))
		} else if lua.isnumber(L, i) {
			result = f32(lua.tonumber(L, i))
		} else if lua.isstring(L, i) {
			result = lua.tostring(L, i)
		} else if lua.isboolean(L, i) {
			result = lua.toboolean(L, i)
		}
		append_elem(&q_data.args, result)
	}
}

activate_listeners :: proc(L: ^lua.State) {
	for q_event in queue {
		args := q_event.args
		size := i32(len(args))
		event_listeners := events[q_event.event_id]
		for &l in event_listeners {
			lua.rawgeti(L, lua.REGISTRYINDEX, lua.Integer(l.callback_ref))
			for arg in args {
				switch v in arg {
				case i32:
					lua.pushinteger(L, lua.Integer(v))
				case f32:
					lua.pushnumber(L, lua.Number(v))
				case b32:
					lua.pushboolean(L, v)
				case cstring:
					lua.pushstring(L, v)
				}
			}
			lua.call(L, size, 0)
		}
	}
	queue = [dynamic]QueuedEvent{}
}

clear_dead_listeners :: proc() {
	if !has_dead_listeners {
		return
	}
	for event_id, listeners in events {
		new_listeners := [dynamic]listener{}
		for &l in listeners {
			if l.alive {
				append_elem(&new_listeners, l)
			}
		}
		events[event_id] = new_listeners
	}

	has_dead_listeners = false
}
