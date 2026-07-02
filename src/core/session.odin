package session
// Session script.

import conf "../config"
import engine "../engine"
import err "../error"
import "core:fmt"
import rl "vendor:raylib"

project_dir: string = ""

session :: proc() {
	err.on_fatal_error = close_session


}

close_session :: proc() {
	fmt.println("Session closed.")
}
