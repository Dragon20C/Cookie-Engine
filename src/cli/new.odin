package cli

import err "../error"
import fmt "core:fmt"

create_project :: proc(args: []string) {
	if len(args) < 2 {
		fmt.println("Usage: cookie new <project_name> <project_directory>")
		return
	}
}
