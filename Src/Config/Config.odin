package Config

Config :: struct {
	game_path: string,
	is_dev:    bool,
	title:     string,
	width:     i32,
	height:    i32,
}

make_config :: proc() -> Config {
	return Config {
		game_path = "",
		is_dev = false,
		title = "Cookie Engine",
		width = 640,
		height = 480,
	}
}

read_config :: proc() -> (conf: Config, ok: bool, err: string) {
	// Temporary, for testing errors.
	return make_config(), false, "Failed to read config."
}
