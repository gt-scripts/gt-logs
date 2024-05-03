local scriptName = GetCurrentResourceName()

local function log(data, level, resource)
    TriggerServerEvent(scriptName .. ":Server:Log", data, level, resource)
end

RegisterNetEvent(scriptName, function(data, level, resource)
    log(data, level, resource)
end)

RegisterNetEvent(scriptName .. ":Client:Log", function(data)
    print(data)
end)

RegisterNetEvent("onClientResourceStop", function(resource)
    log("Stopped", "TRACE", resource)
end)

RegisterNetEvent("onClientResourceStart", function(resource)
    log("Started", "TRACE", resource)
end)

exports('log', log)
