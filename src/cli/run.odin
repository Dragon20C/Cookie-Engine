package cli

import conf "../config"
import core "../core"
import err "../error"


start_project :: proc(project_dir: string, is_dev: bool) {
	conf.set_project_dir(project_dir)
	conf.set_project_is_dev(is_dev)

	config_err := conf.read_project_config()
	if config_err.kind != err.ErrorType.None {
		err.report_error(config_err)
	}

	conf.print_configuration()

	core.start_session()

}
