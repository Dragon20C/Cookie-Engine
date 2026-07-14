package main

import "core:fmt"
import "core:os"
import "core:strings"
import si "core:sys/info"
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

	set_os_type()

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

set_os_type :: proc() {
	if version, version_ok := si.os_version(context.allocator); version_ok {
		defer si.destroy_os_version(version, context.allocator)

		#partial switch version.platform {
		case si.OS_Version_Platform.Windows:
			conf.Config.platform = conf.Platform.WINDOWS

		case si.OS_Version_Platform.Linux:
			conf.Config.platform = conf.Platform.LINUX

		case si.OS_Version_Platform.MacOS:
			conf.Config.platform = conf.Platform.MAC_OS

		case:
			conf.Config.platform = conf.Platform.UNKNOWN

		}
	}
}
