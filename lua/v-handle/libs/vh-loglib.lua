VH_LogLib = VH_LogLib or {}

VH_LogLib.Type = {
	INFO = 0, -- Used for informational messages
	SEVERE = 1, -- Used to indicate a serious failure
	WARNING = 2, -- Used to indicate a potential problem
	DEBUG = 3, -- Used to supply additional debug informational messages
	CONFIG = 4, -- Used to supply static config variables
}

VH_LogLib.LogLocation = VH_LogLib.LogLocation or "vh/Logs" -- The directory the file is located in
VH_LogLib.LogFile = VH_LogLib.LogFile or "%d.%m.%y-log.txt" -- The name of the file - %d.%m.%y is replaced with DD.MM.YY
VH_LogLib.MessageLevel = VH_LogLib.MessageLevel or 4 -- Any log type lower or equal to this will be printed to console
VH_LogLib.LogLevel = VH_LogLib.LogLevel or 1 -- Any log type between or equal to this and the MessageLevel will be written to file

file.CreateDir(VH_LogLib.LogLocation) -- Make sure the directories exist and initializes LogLocation

function VH_LogLib.Log(Message, Type)
	if type(Message) == "table" then
		
	elseif Message != nil then
		Message = tostring(Message)
		if Type == VH_LogLib.Type.INFO then
			Message = "V-Handle - " .. Message
		elseif Type == VH_LogLib.Type.WARNING then
			Message = "V-Handle - WARNING - " .. Message
		elseif Type == VH_LogLib.Type.SEVERE then
			Message = "V-Handle - ERROR - " .. Message
		elseif Type == VH_LogLib.Type.DEBUG then
			Message = "V-Handle - DEBUG - " .. Message
		elseif Type == VH_LogLib.Type.CONFIG then
			Message = "V-Handle - CONFIG - " .. Message
		else
			VH_LogLib.Log("Invalid log type type: ".. Message, VH_LogLib.Type.SEVERE)
			return
		end
		-- Formates the messages depending on the type
		local MessageLevel = VH_LogLib.MessageLevel
		if Type <= MessageLevel then
			-- Checks it the message should be printed to console
			print(Message) -- Print the message to the console
		end
		
		if VH_LogLib.LogLevel <= Type and Type <= MessageLevel then
			-- Checks if the message should be logged to file
			local CurrentFile = os.date(VH_LogLib.LogFile)
			-- Creates/finds the file for the current day
			Message = os.date("%X ") .. string.Explode(" ", os.date("%Z"))[1] .. " - " .. Message
			-- Formats time and time zone into the message for log purposes
			file.Append(VH_LogLib.LogLocation .. "/" .. CurrentFile, Message .. "\n")
			-- Add the message to the log file
		end
	else
		VH_LogLib.Log("Invalid message type: ".. type(Message), VH_LogLib.Type.SEVERE)
		return
	end
end
