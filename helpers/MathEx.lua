function MoveTowards(current, target, maxDistanceDelta)
    local a = vec3(target.x - current.x, target.y - current.y, target.z - current.z)
    local magnitude = #a
    if magnitude <= maxDistanceDelta or magnitude <= 1.0 then
        return target
    end
    return vec3(current.x + a.x / magnitude * maxDistanceDelta, current.y + a.y / magnitude * maxDistanceDelta, current.z + a.z / magnitude * maxDistanceDelta)
end

MathEx = {}
MathEx.Euler = function(eulerAngles)
    local halfPhi = 0.5 * eulerAngles.x
    local halfTheta = 0.5 * eulerAngles.y
    local halfPsi = 0.5 * eulerAngles.z
    local cosHalfPhi = math.cos(halfPhi)
    local sinHalfPhi = math.sin(halfPhi)
    local cosHalfTheta = math.cos(halfTheta)
    local sinHalfTheta = math.sin(halfTheta)
    local cosHalfPsi = math.cos(halfPsi)
    local sinHalfPsi = math.sin(halfPsi)
    return vec4(
        cosHalfPhi * cosHalfTheta * cosHalfPsi - sinHalfPhi * sinHalfTheta * sinHalfPsi,
        sinHalfPhi * cosHalfTheta * cosHalfPsi + cosHalfPhi * sinHalfTheta * sinHalfPsi,
        cosHalfPhi * sinHalfTheta * cosHalfPsi - sinHalfPhi * cosHalfTheta * sinHalfPsi,
        cosHalfPhi * cosHalfTheta * sinHalfPsi + sinHalfPhi * sinHalfTheta * cosHalfPsi
    )
end
