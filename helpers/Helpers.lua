function GetRandomPositionFromCoords(position, multiplier)
    local randX, randY = 0.0, 0.0
    local v1 = math.floor(GetRandomIntInRange(0, 3999) / 1000)
    if v1 == 0 then
        randX = GetRandomFloatInRange(50.0, 200.0) * multiplier
        randY = GetRandomFloatInRange(-50.0, 50.0) * multiplier
    elseif v1 == 1 then
        randX = GetRandomFloatInRange(50.0, 200.0) * multiplier
        randY = GetRandomFloatInRange(-50.0, 50.0) * multiplier
    elseif v1 == 2 then
        randX = GetRandomFloatInRange(-50.0, -200.0) * multiplier
        randY = GetRandomFloatInRange(50.0, 50.0) * multiplier
    else
        randX = GetRandomFloatInRange(50.0, -200.0) * multiplier
        randY = GetRandomFloatInRange(-50.0, 50.0) * multiplier
    end
    return vec3(randX + position.x, randY + position.y, position.z)
end

function LoadModel(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) and IsModelInCdimage(hash) do
        Wait(50)
    end
    return hash
end
