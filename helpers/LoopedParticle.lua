LoopedParticle = {
    _scale = 0.0,
    _alpha = 0.0,
    AssetName = "",
    FxName = "",
    Handle = 0,
}

function LoopedParticle:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function LoopedParticle:LoopedParticle(assetName, fxName)
    self.Handle = -1
    self.AssetName = assetName
    self.FxName = fxName
end

function LoopedParticle:Exists()
    return self.Handle ~= -1 and DoesParticleFxLoopedExist(self.Handle)
end

function LoopedParticle:IsLoaded()
    return HasNamedPtfxAssetLoaded(self.AssetName)
end

function LoopedParticle:Alpha(alpha)
    SetParticleFxLoopedAlpha(self.Handle, alpha)
    self._alpha = alpha
end

function LoopedParticle:Scale(scale)
    SetParticleFxLoopedScale(self.Handle, scale)
    self._scale = scale
end

function LoopedParticle:Color(r, g, b)
    SetParticleFxLoopedColour(self.Handle, r, g, b, 0)
end

function LoopedParticle:Load()
    RequestNamedPtfxAsset(self.AssetName)
end

function LoopedParticle:Start(entity, scale, offset, rotation, bone)
    if self.Handle ~= -1 then
        return false
    end
    self._scale = scale
    UseParticleFxAssetNextCall(self.AssetName)
    if offset == nil then
        offset = vec3(0.0, 0.0, 0.0)
    end
    if rotation == nil then
        rotation = vec3(0.0, 0.0, 0.0)
    end

    if bone ~= nil then
        self.Handle = StartParticleFxLoopedOnEntityBone(self.FxName, entity, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, bone, scale, 0, 0, 0)
    else
        self.Handle = StartParticleFxLoopedOnEntity(self.FxName, entity, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, scale, 0, 0, 1)
    end
end

function LoopedParticle:SetOffsets(offset, rotOffset)
    SetParticleFxLoopedOffsets(self.Handle, offset.x, offset.y, offset.z, rotOffset.x, rotOffset.y, rotOffset.z)
end

function LoopedParticle:SetEvolution(variableName, value)
    SetParticleFxLoopedEvolution(self.Handle, variableName, value, 0)
end

function LoopedParticle:Remove()
    if Handle == -1 then
        return false
    end
    StopParticleFxLooped(self.Handle, 0)
    RemoveParticleFx(self.Handle, 0)
    self.Handle = -1
end

function LoopedParticle:Unload()
    if self:IsLoaded() then
        RemoveNamedPtfxAsset(self.AssetName)
    end
end
