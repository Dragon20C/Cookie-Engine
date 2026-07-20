package cli

import err "../error"
import conf "../config"
import "base:runtime"
import fmt "core:fmt"
import "core:os"
import "core:path/filepath"

create_project :: proc(args: []string) {
	if len(args) < 2 {
		err.report_error(
			err.Error {
				err.ErrorType.Fatal,
				"Usage: cookie new <project_name> <project_directory>\n Project directory is optional, Cookie will use the current directory.",
			},
		)
		return
	}

	project_title: string = ""
	project_path: string = "."

	if project_title_valid(args[1]) {
		project_title = args[1]
	} else {
		err.report_error(
			err.Error {
				err.ErrorType.Fatal,
				"Project title is invalid, make sure you are not using any special characters or spaces.",
			},
		)
		return
	}


	if project_path_valid(args) {
		project_path = args[2]
	} else {
		project_path ,wd_err := os.get_working_directory(runtime.default_allocator())
		if wd_err != os.ERROR_NONE {
			err.report_error(
				err.Error {
					err.ErrorType.Warning,
					"Failed to get the working directory.",
				},
			)
			return
		}
		err.report_error(
			err.Error {
				err.ErrorType.Warning,
				"Directory path was not provided, using working directory.",
			},
		)
	}

	clean_err := runtime.Allocator_Error.None
	project_path, clean_err = filepath.clean(project_path)

	if clean_err != runtime.Allocator_Error.None {
		fmt.println("Failed to clean path:", clean_err)
		return
	}

	join_err := runtime.Allocator_Error.None
	project_path, join_err = filepath.join({project_path, project_title})

	if join_err != runtime.Allocator_Error.None {
		fmt.println("Failed to join the project title to the project path.")
		return
	}

	if os.is_dir(project_path) {
		fmt.println(
			"Project directory already exists, either delete that one or choose a different name.",
		)
		return
	}

	template_dir ,t_join_err := filepath.join({conf.Config.engine_dir,"/template"})

	if t_join_err != .None{
		fmt.println("Failed to join engine dir to template dir. err:", t_join_err)
		return
	}

	cpy_err := os.copy_directory_all(project_path, template_dir)
	if cpy_err != nil {
		fmt.println("Failed to copy to project directory, error:", cpy_err)
		return
	}

	fmt.println(
		"Project succesfully created!\nProject title :",
		project_title,
		"\nProject path :",
		project_path,
	)

	fmt.println(
		"You can now use 'dev' or 'run' command to run the project.\n e.g cookie dev ",
		project_path,
	)
}

project_title_valid :: proc(project_title: string) -> bool {
	for c in project_title {
		// letters
		if (c >= 'a' && c <= 'z') ||
		   (c >= 'A' && c <= 'Z') ||
		   (c >= '0' && c <= '9') ||
		   (c == '_') {
			continue
		}
		return false
	}
	return len(project_title) > 0
}

project_path_valid :: proc(args: []string) -> bool {
	return len(args) > 2 && os.is_dir(args[2])
}
