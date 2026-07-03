package cli

import conf "../config"
import core "../core"
import err "../error"
import "core:fmt"


start_project :: proc(project_dir: string, is_dev: bool) {
	fmt.println("Starting project in directory:", project_dir)
	conf.set_project_dir(project_dir)
	conf.set_project_is_dev(is_dev)

	config_err := conf.read_project_config()
	if config_err.kind != err.ErrorType.None {
		err.report_error(config_err)
	}

}
