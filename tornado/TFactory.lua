TornadoFactory = {
    VortexLimit = 30,
    _lastSpawnAttempt = 0,
    ActiveVortexCount = 0,
    _activeVortexList = {}
}

function TornadoFactory:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TornadoFactory:CreateVortex(position)
    local tVortex
    if self.ActiveVortexCount > 0 then
        tVortex = self._activeVortexList[0]
    else
        local _, z = GetGroundZFor_3dCoord(position.x, position.y, position.z + 800)
        position = vec3(position.x, position.y, z - 10.0)
        tVortex = TornadoVortex:new()
        tVortex:TornadoVortex(position)
        tVortex:Build()
        self._activeVortexList[0] = tVortex
        self.ActiveVortexCount = self.ActiveVortexCount + 1
    end
    if NOTIFICATIONS then
        -- TODO: Notify
    end
    return tVortex
end

function TornadoFactory:OnUpdate(gameTime)
    if self.ActiveVortexCount > 0 and IsPlayerDead(PlayerId()) and IsScreenFadedOut() then
        self:RemoveAll()
    end
    for i = 0, self.ActiveVortexCount, 1 do
        if self._activeVortexList[i] then
            self._activeVortexList[i]:OnUpdate(gameTime)
        end
    end
    -- TODO: Check is weather
end

function TornadoFactory:RemoveAll()
    for i = 0, self.ActiveVortexCount, 1 do
        self._activeVortexList[i]:Dispose()
        self._activeVortexList[i] = nil
    end
    self.ActiveVortexCount = 0
end

function TornadoFactory:Dispose()
    for i = 0, self.ActiveVortexCount, 1 do
        self._activeVortexList[i]:Dispose()
    end
end
