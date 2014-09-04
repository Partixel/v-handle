_V = _V or {}

_V.LogLib = {}

_V.LogLib.LogLocation = "_V/Logs" -- The directory the file is located in
_V.LogLib.LogFile = "log" -- The name of the file - %D gets replaced by the date

_V.LogLib.Type = {
	Message = 0, -- Used for messages to the console
	Error = 1, -- Used to report a fatal error
	Warning = 2 -- Used to warn of a potential/recoverable error
}

_V.LogLib.MessageLevel = 3 -- Any log type lower or equal to this will be printed to console
_V.LogLib.LogLevel = 1 -- Any log type higher or equal to this will be written to file

if !file.Exists(_V.LogLib.LogLocation .. "/" .. _V.LogLib.LogFile, "DATA") then
	file.CreateDir(_V.LogLib.LogLocation) -- Make sure the directories exist
end

function _V.LogLib.Log(Message, Type)
	if type(Message) == "table" then
		
	elseif type(Message) == "string" then
		if Type == _V.LogLib.Type.Message then
			Message = "V-Handle - " .. Message
		elseif Type == _V.LogLib.Type.Warning then
			Message = "V-Handle - WARNING - " .. Message
		elseif Type == _V.LogLib.Type.Error then
			Message = "V-Handle - ERROR - " .. Message
		else
			_V.LogLib.Log("Invalid log type type: ".. Message, _V.LogLib.Type.Error)
			return
		end
		
		if Type <= _V.LogLib.MessageLevel then
			print(Message) -- Print the message to the console
		end
		if Type >= _V.LogLib.LogLevel then
			local CurrentFile = tostring(os.date("%d.%m.%y-" .. _V.LogLib.LogFile .. ".txt"))
			file.Append(_V.LogLib.LogLocation .. "/" .. CurrentFile, Message .. "\n")
			-- Add the message to the log file
		end
	else
		_V.LogLib.Log("Invalid message type: ".. Message, _V.LogLib.Type.Error)
		return
	end
end