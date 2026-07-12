package engine
//Input manager.


import err "../error"
import rl "vendor:raylib"
import "core:fmt"

action_data :: struct {
	keys : [dynamic]i32,
	action_str : string
}

// Actions can hold multiple keys which is stored as an array of i32s
actions: map[i32]action_data
action_index : i32 = 0

create_action :: proc(action : string) {
	if action_exists(action) {
		return
	}
	data := action_data{
		keys = make([dynamic]i32),
		action_str = action
	}

	actions[action_index] = data
	action_index += 1
}

bind :: proc(action: i32, key_code: i32) {
	data, exists := &actions[action]
	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist, create it first using input.create_action(action)"})
		return
	}

	if contains(data.keys,key_code) {
		return
	}

	_, app_err := append(&data.keys,key_code)
	if app_err != .None {
		err.report_error(err.Error{err.ErrorType.Runtime, "Failed to append to actions array"})
	}
}

unbind :: proc(action: i32, key_code: i32) {
	data, exists := &actions[action]
	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist, create it first using input.create_action(action)"})
		return
	}

	if contains(data.keys, key_code) {
		for result, k_index in data.keys {
			if result == key_code{
				unordered_remove_dynamic_array(&data.keys, k_index)
        		break
			}
		}
	}
}

pressed :: proc(action: i32) -> bool {

	data, exists := &actions[action]

	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist."})
		fmt.println(action)
		return false
	}

	for key in &data.keys {
		ray_key := rl.KeyboardKey(key)
		if rl.IsKeyPressed(ray_key) {
			return true
		}
	}

	return false
}

released :: proc(action : i32) -> bool {

	data, exists := &actions[action]

	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist."})
		fmt.println(action)
		return false
	}

	for key in &data.keys {
		ray_key := rl.KeyboardKey(key)
		if rl.IsKeyReleased(ray_key) {
			return true
		}
	}

	return false
}

held :: proc(action: i32) -> bool {

	data, exists := &actions[action]

	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist."})
		fmt.println(action)
		return false
	}

	for key in &data.keys {

		ray_key := rl.KeyboardKey(key)
		if rl.IsKeyDown(ray_key) {
			return true
		}
	}

	return false
}

key_pressed :: proc(keycode : i32) -> bool {
	if keycode < 0 && keycode > len(rl.KeyboardKey) {
		return false
	}

	ray_key := rl.KeyboardKey(keycode)
	return rl.IsKeyPressed(ray_key)
}

key_held :: proc(keycode : i32) -> bool {
	if keycode < 0 && keycode > len(rl.KeyboardKey) {
		return false
	}

	ray_key := rl.KeyboardKey(keycode)
	return rl.IsKeyDown(ray_key)
}

key_released :: proc(keycode : i32) -> bool {
	if keycode < 0 && keycode > len(rl.KeyboardKey) {
		return false
	}

	ray_key := rl.KeyboardKey(keycode)
	return rl.IsKeyReleased(ray_key)
}

contains :: proc(keys: [dynamic]i32, value: i32) -> bool {
	for key in keys {
		if key == value {
			return true
		}
	}
	return false
}

action_exists :: proc(cur_action : string) -> bool {
	for index,action in actions{
		if action.action_str == cur_action {
			return true
		}
	}
	return false
}

get_keycodes :: proc(action : i32) -> [dynamic]i32{

	keycodes := make([dynamic]i32)

	data, exists := &actions[action]
	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist, create it first using input.create_action(action)"})
		return keycodes
	}
	keycodes = data.keys

	return keycodes
}

clear_actions :: proc() {
	actions = make(map[i32]action_data)
	action_index = 0
}
