package cli

import "../engine"
import "core:fmt"
import "core:os"
import "core:strings"

TEMPLATE_FOLDER: string = "./template"

main :: proc() {
	args := os.args

	if len(args) < 2 {
		fmt.println("No command provided")
		return
	}

	switch args[1] {
	case "new":
		create_project(args)
	case "run":
		start_engine(args, false)
	case "dev":
		start_engine(args, true)
	case "export":
		fmt.println("Exporting game!")
	case:
		fmt.println("Unknown command:", args[1])
	}
}

create_project :: proc(args: []string) {
	if len(args) < 3 {
		fmt.println("Usage: cookie new <project_name> [path]")
		return
	}
	project_name := args[2]

	if !is_valid_project_name(project_name) {
		fmt.println("Invalid project name.")
		fmt.println("Only letters, numbers and underscores are allowed.")
		fmt.println("Project names must start with a letter.")
		return
	}

	base_path := "."
	if len(args) >= 4 {
		base_path = args[3]
	}

	if base_path[len(base_path) - 1] != '/' {
		base_path = strings.concatenate({base_path, "/"})
	}

	if !os.exists(base_path) {
		fmt.println("Invalid path: ", base_path)
		return
	}

	project_path := strings.concatenate({base_path, project_name})

	if os.is_dir(project_path) {
		fmt.println("Directory already exists")
		return
	}

	fmt.println("Creating project:", project_path)
	mk_error := os.make_directory(project_path)

	if mk_error != .NONE {
		fmt.println("Error : ", mk_error)
	}

	cpy_error := os.copy_directory_all(project_path, TEMPLATE_FOLDER)

	if cpy_error != os.ERROR_NONE {
		fmt.println("Failed to copy template to destination.")
		fmt.println("Msg : ", cpy_error)
		return
	}

}

start_engine :: proc(args: []string, is_dev: bool) {
	if len(args) < 2 {
		if is_dev {
			fmt.println("Usage: cookie dev [path]")
		} else {
			fmt.println("Usage: cookie run [path]")
		}
		return
	}

	current_dir: string = "."

	if len(args) > 2 {
		current_dir = args[2]
	}

	if !os.is_dir(current_dir) {
		fmt.println("Path is not a valid dir: ", current_dir)
		fmt.println("Make sure you typed the correct dir path.")
		return
	}
	// add a forward slash if it doesnt exist.
	if current_dir[len(current_dir) - 1] != '/' {
		current_dir = strings.concatenate({current_dir, "/"})
	}

	engine.run(current_dir, is_dev)
}

is_valid_project_name :: proc(name: string) -> bool {
	if len(name) == 0 {
		return false
	}

	first := name[0]

	if !(first >= 'A' && first <= 'Z') && !(first >= 'a' && first <= 'z') {
		return false
	}

	for c in name {
		if (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_' {
			continue
		}

		return false
	}

	return true
}
