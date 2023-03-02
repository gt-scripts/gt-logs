# ttc-logs
A Logger intended for use with any Fivem framework.

As it works with client/server event, it may be fired by any script with the above Event Call:

```lua
    TriggerEvent("Logs:Log", "LOGLEVEL_HERE", SCRIPT_NAME_HERE, "STRING_TO_LOG")
```

It supports 6 levels of logging (INFO, WARN, DEBUG, ERROR, FATAL, TRACE), configured with convars:

* `log.enable` Boolean, default is false, enable or disable the entire log functionallity.
* `log.level` String, default is 'INFO', sets the log level, so you don't need to remove any call for logging at any part of your script.
* `log.date` String, default is '%d/%m/%Y %X', sets the date/time pattern to show in logs, '' will disable date and time.
* `SCRIPT_NAME_HERE.log.level` String default is not present. Sets and enables the log level for the desired script in particular.
