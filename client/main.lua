logger = logger or {}

function logger.trace(resource, value)
    trace(resource, "CLIENT", value)
end

function logger.debug(resource, value)
    debug(resource, "CLIENT", value)
end

function logger.info(resource, value)
    info(resource, "CLIENT", value)
end

function logger.warn(resource, value)
    warn(resource, "CLIENT", value)
end

function logger.error(resource, value)
    error(resource, "CLIENT", value)
end

function logger.fatal(resource, value)
    fatal(resource, "CLIENT", value)
end

return logger
