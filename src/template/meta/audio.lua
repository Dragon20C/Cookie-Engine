---@meta

sfx = {}

---Loads the sound into memory
---@param path string  The path to the sound file.
---@return integer  The sound ID.
function sfx.load(path) end

---Unloads the sound from memory.
---@param sound_id integer The sound ID to unload.
function sfx.unload(sound_id) end

---Plays the sound effect.
---@param sound_id integer The sound ID to play.
function sfx.play(sound_id) end
