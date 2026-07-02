package error

import "core:fmt"

// Define a type for a global exit callback
Exit_Callback :: #type proc()

// A global function pointer that starts as nil
on_fatal_error: Exit_Callback = nil

ErrorType :: enum {
	None,
	Fatal,
	Runtime,
	Warning,
}

Error :: struct {
	kind:    ErrorType,
	message: string,
}

report_error :: proc(err: Error) {
	switch err.kind {
	case .Fatal:
		fmt.println("FATAL:", err.message)
		// If main hooked a function here, call it!
		if on_fatal_error != nil {
			on_fatal_error()
		}
	case .Runtime:
		fmt.println("ERROR:", err.message)
	case .Warning:
		fmt.println("WARN:", err.message)
	case .None:
	}
}
