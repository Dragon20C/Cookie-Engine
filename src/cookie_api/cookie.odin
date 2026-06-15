package cookie

import conf "../config"
import "core:fmt"
import "core:strings"
import lua "vendor:lua/5.4"

Cookie :: struct {
	Width:    int,
	Height:   int,
	PLATFORM: string,
	IS_DEV:   b32,
	Elapsed:  f64,
}
cookie_data := Cookie{}

set_cookie_data :: proc(cfg: conf.Config, is_dev: bool) {
	cookie_data = Cookie {
		Width    = cfg.width,
		Height   = cfg.height,
		PLATFORM = ODIN_OS_STRING,
		IS_DEV   = b32(is_dev),
		Elapsed  = 0.0,
	}
}

load :: proc(L: ^lua.State) -> bool {

	if cookie_data.Width == 0 {
		fmt.println("Failed to load cookie data, it is empty")
		return false
	}

	lua.newtable(L)
	lua.pushinteger(L, lua.Integer(cookie_data.Width))
	lua.setfield(L, -2, "Width")

	lua.pushinteger(L, lua.Integer(cookie_data.Height))
	lua.setfield(L, -2, "Height")

	lua.pushstring(L, strings.clone_to_cstring(cookie_data.PLATFORM))
	lua.setfield(L, -2, "PLATFORM")

	lua.pushboolean(L, cookie_data.IS_DEV)
	lua.setfield(L, -2, "IS_DEV")

	lua.pushnumber(L, cast(lua.Number)cookie_data.Elapsed)
	lua.setfield(L, -2, "Elapsed")

	lua.setglobal(L, "cookie")
	return true
}

update_elapsed :: proc(L: ^lua.State, dt: f64) {
	cookie_data.Elapsed += f64(dt)

	lua.getglobal(L, "cookie")
	lua.pushnumber(L, cast(lua.Number)cookie_data.Elapsed)
	lua.setfield(L, -2, "Elapsed")

	lua.pop(L, 1)
}
