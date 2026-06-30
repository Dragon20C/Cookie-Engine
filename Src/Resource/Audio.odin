package Resource

import "base:runtime"
import "core:fmt"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"


id_counter: i32 = 0
sfx_database: map[i32]rl.Sound

init_audio_devices :: proc() {
	rl.InitAudioDevice()
}

load_sfx :: proc(path: string) -> i32 {
	audio_path, err := filepath.join({game_dir, path})
	if err != nil {
		fmt.println("Failed to join audio path: ", err)
		return -1
	}
	sound := rl.LoadSound(strings.clone_to_cstring(audio_path))
	sfx_database[id_counter] = sound
	id_counter += 1
	return id_counter - 1

}

unload_sfx :: proc(id: i32) {
	if id in sfx_database {
		rl.UnloadSound(sfx_database[id])
		delete_key(&sfx_database, id)
	}
}

play_sfx :: proc(id: i32) {
	if id in sfx_database {
		rl.PlaySound(sfx_database[id])
	}
}

unload_all_sfx :: proc() {
	for id, sound in sfx_database {
		rl.UnloadSound(sound)
	}
	sfx_database = map[i32]rl.Sound{}
}
