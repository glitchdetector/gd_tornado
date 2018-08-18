TornadoParticle = {
    LayerIndex = 0,
    Parent = nil,
    _centerPos = vec3(0.0, 0.0, 0.0),
    _offset = vec3(0.0, 0.0, 0.0),
    _rotation = vec3(0.0, 0.0, 0.0),
    _ptfx = nil,
    _radius = 0.0,
    _angle = 0.0,
    _layerMask = 0.0,
    _prop = nil,
}

function TornadoParticle:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TornadoParticle:TornadoParticle(vortex, position, angle, fxAsset, fxName, radius, layerIdx)
    self.Parent = vortex
    self._centerPos = position
    self._rotation = MathEx.Euler(angle)
    self._ptfx = LoopedParticle:new()
    self._ptfx:LoopedParticle(fxAsset, fxName)
    self._radius = radius
    self._offset = vec3(0.0, 0.0, VORTEX_LAYER_SEPERATION_SCALE * layerIdx)
    self.LayerIndex = layerIdx
    self._prop = self:Setup(position)
    self:PostSetup()
end

function TornadoParticle:PostSetup()
    self._layerMask = 1.0 - self.LayerIndex / VORTEX_MAX_PARTICLE_LAYERS
    self._layerMask = self._layerMask * 0.1 * self.LayerIndex
    self._layerMask = 1.0 - self._layerMask
    if self._layerMask <= 0.3 then
        self._layerMask = 0.3
    end
end

function TornadoParticle:Setup(position)
    local model = LoadModel("prop_beachball_02")
    local prop = CreateObject(model, position.x, position.y, position.z, false, 0, false)
    SetEntityCollision(prop, 0, 0)
    SetEntityVisible(prop, false, 0)
    -- AddBlipForEntity(prop)
    -- print("EEE")
    return prop
end

function TornadoParticle:SetPosition(center)
    self._centerPos = center
end

function TornadoParticle:SetScale(scale)
    self._ptfx:Scale(scale)
end

function TornadoParticle:OnUpdate(gameTime)
    self._centerPos = self.Parent._position + self._offset
    if math.abs(self._angle) > math.pi * 2.0 then
        self._angle = 0.0
    end
    self._angle = self._angle - VORTEX_ROTATION_SPEED * self._layerMask * GAME_LAST_FRAME_TIME
    local vortex = self.Parent._position
    local nx = math.min(self._offset.z, math.max(-self._offset.z, self._offset.x + math.random(-10,10) / 50))
    local ny = math.min(self._offset.z, math.max(-self._offset.z, self._offset.y + math.random(-10,10) / 50))
    self._offset = vec3(nx, ny, self._offset.z)
    local offset = self._offset
    self:SetScale(3.0 + self._offset.z / VORTEX_GIRTH_MOD)
    SetEntityCoords(self._prop, vortex.x + offset.x, vortex.y + offset.y, vortex.z + offset.z, 0, 0, 0, 0)
end

function TornadoParticle:StartFx(scale)
    if not self._ptfx:IsLoaded() then
        self._ptfx:Load()
    end
    self._ptfx:Start(self._prop, scale)
    self._ptfx.Alpha = 0.5
end

function TornadoParticle:RemoveFx()
    self._ptfx:Remove()
end

function TornadoParticle:Dispose()
    self:RemoveFx()
    DeleteProp(self._prop)
end
