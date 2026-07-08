package engine
//Input manager.


import err "../error"
import rl "vendor:raylib"
// Actions can hold multiple keys which is stored as an array of i32s
actions: map[string][dynamic]i32


bind :: proc(action: string, index: i32) {
	_, exists := actions[action]
	if !exists {
		actions[action] = make([dynamic]i32)
	}

	_, app_err := append(&actions[action], index)
	if app_err != .None {
		err.report_error(err.Error{err.ErrorType.Runtime, "Failed to append to actions array"})
	}
}

unbind :: proc(action: string, index: i32) {
	indexes, exists := actions[action]
	if !exists {
		return
	}

	if contains(indexes, index) {
		unordered_remove(&actions[action], index)
	}
}

pressed :: proc(action: string) -> bool {

	keycodes, exists := actions[action]

	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist."})
		return false
	}

	for key in keycodes {
		ray_key := rl.KeyboardKey(key)
		if rl.IsKeyPressed(ray_key) {
			return true
		}
	}

	return false
}

held :: proc(action: string) -> bool {

	keycodes, exists := actions[action]

	if !exists {
		err.report_error(err.Error{err.ErrorType.Runtime, "Action does not exist."})
		return false
	}

	for key in keycodes {

		ray_key := rl.KeyboardKey(key)
		if rl.IsKeyDown(ray_key) {
			return true
		}
	}

	return false
}

contains :: proc(keys: [dynamic]i32, value: i32) -> bool {
	for key in keys {
		if key == value {
			return true
		}
	}
	return false
}
