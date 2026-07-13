package main

import "core:fmt"
import "core:os"
import "core:strings"
import cli "src/cli"

main :: proc() {
	// Read the command line arguments.
	args := os.args[1:]

	command_args := strings.to_lower(args[0])

	switch command_args {
	case "new":
		cli.create_project(args)

	case "run":
		cli.start_project(args[1], false)

	case "dev":
		cli.start_project(args[1], true)

	case "export":
		cli.export_project(args)
	case "version":
		fmt.println("Current version :" , read_version())
	case:
		fmt.println("Unknown command:", command_args)
	}

}

read_version :: proc() -> string {
	data, ok := os.read_entire_file("./version.txt", context.temp_allocator)
	if ok != .NONE {
		return "Failed to read the version text..."
	}

	text := string(data)

	if i := strings.index_byte(text, '\n'); i >= 0 {
		return text[:i]
	}

		return text
	}
