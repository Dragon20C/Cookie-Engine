package Bindings

import event "../../Resource"
import "base:runtime"
import lua "vendor:lua/5.4"

Register_event_system :: proc(L: ^lua.State) {
	lua.newtable(L)

	register_function(L, "new", new)
	register_function(L, "subscribe", subscribe)
	register_function(L, "unsubscribe", unsubscribe)
	register_function(L, "trigger", trigger)

	lua.setglobal(L, "Event")
}

new :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	id := event.new_event()
	lua.pushinteger(L, lua.Integer(id))
	return 1
}

subscribe :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) || !lua.isfunction(L, 2) {
		lua.pushstring(
			L,
			"Invalid arguments to Event.subscribe. Expected (event_id: integer, callback: function)",
		)
		lua.error(L)
	}

	event_id := i32(lua.tointeger(L, 1))
	ref := lua.L_ref(L, lua.REGISTRYINDEX)
	context = runtime.default_context()
	event.subscribe(event_id, ref)

	return 0
}

unsubscribe :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) || !lua.isfunction(L, 2) {
		lua.pushstring(
			L,
			"Invalid arguments to Event.subscribe. Expected (event_id: integer, callback: function)",
		)
		lua.error(L)
	}

	event_id := i32(lua.tointeger(L, 1))
	context = runtime.default_context()
	event.unsubscribe(event_id, L)

	return 0
}

trigger :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isinteger(L, 1) {
		return 0
	}

	id := i32(lua.tointeger(L, 1))
	context = runtime.default_context()
	event.trigger(id, L)

	return 0
}
