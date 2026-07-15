package main

import "core:fmt"
import "core:os"
import "core:strings"

import cli "src/cli"
import conf "src/config"

main :: proc() {
	// Read the command line arguments.
	args := os.args[1:]

	if len(args) == 0 {
		fmt.println("Command not found.")
		fmt.println("Usage: cookie new game_title game_dir")
		fmt.println("Usage: cookie dev game_dir")
		fmt.println("Usage: cookie run game_dir")
		fmt.println("Usage: cookie version")
		return
	}

	conf.set_platform()

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

	case "update":
		cli.update_engine()
	case "version":
		fmt.println("Current version :" , conf.read_version())
	case:
		fmt.println("Unknown command:", command_args)
	}

}
