local IsTornadoActive = false
local TornadoPosition = nil
local TornadoDestination = nil
local TornadoGirth = 8.0

local PossiblePositions = {
    {x = 2469.7680664063, y = -1261.8334960938, z = 18.676563262939},
    {x = 1273.0069580078, y = -2649.7578125, z = 32.269676208496},
    {x = -1293.2620849609, y = -1700.7102050781, z = 2.6835398674011},
    {x = -3039.9089355469, y = 341.40008544922, z = 13.486105918884},
    {x = -2102.1958007813, y = 2530.8842773438, z = 3.0150742530823},
    {x = 85.679382324219, y = 7032.0244140625, z = 12.286052703857},
    {x = 1954.2747802734, y = 5191.5024414063, z = 48.200130462646},
    {x = 3705.4135742188, y = 4651.7333984375, z = 11.050972938538},
}

AddEventHandler("omni_tornado:summon", function()
    local start = PossiblePositions[math.random(#PossiblePositions)]
    local destination = PossiblePositions[math.random(#PossiblePositions)]
    while start.x == destination.y do
        destination = PossiblePositions[math.random(#PossiblePositions)]
    end
    TornadoPosition = start
    TornadoDestination = destination
    IsTornadoActive = true
    TriggerClientEvent("omni_tornado:spawn", -1, start, destination)
    print("[Tornado] A tornado has spawned at " .. start.x .. ", " .. start.y .. ", " .. start.z)
end)

AddEventHandler("omni_tornado:dismiss", function()
    IsTornadoActive = false
    TriggerClientEvent("omni_tornado:delete", -1)
end)

RegisterCommand("tornado_summon", function()
    TriggerEvent("omni_tornado:summon")
end, true)

RegisterCommand("tornado_dismiss", function()
    TriggerEvent("omni_tornado:dismiss")
end, true)
