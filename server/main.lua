local scriptName = GetCurrentResourceName()
local logLevels = {
    TRACE = {
        priority = 6,
        allows = "TRACE",
        color = "^9TRACE^7"
    },
    DEBUG = {
        priority = 5,
        allows = "DEBUG,TRACE",
        color = "^2DEBUG^7"
    },
    INFO = {
        priority = 4,
        allows = "INFO,DEBUG,TRACE",
        color = "^5INFO^7"
    },
    WARN = {
        priority = 3,
        allows = "WARN,INFO,DEBUG,TRACE",
        color = "^3WARN^7"
    },
    ERROR = {
        priority = 2,
        allows = "ERROR,WARN,INFO,DEBUG,TRACE",
        color = "^1ERROR^7"
    },
    FATAL = {
        priority = 1,
        allows = "FATAL,ERROR,WARN,INFO,DEBUG,TRACE",
        color = "^8FATAL^7"
    },
    NONE = {
        priority = 0
    }
}

local sideColor = {
    CLIENT = "^2CLIENT^7",
    SERVER = "^5SERVER^7"
}

local function addBrackets(value)
    return string.format("[%s]", value)
end

local function concat(val1, val2)
    return string.format("%s %s", val1 or "", val2 or "")
end

local function log(source, data, level, resource, side)
    local resourceLogLevel = Config.ResourceOverride[resource] or "NONE"
    if not Config.Enable then
        return
    end

    local finalLevel = Config.LogLevel

    if logLevels[resourceLogLevel].priority >= logLevels[Config.LogLevel].priority then
        finalLevel = resourceLogLevel
    end

    if not string.find(logLevels[level].allows, finalLevel) then
        return
    end

    local line = ""
    if (Config.DateFormat ~= "") then
        line = addBrackets(os.date(Config.DateFormat))
    end
    line = concat(line, addBrackets(logLevels[level].color))
    line = concat(line, addBrackets(sideColor[side] or side))
    line = concat(line, addBrackets(resource))
    line = concat(line, "---")
    line = concat(line, data)
    print(line)
    if Config.EnableClient and source > 0 then
        TriggerClientEvent(scriptName .. ":Client:Log", source, line)
    end
end

RegisterNetEvent(scriptName, function(data, level, resource)
    log(0, data, level, resource, "SERVER")
end)

RegisterNetEvent(scriptName .. ":Server:Log", function(data, level, resource)
    log(source, data, level, resource, "CLIENT")
end)

RegisterServerEvent("onServerResourceStop", function(resource)
    log(0, "Stopped", "TRACE", resource, "SERVER")
end)

RegisterServerEvent("onServerResourceStart", function(resource)
    log(0, "Started", "TRACE", resource, "SERVER")
end)

RegisterCommand('logtest', function(source, args, rawCommand)
    log(source, string.format("Enabled %s logs, overriden with %s", Config.LogLevel, Config.ResourceOverride[scriptName]), "TRACE", scriptName, "SERVER")
    log(source, string.format("Enabled %s logs, overriden with %s", Config.LogLevel, Config.ResourceOverride[scriptName]), "DEBUG", scriptName, "SERVER")
    log(source, string.format("Enabled %s logs, overriden with %s", Config.LogLevel, Config.ResourceOverride[scriptName]), "INFO", scriptName, "SERVER")
    log(source, string.format("Enabled %s logs, overriden with %s", Config.LogLevel, Config.ResourceOverride[scriptName]), "WARN", scriptName, "SERVER")
    log(source, string.format("Enabled %s logs, overriden with %s", Config.LogLevel, Config.ResourceOverride[scriptName]), "ERROR", scriptName, "SERVER")
    log(source, string.format("Enabled %s logs, overriden with %s", Config.LogLevel, Config.ResourceOverride[scriptName]), "FATAL", scriptName, "SERVER")
end)
