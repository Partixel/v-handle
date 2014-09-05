_V = _V or {}

_V.LogLib = {}

_V.LogLib.LogLocation = _V.ConfigLib.Get("LogLocation", "LibConfig", "_V/Logs")
-- The directory the file is located in
_V.LogLib.LogFile = _V.ConfigLib.Get("LogFile", "LibConfig", "log")
-- The name of the file - %D gets replaced by the date

_V.LogLib.MessageLevel = _V.ConfigLib.Get("MessageLevel", "LibConfig", 2)
-- Any log type lower or equal to this will be printed to console
_V.LogLib.LogLevel = _V.ConfigLib.Get("LogLevel", "LibConfig", 1)
-- Any log type between or equal to this and the MessageLevel will be written to file

_V.LogLib.Type = {
	INFO = 0, -- Used for informational messages
	SEVERE = 1, -- Used to indicate a serious failure
	WARNING = 2, -- Used to indicate a potential problem
	DEBUG = 3, -- Used to supply additional debug informational messages
	CONFIG = 4, -- Used to supply static config variables
}

file.CreateDir(_V.LogLib.LogLocation) -- Make sure the directories exist

function _V.LogLib.Log(Message, Type)
	if type(Message) == "table" then
		
	elseif Message != nil then
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
		-- Formates the messages depending on the type
		
		if Type <= _V.LogLib.MessageLevel then
			-- Checks it the message should be printed to console
			print(Message) -- Print the message to the console
		end
		if _V.LogLib.LogLevel <= Type and Type <= _V.LogLib.MessageLevel then
			-- Checks if the message should be logged to file
			local CurrentFile = tostring(os.date("%d.%m.%y-" .. _V.LogLib.LogFile .. ".txt"))
			-- Creates/finds the file for the current day
			Message = os.date("%X ") .. string.Explode(" ", os.date("%Z"))[1] .. " - " .. Message
			-- Formats time and time zone into the message for log purposes
			file.Append(_V.LogLib.LogLocation .. "/" .. CurrentFile, Message .. "\n")
			-- Add the message to the log file
		end
	else
		_V.LogLib.Log("Invalid message type: ".. Message, _V.LogLib.Type.SEVERE)
		return
	end
end

-- DEBUG MESSAGES

_V.LogLib.Log(_V.LogLib.LogLocation, _V.LogLib.Type.CONFIG)
_V.LogLib.Log(_V.LogLib.LogFile, _V.LogLib.Type.CONFIG)
_V.LogLib.Log(_V.LogLib.MessageLevel, _V.LogLib.Type.CONFIG)
_V.LogLib.Log(_V.LogLib.LogLevel, _V.LogLib.Type.CONFIG)