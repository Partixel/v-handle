_V = _V or {}

_V.Config = {}

---- LogLib Config ----
_V.Config.LogLib = {}

_V.Config.LogLib.LogLocation = "_V/Logs" -- The directory the file is located in

_V.Config.LogLib.LogFile = "log" -- The name of the file - Date + .txt are appended on after this

_V.Config.LogLib.MessageLevel = 4 -- Any log type lower or equal to this will be printed to console

_V.Config.LogLib.LogLevel = 1 -- Any log type between or equal to this and the MessageLevel will be written to file