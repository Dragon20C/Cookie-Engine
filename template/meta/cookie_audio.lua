--- @meta


sfx = {}

---Plays a sound effect from the sfx folder.
---@param sound string
function sfx.play(sound) end

--- Plays a sound effect from the sfx folder with advanced parameters.
--- @param sound string sound effect to play.
--- @param volume number volume of the sound effect.
--- @param pitch number pitch of the sound effect.
--- @param pan number pan of the sound effect.
function sfx.play_adv(sound, volume, pitch, pan) end

music = {}

---Plays a music track from the music folder.
---@param track any
function music.play(track) end

--- Stops the currently playing music track.
function music.stop() end

--- Plays a music track from the music folder with advanced parameters.
--- @param track string music track to play.
--- @param volume number volume of the music track.
--- @param pitch number pitch of the music track.
--- @param pan number pan of the music track.
function music.play_adv(track, volume, pitch, pan) end

--- Returns whether the currently playing music track is finished.
--- @return boolean
function music.is_finished() end

--- Modifies the currently playing music track.
--- @param volume number volume of the music track.
--- @param pitch number pitch of the music track.
--- @param pan number pan of the music track.
function music.modify(volume, pitch, pan) end

--- Sets whether the currently playing music track should loop.
--- @param is_looping boolean whether the music track should loop.
function music.set_looping(is_looping) end
