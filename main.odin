package cli
/// cli handles multiple commands for the cookie engine.
// the "run" command starts cookie engine
// the "dev" command starts cookie engine in development mode
// the "export" command exports the game

import c_core "Src/Core"
import "core:fmt"
import "core:os"
import "core:path/filepath"

template_dir: string = "Src/Template"

main :: proc() {
	// store the command line arguments
	args := os.args
	// check if a command is provided
	if len(args) < 2 {
		fmt.println("Cookie has these commands:")
		fmt.println("  new <project_name> [path]")
		fmt.println("  run [project_name]")
		fmt.println("  dev [project_name]")
		fmt.println("  export <project_name>")
		return
	}

	action_arg := args[1]

	switch action_arg {
	case "new":
		create_project(args)

	case "run":
		run_project(args, false)

	case "dev":
		run_project(args, true)

	case "export":
		export_project(args)
	case:
		fmt.println("Unknown command:", action_arg)
	}
}

create_project :: proc(args: []string) {
	// if no project name is provided, print usage and return
	if len(args) < 3 {
		fmt.println("Usage: cookie new <project_name> [path]")
		return
	}

	project_name: string = args[2]

	// if the project name is invalid, print valids and return
	if !is_project_name_valid(project_name) {
		fmt.println("Invalid project name:", project_name)
		fmt.println("Allowed characters: letters, numbers, and underscores")
		return
	}

	project_path: string = "."
	// if a path is provided, use it as the destination
	if len(args) > 3 {
		project_path = args[3]

		cl, er := filepath.clean(project_path)
		if er != nil {
			fmt.println("Error cleaning path:", er)
			return
		}
		project_path = cl
	}

	// if the destination is not a directory, print invalid path and return
	if !os.is_dir(project_path) {
		fmt.println("Destination is not a directory:", project_path)
		return
	}

	// join the destination and project name to get the full path
	res, err := filepath.join({project_path, project_name})
	if err != nil {
		fmt.println("Error joining path:", err)
		return
	}
	project_path = res

	// if the project path already exists, print error and return
	if os.is_dir(project_path) {
		fmt.println("A folder with the game name already exists:", project_path)
		return
	}

	// create the project directory in the project path using template as the source
	cpy_err := os.copy_directory_all(project_path, template_dir)
	if cpy_err != nil {
		fmt.println("Error creating project directory:", cpy_err)
		fmt.println("Selected path:", project_path)
		return
	}

	fmt.println("Creating project(", project_name, ") in", project_path)

}

is_project_name_valid :: proc(project_name: string) -> bool {
	for c in project_name {
		// letters
		if (c >= 'a' && c <= 'z') ||
		   (c >= 'A' && c <= 'Z') ||
		   (c >= '0' && c <= '9') ||
		   (c == '_') {
			continue
		}
		return false
	}
	return len(project_name) > 0
}

run_project :: proc(args: []string, dev: bool) {


	dir: string = "."
	if len(args) > 2 {
		dir = args[2]
	}
	if !os.is_dir(dir) {
		fmt.println("Project path is not a directory:", dir)
		return
	}


	if !os.is_dir(dir) {
		fmt.println("Project path is not a directory:", dir)
		return
	}

	has_lua_main, err := filepath.join({dir, "main.lua"})
	if err != nil {
		fmt.println("Error joining path:", err)
		return
	}

	if !os.is_file(has_lua_main) {
		fmt.println("No main.lua found in project path:", dir)
		return
	}

	c_core.run(dir, dev)
}

export_project :: proc(args: []string) {
	if len(args) < 3 {
		fmt.println("Usage: cookie export [path]")
		return
	}
	project_dir := args[2]

	if !os.is_dir(project_dir) {
		fmt.println("Path is not a valid directory:", project_dir)
		return
	}

}
