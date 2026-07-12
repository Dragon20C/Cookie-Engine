package reloader


import rl "vendor:raylib"

Reload_Callback :: #type proc()

reload: Reload_Callback = nil

checker :: proc() {
	if rl.IsKeyPressed(rl.KeyboardKey.F5) {
		reload()
	}
}
