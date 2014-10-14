_V = _V or {}

_V.LogLib = {}

_V.LogLib.Type = {
	INFO = 0, -- Used for informational messages
	SEVERE = 1, -- Used to indicate a serious failure
	WARNING = 2, -- Used to indicate a potential problem
	DEBUG = 3, -- Used to supply additional debug informational messages
	CONFIG = 4, -- Used to supply static config variables
}

file.CreateDir(_V.Config.LogLib.LogLocation) -- Make sure the directories exist and initializes LogLocation

function _V.LogLib.Log(Message, Type)
	if type(Message) == "table" then
		
	elseif Message != nil then
		Message = tostring(Message)
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
		local MessageLevel = _V.Config.LogLib.MessageLevel
		if Type <= MessageLevel then
			-- Checks it the message should be printed to console
			print(Message) -- Print the message to the console
		end
		
		if _V.Config.LogLib.LogLevel <= Type and Type <= MessageLevel then
			-- Checks if the message should be logged to file
			local CurrentFile = tostring(os.date("%d.%m.%y-" .. _V.Config.LogLib.LogFile .. ".txt"))
			-- Creates/finds the file for the current day
			Message = os.date("%X ") .. string.Explode(" ", os.date("%Z"))[1] .. " - " .. Message
			-- Formats time and time zone into the message for log purposes
			file.Append(_V.Config.LogLib.LogLocation .. "/" .. CurrentFile, Message .. "\n")
			-- Add the message to the log file
		end
	else
		_V.LogLib.Log("Invalid message type: ".. type(Message), _V.LogLib.Type.SEVERE)
		return
	end
end