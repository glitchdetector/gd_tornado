GameSound = {
    _soundId = 0,
    _soundSet = "",
    _sound = "",
    Active = false,
}

function GameSound:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GameSound:GameSound(sound, soundSet)
    self.Active = false
    self._sound = sound
    self._soundSet = soundSet
    self._soundId = -1
end


GameSound.Load = function(audioBank)
    print("Loading Audio Bank", audioBank)
    RequestScriptAudioBank(audioBank, false)
end

GameSound.Release = function(audioBank)
    ReleaseNamedScriptAudioBank(audioBank)
end

function GameSound:PlayEnt(ent)
    self._soundId = GetSoundId()
    PlaySoundFromEntity(self._soundId, self._sound, ent, self._soundSet, 0, 0)
    self.Active = true
end

function GameSound:PlayPos(pos)
    self._soundId = GetSoundId()
    PlaySoundFromCoord(self._soundId, self._sound, pos.x, pos.y, pos.z, self._soundSet, 0, 0)
    self.Active = true
end

function GameSound:OnUpdate(gameTime)

end

function GameSound:Destroy()
    if self._soundId == -1 then
        return false
    end
    StopSound(self._soundId)
    ReleaseSoundId(self._soundId)
    self._soundId = -1
    self.Active = false
end
