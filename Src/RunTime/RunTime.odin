package RunTime

RunTime :: struct {
	is_running: bool,
}

make_runtime :: proc() -> RunTime {
	return RunTime{is_running = false}
}
