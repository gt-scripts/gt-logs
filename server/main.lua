logger = logger or {}

local logEnable = GetConvar("log.enable", false)
local logLevel = GetConvar("log.level", "INFO")
local logDate = GetConvar("log.date", "%d/%m/%Y %X")

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
local function getLevel(level)
    if(level == "INFO") then
        return string.format("^5%s^7", level)
    elseif(level == "WARN") then
        return string.format("^3%s^7", level)
    elseif(level == "TRACE") then
        return string.format("^9%s^7", level)
    elseif(level == "ERROR") then
        return string.format("^1%s^7", level)
    elseif(level == "FATAL") then
        return string.format("^8%s^7", level)
    else
        return string.format("^2%s^7", level)
    end
end

local function addBrackets(value)
    return string.format("[%s]", value)
end

local function fusion(val1, val2)
    return string.format("%s %s", val1 or "", val2 or "")
end

local function log(level, resource, side, value)
    local line = nil
    if(logDate ~= "") then
        line = addBrackets(os.date(logDate))
    end
    line = fusion(line, addBrackets(getLevel(level)))
    line = fusion(line, addBrackets(side))
    line = fusion(line, addBrackets(resource))
    line = fusion(line, "---")
    line = fusion(line, value)
    print(line)
end

local function trace(resource, side, value)
    if(not logEnable) then return end
    if(not string.find("TRACE", logLevel)) then return end
    log("TRACE", resource, side, value)
end

local function debug(resource, side, value)
    if(not logEnable) then return end
    if(not string.find("DEBUG,TRACE", logLevel)) then return end
    log("DEBUG", resource, side, value)
end

local function info(resource, side, value)
    if(not logEnable) then return end
    if(not string.find("INFO,DEBUG,TRACE", logLevel)) then return end
    log("INFO", resource, side, value)
end

local function warn(resource, side, value)
    if(not logEnable) then return end
    if(not string.find("WARN,INFO,DEBUG,TRACE", logLevel)) then return end
    log("WARN", resource, side, value)
end

local function error(resource, side, value)
    if(not logEnable) then return end
    if(not string.find("ERROR,WARN,INFO,DEBUG,TRACE", logLevel)) then return end
    log("ERROR", resource, side, value)
end

local function fatal(resource, side, value)
    if(not logEnable) then return end
    if(not string.find("FATAL,ERROR,WARN,INFO,DEBUG,TRACE", logLevel)) then return end
    log("FATAL", resource, side, value)
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
