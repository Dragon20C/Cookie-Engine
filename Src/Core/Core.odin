package EngineCore

import cfg "../Config"
import resource "../Resource"
import rt "../RunTime"
import lua "../Scripting"
import bindings "../Scripting/Bindings"
import "core:fmt"
import "core:path/filepath"
import "core:strings"


ErrorType :: enum {
	None,
	Fatal,
	Runtime,
	Warning,
}

EngineError :: struct {
	kind:    ErrorType,
	message: string,
}

Engine :: struct {
	Conf: cfg.Config,
	Lua:  lua.LuaVM,
}

engine: Engine
lua_utils: string = "../Utils/utils.lua"

run :: proc(dir: string, is_dev: bool) {
	// Initialise the engine
	init_engine()

	// Load configuration
	conf, ok, err := cfg.read_config(dir, is_dev)
	if !ok {
		engine_err := EngineError {
			kind    = ErrorType.Fatal,
			message = err,
		}
		report_error(engine_err)
		return
	}
	engine.Conf = conf
	// Cookie requires engine specific values.
	bindings.set_cookie_defaults(engine.Conf.width, engine.Conf.height, b32(engine.Conf.is_dev))

	resource.game_dir = dir
	resource.game_width = engine.Conf.width
	resource.game_height = engine.Conf.height

	// Load bindings
	bindings.register_all_bindings(engine.Lua.L)

	main_lua, join_err := filepath.join({dir, "main.lua"})
	if join_err != nil {
		engine_err := EngineError {
			kind    = ErrorType.Fatal,
			message = "Failed to join paths together.",
		}
		report_error(engine_err)
		return
	}

	l_ok, l_err := lua.read_lua_file(engine.Lua.L, main_lua)
	if !l_ok {
		engine_err := EngineError {
			kind    = ErrorType.Fatal,
			message = l_err,
		}
		report_error(engine_err)
		return
	}
	// Run main.lua
	rt.game_loop(
		engine.Lua.L,
		strings.clone_to_cstring(engine.Conf.title),
		engine.Conf.width,
		engine.Conf.height,
	)
}

init_engine :: proc() {
	engine = make_engine()
}

make_engine :: proc() -> Engine {
	return Engine{Conf = cfg.make_config(), Lua = lua.make_lua_vm()}
}


report_error :: proc(err: EngineError) {
	switch err.kind {
	case .Fatal:
		fmt.println("FATAL:", err.message)
	case .Runtime:
		fmt.println("ERROR:", err.message)
	case .Warning:
		fmt.println("WARN:", err.message)
	case .None:
	}
}
