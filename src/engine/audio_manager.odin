package engine
// Audio manager script.

import "base:runtime"
import "core:fmt"
import "core:path/filepath"
import "core:strings"
import err "../error"
import conf "../config"
import rl "vendor:raylib"

id_counter: i32 = 0
sfx_database: map[i32]rl.Sound

init_audio_device :: proc() {
	rl.InitAudioDevice()
}

sfx_load :: proc(path : cstring) -> i32{
	project_path := conf.Config.project_dir
	audio_path, join_err := filepath.join({project_path, strings.clone_from_cstring(path)})

	if join_err != nil {
		err.report_error(err.Error{
			err.ErrorType.Runtime,"Failed to join sfx path."
		})
		return -1
	}

	sound := rl.LoadSound(strings.clone_to_cstring(audio_path))
	sfx_database[id_counter] = sound

	id_counter += 1
	return id_counter - 1
}

sfx_unload :: proc(id: i32) {
	if id in sfx_database {
		rl.UnloadSound(sfx_database[id])
		delete_key(&sfx_database, id)
	}
}

sfx_play :: proc(id: i32) {
	if id in sfx_database {
		rl.PlaySound(sfx_database[id])
	}
}

sfx_unload_all :: proc() {
	for id, sound in sfx_database {
		rl.UnloadSound(sound)
	}
	sfx_database = map[i32]rl.Sound{}
}

clear_audio_state :: proc() {
	sfx_database = make(map[i32]rl.Sound)
	id_counter = 0
}
