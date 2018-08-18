

Citizen.CreateThread(function()
    local Script = MainScript:new()
    Script:MainScript()
    local IsTornadoActive = false
    local Tornado = nil


    RegisterNetEvent("gd_tornado:spawn")
    AddEventHandler("gd_tornado:spawn", function(pos, dest)
        pos = vec3(pos.x, pos.y, pos.z)
        dest = vec3(dest.x, dest.y, dest.z)
        Tornado = Script._factory:CreateVortex(pos)
        Tornado._position = pos
        Tornado._destination = dest
        IsTornadoActive = true
    end)

    RegisterNetEvent("gd_tornado:setPosition")
    AddEventHandler("gd_tornado:setPosition", function(pos)
        pos = vec3(pos.x, pos.y, pos.z)
        Tornado = Script._factory:CreateVortex(pos)
        Tornado._position = pos
    end)

    RegisterNetEvent("gd_tornado:setDestination")
    AddEventHandler("gd_tornado:setDestination", function(dest)
        dest = vec3(dest.x, dest.y, dest.z)
        Tornado = Script._factory:CreateVortex(dest)
        Tornado._destination = dest
    end)

    RegisterNetEvent("gd_tornado:delete")
    AddEventHandler("gd_tornado:delete", function()
        IsTornadoActive = false
    end)

    while true do
        if IsTornadoActive and Tornado then
            Script:OnUpdate(GetGameTimer())
        else
            if Tornado then
                Tornado._position = vec3(10000.0, 10000.0, 0.0)
                Script:OnUpdate(GetGameTimer())
                Tornado = nil
            end
        end
        Wait(15)
    end

end)
