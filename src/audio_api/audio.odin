package audio

import h "../helper"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import lua "vendor:lua/5.4"
import rl "vendor:raylib"

audio_files: map[string]rl.Sound

load :: proc(L: ^lua.State, game_dir: string) -> bool {
	rl.InitAudioDevice()
	// create a place to store audio file paths
	// Also this is a bad idea as this stops the library from loading lol.
	if !search_audio_files(game_dir) {
		return false
	}
	// audio_files = make(map[string]rl.Sound)
	lua.newtable(L)

	h.register_function(L, "play", sfx_play)
	lua.setglobal(L, "sfx")

	// lua.newtable(L)

	// h.register_function(L, "play", music_play)
	// lua.setglobal(L, "music")
	return true
}

search_audio_files :: proc(game_dir: string) -> b32 {
	audio_path, err := filepath.join({game_dir, "sfx"})
	if err != nil {
		return false
	}

	if !os.is_dir(audio_path) {
		return false
	}
	// Loop through the contents of the audio directory
	files, files_err := filepath.read_directory_by_path(audio_path, 0, runtime.default_allocator())
	if files_err != nil {
		return false
	}
	for file in files {
		ad_f, ad_err := filepath.join({audio_path, file.name})
		if ad_err != nil {
			continue
		}
		if !os.is_file(ad_f) {
			continue
		}

		sfx_title := strings.split(file.name, ".")[0]

		audio_files[sfx_title] = rl.LoadSound(strings.clone_to_cstring(ad_f))
	}

	return true
}

sfx_play :: proc "c" (L: ^lua.State) -> i32 {
	context = runtime.default_context()
	// ty := lua.type(L, 1)
	// fmt.println("ARG TYPE:", ty)
	if !lua.isstring(L, 1) {
		lua.L_error(L, "Sfx audio title is not a string.")
		return 0
	}

	lua_sfx_title := lua.tostring(L, 1)

	sfx_title := string(lua_sfx_title)
	if !has_audio(sfx_title) {
		fmt.println("Audio title not found:", sfx_title)
		return 0
	}

	source := audio_files[string(sfx_title)]
	rl.PlaySound(source)

	return 0
}

// Honestly this is a bit of a hack of an audio system
// Future improvements will include a proper audio mixer
sfx_play_adv :: proc "c" (L: ^lua.State) -> i32 {
	// sound, volume, pitch, pan
	context = runtime.default_context()
	if !lua.isstring(L, 1) {
		lua.L_error(L, "Sfx audio title is not a string.")
		return 0
	}

	title := string(lua.tostring(L, 1))
	if !has_audio(title) {
		fmt.println("Audio title not found:", title)
		return 0
	}

	if !lua.isnumber(L, 2) {
		lua.L_error(L, "Volume is not a number.")
		return 0
	}
	volume := lua.tonumber(L, 2)

	if !lua.isnumber(L, 3) {
		lua.L_error(L, "Pitch is not a number.")
		return 0
	}
	pitch := lua.tonumber(L, 3)

	if !lua.isnumber(L, 4) {
		lua.L_error(L, "Pan is not a number.")
		return 0
	}
	pan := lua.tonumber(L, 4)

	source := audio_files[string(title)]
	rl.SetSoundPan(source, f32(pan))
	rl.SetSoundVolume(source, f32(volume))
	rl.SetSoundPitch(source, f32(pitch))
	if !rl.IsAudioStreamPlaying(source) {
		rl.PlaySound(source)
	}
	return 0

}

music_play :: proc "c" (L: ^lua.State) -> i32 {
	if !lua.isstring(L, 1) {
		lua.L_error(L, "Music title not found")
		return 0
	}

	sfx_title := lua.tostring(L, 1)


	return 0
}

clear_audio :: proc() {
	for key, value in audio_files {
		rl.UnloadSound(value)
	}
	audio_files = make(map[string]rl.Sound)
}

has_audio :: proc(title: string) -> bool {
	for key, _ in audio_files {
		if key == title {
			return true
		}
	}
	return false
}
