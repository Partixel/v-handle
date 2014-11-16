---- LogLib Config ----
VH_LogLib = VH_LogLib or {}
VH_LogLib.LogLocation = "v-handle/logs" -- The directory the file is located in
VH_LogLib.LogFile = "%d.%m.%y-log.txt" -- The name of the file - %d.%m.%y is replaced with DD.MM.YY
VH_LogLib.MessageLevel = 4 -- Any log type lower or equal to this will be printed to console
VH_LogLib.LogLevel = 1 -- Any log type between or equal to this and the MessageLevel will be written to file
