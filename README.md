# gt-logs
A Logger intended for use with any FiveM framework.

As it works with client/server events, it may be fired by any script, e.g.:

```lua
TriggerEvent("gt-logs", "STRING_TO_LOG", "LOGLEVEL_HERE", SCRIPT_NAME_HERE)
```

It supports 6 levels of logging (INFO, WARN, DEBUG, ERROR, FATAL, TRACE), configured within the `config.lua`.
