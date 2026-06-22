package Bindings

import "core:fmt"
import lua "vendor:lua/5.4"


register_gfx :: proc(L: ^lua.State) {
	fmt.println("Registering GFX")
}
