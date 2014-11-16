V-LogLib = {}

V-LogLib.Type = {
	INFO = 0, -- Used for informational messages
	SEVERE = 1, -- Used to indicate a serious failure
	WARNING = 2, -- Used to indicate a potential problem
	DEBUG = 3, -- Used to supply additional debug informational messages
	CONFIG = 4, -- Used to supply static config variables
}

LogLib.LogLocation = LogLib.LogLocation or "vh/Logs" -- The directory the file is located in
LogLib.LogFile = LogLib.LogFile or "log" -- The name of the file - Date + .txt are appended on after this
LogLib.MessageLevel = LogLib.MessageLevel or 4 -- Any log type lower or equal to this will be printed to console
LogLib.LogLevel = LogLib.LogLevel or 1 -- Any log type between or equal to this and the MessageLevel will be written to file

file.CreateDir(LogLib.LogLocation) -- Make sure the directories exist and initializes LogLocation

function V-LogLib.Log(Message, Type)
	if type(Message) == "table" then
		
	elseif Message != nil then
		Message = tostring(Message)
		if Type == V-LogLib.Type.INFO then
			Message = "V-Handle - " .. Message
		elseif Type == V-LogLib.Type.WARNING then
			Message = "V-Handle - WARNING - " .. Message
		elseif Type == V-LogLib.Type.SEVERE then
			Message = "V-Handle - ERROR - " .. Message
		elseif Type == V-LogLib.Type.DEBUG then
			Message = "V-Handle - DEBUG - " .. Message
		elseif Type == V-LogLib.Type.CONFIG then
			Message = "V-Handle - CONFIG - " .. Message
		else
			V-LogLib.Log("Invalid log type type: ".. Message, V-LogLib.Type.SEVERE)
			return
		end
		-- Formates the messages depending on the type
		local MessageLevel = LogLib.MessageLevel
		if Type <= MessageLevel then
			-- Checks it the message should be printed to console
			print(Message) -- Print the message to the console
		end
		
		if LogLib.LogLevel <= Type and Type <= MessageLevel then
			-- Checks if the message should be logged to file
			local CurrentFile = tostring(os.date("%d.%m.%y-" .. LogLib.LogFile .. ".txt"))
			-- Creates/finds the file for the current day
			Message = os.date("%X ") .. string.Explode(" ", os.date("%Z"))[1] .. " - " .. Message
			-- Formats time and time zone into the message for log purposes
			file.Append(LogLib.LogLocation .. "/" .. CurrentFile, Message .. "\n")
			-- Add the message to the log file
		end
	else
		V-LogLib.Log("Invalid message type: ".. type(Message), V-LogLib.Type.SEVERE)
		return
	end
end
