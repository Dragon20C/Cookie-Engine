package main

import "core:fmt"
import "core:os"
import cli "src/cli"

main :: proc() {
	// Read the command line arguments.
	args := os.args[1:]

	command_args := args[0]

	switch command_args {
	case "new":
		cli.create_project(args)

	case "run":
		cli.start_project(args[1], false)

	case "dev":
		cli.start_project(args[1], true)

	case "export":
		cli.export_project(args)
	case:
		fmt.println("Unknown command:", command_args)
	}

}
