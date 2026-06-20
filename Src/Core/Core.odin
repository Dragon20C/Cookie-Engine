package EngineCore

import cfg "../Config"
import rt "../RunTime"
import lua "../Scripting"
import bindings "../Scripting/Bindings"
import utils "../Utils"
import "core:fmt"

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
	Conf:    cfg.Config,
	RunTime: rt.RunTime,
	Lua:     lua.LuaVM,
	Utils:   utils.Utils,
}

engine: Engine

run :: proc(dir: string, is_dev: bool) {
	// Initialise the engine
	init_engine()

	// Load configuration
	conf, ok, err := cfg.read_config()
	if !ok {
		engine_err := EngineError {
			kind    = ErrorType.Fatal,
			message = err,
		}
		report_error(engine_err)
		return
	}
	engine.Conf = conf

	// Initalise lua
	// Load bindings
	// bindings.register_all_bindings()
	// Run main.lua
	// Start the runtime
	fmt.println("Cookie Engine")
}

init_engine :: proc() {
	engine = make_engine()
}

make_engine :: proc() -> Engine {
	return Engine {
		Conf = cfg.make_config(),
		RunTime = rt.make_runtime(),
		Lua = lua.make_lua_vm(),
		Utils = utils.make_utils(),
	}
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
