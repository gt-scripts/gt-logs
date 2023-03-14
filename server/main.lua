logger = logger or {}

local logEnable = GetConvar("log.enable", false)
local logClient = GetConvar("log.client", false)
local logLevel = GetConvar("log.level", "INFO")
local logDate = GetConvar("log.date", "%d/%m/%Y %X")

local allowedLevels = {
    ["TRACE"] = "TRACE",
    ["DEBUG"] = "DEBUG,TRACE",
    ["INFO"] = "INFO,DEBUG,TRACE",
    ["WARN"] = "WARN,INFO,DEBUG,TRACE",
    ["ERROR"] = "ERROR,WARN,INFO,DEBUG,TRACE",
    ["FATAL"] = "FATAL,ERROR,WARN,INFO,DEBUG,TRACE"
}

local levelColor = {
    ["TRACE"] = "^9TRACE^7",
    ["DEBUG"] = "^2DEBUG^7",
    ["INFO"] = "^5INFO^7",
    ["WARN"] = "^3WARN^7",
    ["ERROR"] = "^1ERROR^7",
    ["FATAL"] = "^8FATAL^7"
}

local sideColor = {
    ["CLIENT"] = "^2CLIENT^7",
    ["SERVER"] = "^5SERVER^7"
}

RegisterCommand('logTest', function(source, args, rawCommand)
    logger.trace(GetCurrentResourceName(), logLevel)
	logger.info(GetCurrentResourceName(), logLevel)
    logger.warn(GetCurrentResourceName(), logLevel)
    logger.debug(GetCurrentResourceName(), logLevel)
    logger.error(GetCurrentResourceName(), logLevel)
    logger.fatal(GetCurrentResourceName(), logLevel)
end)
-------------------------------------------------------------------
-- [ LOCAL FUNCTIONS ]
-------------------------------------------------------------------
local function addBrackets(value)
    return string.format("[%s]", value)
end

local function fusion(val1, val2)
    return string.format("%s %s", val1 or "", val2 or "")
end

local function log(level, resource, side, value)
    local line = ""
    if(logDate ~= "") then
        line = addBrackets(os.date(logDate))
    end
    line = fusion(line, addBrackets(levelColor[level]))
    line = fusion(line, addBrackets(sideColor[side] or side))
    line = fusion(line, addBrackets(resource))
    line = fusion(line, "---")
    line = fusion(line, value)
    print(line)
    return line
end

local function sendToLog(level, resource, side, value)
    local resourceLogLevel = GetConvar(resource..".log.level", "INFO")
    if((not logEnable) or (resourceLogLevel == "INFO")) then return end
    if(allowedLevels[level] == nil) then
        log("WARN", resource, side, string.format("LogLevel %s not found, '%s' will be used.", level, resourceLogLevel))
        return log(resourceLogLevel, resource, side, value)
    end
    if(not string.find(allowedLevels[level], logLevel) and not string.find(allowedLevels[level], resourceLogLevel)) then return end
    return log(level, resource, side, value)
end

local function trace(resource, side, value)
    sendToLog("TRACE", resource, side, value)
end

local function debug(resource, side, value)
    sendToLog("DEBUG", resource, side, value)
end

local function info(resource, side, value)
    sendToLog("INFO", resource, side, value)
end

local function warn(resource, side, value)
    sendToLog("WARN", resource, side, value)
end

local function error(resource, side, value)
    sendToLog("ERROR", resource, side, value)
end

local function fatal(resource, side, value)
    sendToLog("FATAL", resource, side, value)
end
-------------------------------------------------------------------
-- [ FUNCTIONS ]
-------------------------------------------------------------------
function logger.trace(resource, value)
    trace(resource, "SERVER", value)
end

function logger.debug(resource, value)
    debug(resource, "SERVER", value)
end

function logger.info(resource, value)
    info(resource, "SERVER", value)
end

function logger.warn(resource, value)
    warn(resource, "SERVER", value)
end

function logger.error(resource, value)
    error(resource, "SERVER", value)
end

function logger.fatal(resource, value)
    fatal(resource, "SERVER", value)
end
-------------------------------------------------------------------
-- [ EVENTS ]
-------------------------------------------------------------------
RegisterServerEvent("Logs:Log", function(level, resource, value)
    sendToLog(level, resource, "SERVER", value)
end)

RegisterServerEvent("Logs:Client", function(level, resource, value)
    local log = sendToLog(level, resource, "CLIENT", value)
    if(log and logClient) then
        TriggerClientEvent("Logs:LogBack", source, log)
    end
end)

RegisterServerEvent("onServerResourceStop", function(resource)
    sendToLog("TRACE", resource, "SERVER", "Stopped")
end)

RegisterServerEvent("onServerResourceStart", function(resource)
    sendToLog("TRACE", resource, "SERVER", "Started")
end)

return logger
