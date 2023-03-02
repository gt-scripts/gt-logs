RegisterNetEvent("Logs:Log", function(level, resource, value)
    TriggerServerEvent("Logs:Client", level, resource, value)
end)

RegisterNetEvent("Logs:LogBack", function(log)
    print(log)
end)

RegisterNetEvent("onClientResourceStop", function(resource)
    TriggerEvent("Logs:Log", "TRACE", resource, "Stopped")
end)

RegisterNetEvent("onClientResourceStart", function(resource)
    TriggerEvent("Logs:Log", "TRACE", resource, "Started")
end)
