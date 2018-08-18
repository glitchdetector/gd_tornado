TornadoVortex = {
    ForceScale = 4.0,
    InternalForcesDist = 5.0,
    _particles = {},
    _loadedSounds = {},
    _nextUpdateTime = 0,
    ActiveEntity = {
        Entity = nil,
        XBias = 0.0,
        YBias = 0.0,
        IsPlayer = false,
    },
    MaxEntityCount = 600,
    _activeEntities = {},
    _activeEntityCount = 0,
    _position = vec3(0,0,0),
    _destination = vec(0,0,0),
    _player = 0,
    _lastPlayerShapeTestTime = 0,
    _lastRaycastResultFailed = false
}

function TornadoVortex:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TornadoVortex.ActiveEntity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TornadoVortex.ActiveEntity:ActiveEntity(entity, xBias, yBias, blip)
    self.Entity = entity
    self.XBias = xBias
    self.YBias = yBias
    self._blip = blip
    self.IsPlayer = (entity == PlayerPedId())
end

function TornadoVortex:TornadoVortex(initialPosition)
    self._position = initialPosition
    self._destination = GetRandomPositionFromCoords(initialPosition, 1.0)
    self._player = PlayerPedId()
end

function TornadoVortex:Build()
    local layerSize = VORTEX_LAYER_SEPERATION_SCALE
    local radius = VORTEX_RADIUS
    local particleCount = VORTEX_PARTICLE_COUNT
    local maxLayers = VORTEX_MAX_PARTICLE_LAYERS
    local particleAsset = VORTEX_PARTICLE_ASSET
    local particleName = VORTEX_PARTICLE_NAME
    local multiplier = 359 / particleCount
    local particleSize = 3.0

    for i = 0, maxLayers, 1 do
        for angle = 0, particleCount, 1 do
            local position = self._position
            position = vec3(position.xy, position.z + layerSize * i)
            local rotation = vec3(angle * multiplier, 0, 0)
            local particle
            if i < 2 or i > maxLayers - 3 then
                particle = TornadoParticle:new()
                particle:TornadoParticle(self, position, rotation, "scr_agencyheistb", "scr_env_agency3b_smoke", radius, i)
                particle:StartFx(4.7)
                local sound = GameSound:new()
                sound:GameSound("Woosh_01", "FBI_HEIST_ELEVATOR_SHAFT_DEBRIS_SOUNDS")
                sound:PlayEnt(particle._prop)

                table.insert(self._loadedSounds, sound)
                table.insert(self._particles, particle)
            end
            particle = TornadoParticle:new()
            particle:TornadoParticle(self, position, rotation, particleAsset, particleName, radius, i)
            particle:StartFx(particleSize)
            radius = radius + 0.0799999982118607 * (0.720000028610229 * i)
            particleSize = particleSize + 0.00999999977648258 * (0.119999997317791 * i)
            table.insert(self._particles, particle)
        end
    end
end

function TornadoVortex:RemoveEntity(entityIdx)
    self._activeEntityCount = self._activeEntityCount - 1
    local ent = self._activeEntities[entityIdx]
    SetEntityMaxSpeed(ent.Entity, 2500.0)
    self._activeEntities[entityIdx] = nil
end

function TornadoVortex:PushBackEntity(entity)
    table.insert(self._activeEntities, entity)

    self._activeEntityCount = self._activeEntityCount + 1
end

function TornadoVortex:CollectNearbyEntities(maxDistanceDelta)
    -- Collect entities and shit
    -- Can't really do this the same way as C#
    -- so fuck you no flying entities (yet)
    local pos = self._position
    local function TryAddEnt(entity)
        if #(pos - GetEntityCoords(entity)) < maxDistanceDelta * 2 then
            local found = false
            for _, e in pairs(self._activeEntities) do
                if e.Entity == entity then
                    found = true
                    break
                end
            end
            if not found then
                local ent = self.ActiveEntity:new()
                -- local b = AddBlipForEntity(entity)
                ent:ActiveEntity(entity, 0.0, 0.0)
                self:PushBackEntity(ent)
            end
        end
    end
    if VORTEX_THROW_VEHICLES then
        local vehs = 0
        local next = true
        local handle, vehicle = FindFirstVehicle()
        while next do
            if vehicle then
                TryAddEnt(vehicle)
            end
            next, vehicle = FindNextVehicle(handle)
        end
        EndFindVehicle(handle)
        -- print("Collected " .. vehs .. " vehicles")
    end
    if VORTEX_THROW_PEDS then
        local peds = 0
        local next = true
        local handle, ped = FindFirstPed()
        while next do
            if ped then
                TryAddEnt(ped)
            end
            next, ped = FindNextPed(handle)
        end
        EndFindPed(handle)
    end
end

function TornadoVortex:UpdatePulledEntities(gameTime, maxDistanceDelta)
    local verticalForce = VORTEX_VERTICAL_PULL_FORCE
    local horizontalForce = VORTEX_HORIZONTAL_PULL_FORCE
    local topSpeed = VORTEX_TOP_ENTITY_SPEED
    for e = 0, self._activeEntityCount, 1 do
        if self._activeEntities[e] then
            local entity = self._activeEntities[e].Entity
            local dist = #(GetEntityCoords(entity) - self._position)
            if dist > (maxDistanceDelta * 4) - 12.6 or GetEntityHeightAboveGround(entity) > 500.0 then
                self:RemoveEntity(e)
            else
                local targetPos = vec3(self._position.x + self._activeEntities[e].XBias,
                    self._position.y + self._activeEntities[e].YBias, GetEntityCoords(entity).z)
                local direction = norm(targetPos - GetEntityCoords(entity))
                local forceBias = math.random(0, 100) / 100
                local force = self.ForceScale * (forceBias + forceBias / dist)

                if self._activeEntities[e].IsPlayer then
                    -- TODO: Player raycast and stuffs
                end
                if IsThisModelAPlane(GetEntityModel(entity)) then
                    force = force * 6.0
                    verticalForce = verticalForce * 6.0
                end
                if IsEntityAPed(entity) then
                    SetPedToRagdoll(entity, 1000, 1000, 1, 0, 0, 0)
                end
                -- TODO: Apply force to entities
                local _ef = direction * horizontalForce

                local upDir = norm(vec3(self._position.x, self._position.y, self._position.z + 1000.0) - GetEntityCoords(entity))
                local _ud = upDir * verticalForce
                ApplyForceToEntityCenterOfMass(entity, 1, _ud.x, _ud.y, _ud.z, 0, false, true, 0)
                local _cross = cross(direction, vec3(0.0, 0.0, 1.0))
                local _af = norm(_cross) * force * horizontalForce
                ApplyForceToEntityCenterOfMass(entity, 1, _af.x, _af.y, _af.z, 0, false, true, 0)
                SetEntityMaxSpeed(entity, topSpeed)
            end
        end
    end
end

function TornadoVortex:OnUpdate(gameTime)
    if VORTEX_MOVEMENT_ENABLED then
        -- INFO: Movement code
        if GetDistanceBetweenCoords(self._position, self._destination) < 15.0 then
            -- TODO: Movement around location
            self._destination = GetRandomPositionFromCoords(self._position, 1.0)
        end
        self._position = MoveTowards(self._position, self._destination, VORTEX_MOVE_SPEED_SCALE * 0.287)
        if exports.omni_common:isDebugging() then
            exports.omni_common:DrawText3D("TORNADO", self._position.x, self._position.y, self._position.z, 20.0)
            exports.omni_common:DrawText3D("DESTINATION", self._destination.x, self._destination.y, self._destination.z, 20.0)
        end
    end
    local maxEntityDist = VORTEX_MAX_ENTITY_DIST
    if gameTime > self._nextUpdateTime then
        self:CollectNearbyEntities(maxEntityDist)
        self._nextUpdateTime = gameTime + 50
    end
    for i = 0, #self._particles, 1 do
        if self._particles[i] then
            self._particles[i]:OnUpdate(gameTime)
        end
    end
    self:UpdatePulledEntities(gameTime, maxEntityDist)
end

function TornadoVortex:Dispose()
    for n, x in next, self._loadedSounds do
        -- Destroy x
    end
    for n, x in next, self._particles do
        x:Destroy()
        self._particles[n] = nil
    end
end
