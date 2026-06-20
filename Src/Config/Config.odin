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
