_V = _V or {}

_V.LogLib = {}

_V.LogLib.LogLocation = "_V/Logs" -- The directory the file is located in
_V.LogLib.LogFile = "log" -- The name of the file - %D gets replaced by the date

_V.LogLib.Type = {
	INFO = 0, -- Used for informational messages
	SEVERE = 1, -- Used to indicate a serious failure
	WARNING = 2, -- Used to indicate a potential problem
	DEBUG = 3, -- Used to supply additional debug informational messages
	CONFIG = 4, -- Used to supply static config variables
}

_V.LogLib.MessageLevel = 2 -- Any log type lower or equal to this will be printed to console
_V.LogLib.LogLevel = 1 -- Any log type between or equal to this and the MessageLevel will be written to file

if !file.Exists(_V.LogLib.LogLocation .. "/" .. _V.LogLib.LogFile, "DATA") then
	file.CreateDir(_V.LogLib.LogLocation) -- Make sure the directories exist
end

function _V.LogLib.Log(Message, Type)
	if type(Message) == "table" then
		
	elseif type(Message) == "string" then
		if Type == _V.LogLib.Type.INFO then
			Message = "V-Handle - " .. Message
		elseif Type == _V.LogLib.Type.WARNING then
			Message = "V-Handle - WARNING - " .. Message
		elseif Type == _V.LogLib.Type.SEVERE then
			Message = "V-Handle - ERROR - " .. Message
		elseif Type == _V.LogLib.Type.DEBUG then
			Message = "V-Handle - DEBUG - " .. Message
		elseif Type == _V.LogLib.Type.CONFIG then
			Message = "V-Handle - CONFIG - " .. Message
		else
			_V.LogLib.Log("Invalid log type type: ".. Message, _V.LogLib.Type.SEVERE)
			return
		end
		
		if Type <= _V.LogLib.MessageLevel then
			print(Message) -- Print the message to the console
		end
		if _V.LogLib.LogLevel <= Type and Type <= _V.LogLib.MessageLevel then
			local CurrentFile = tostring(os.date("%d.%m.%y-" .. _V.LogLib.LogFile .. ".txt"))
			file.Append(_V.LogLib.LogLocation .. "/" .. CurrentFile, Message .. "\n")
			-- Add the message to the log file
		end
	else
		_V.LogLib.Log("Invalid message type: ".. Message, _V.LogLib.Type.SEVERE)
		return
	end
end
