_V = _V or {}

_V.CommandLib = {}

-- Arg handling --

_V.CommandLib.BoolTrue = {"true", "y", "yes", "1"}
_V.CommandLib.BoolFalse = {"false", "n", "no", "0"}

--[[
function _V.CommandLib.PlayerFromString(String)
	if string.match(String, "STEAM_[0-5]:[0-9]:[0-9]+") then
		return String
	elseif String == "*" then
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			table.insert(Found, player:SteamID())
		end
		return Found
	elseif String == "@" then
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			if b:IsAdmin() then
				table.insert(Found, b:SteamID())
			end
		end
		return Found
	elseif String == "!@" then
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			if !b:IsAdmin() then
				table.insert(Found, b:SteamID())
			end
		end
		return Found
	else
		local Found = {}
		for a, b in ipairs(player.GetAll()) do
			if string.lower(b:Nick()) == string.lower(String) then
				return {b:SteamID()}
			elseif string.sub(string.lower(b:Nick()), 1, string.len(String)) == string.lower(String) then
				table.insert(Found, b:SteamID())
			end
		end
		return Found
	end
end
]]--

function _V.CommandLib.PlayerFromSID(String)
	if string.match(String, "STEAM_[0-5]:[0-9]:[0-9]+") then
		for a, b in pairs(player.GetAll()) do
			if b:SteamID() == String then
				return b
			end
		end
		return
	end
end

function _V.CommandLib.PlayerFromString(String)
	local PlrSID = _V.CommandLib.PlayerFromSID(String)
	if PlrSID then
		return PlrSID
	end
	
	local Found = {}
	for a, b in ipairs(player.GetAll()) do
		if string.lower(b:Nick()) == string.lower(String) then
			return b
		elseif string.sub(string.lower(b:Nick()), 1, string.len(String)) == string.lower(String) then
			table.insert(Found, b)
		end
	end
	
	if #Found == 1 then
		return Found[1]
	end
end

_V.CommandLib.ArgTypes = {
	Player = {Parser = function(String, Sender)
		local Player = _V.CommandLib.PlayerFromString(String)
		if Player == nil then
			return "INC_TYPE"
		end
		
		if self.requireTarget and not SENDERCANTARGETPLAYER then
			return
		end
		return Player
	end, Name = "Player", requireTarget = true}, -- A player ( If canTarget then the sender must be able to target the player )
	Players = {Parser = function(String, Sender)
		local Player = _V.CommandLib.PlayerFromString(String)
		if Player == nil then
			return "INC_TYPE"
		end
		
		if self.requireTarget and not SENDERCANTARGETPLAYER then
			return
		end
		return Player
	end, Name = "Player", requireTarget = true}, -- A table of players ( If canTarget then the sender must be able to target the players )
	SteamID = {Parser = function(String, Sender)
		if string.match(String, "STEAM_[0-5]:[0-9]:[0-9]+") then
			return String
		else
			local Player = _V.CommandLib.PlayerFromString(String)
			if Player == nil then
				return "INC_TYPE"
			end
			return Player:SteamID()
		end
	end, Name = "SteamID"}, -- A list of players ( doesn't require targetability )
	String = {Parser = function(String)
		return String
	end, Name = "String"}, -- A string
	Number = {Parser = function(String)
		return tonumber(String) or "INC_TYPE"
	end, Name = "Number"}, -- A number
	Boolean = {Parser = function(String)
		if table.HasValue(_V.CommandLib.BoolTrue, string.lower(String)) then
			return true
		elseif stable.HasValue(_V.CommandLib.BoolFalse, string.lower(String)) then
			return false
		end
		return "INC_TYPE"
	end, Name = "Boolean"}, -- Check if the string is contained in either the Yes or No table
}

-- Command handling --

_V.CommandLib.Commands = {}

_V.CommandLib.Command = {
	Key = "", -- Key of the command ( Must be unique ) ( Recommended to be the name of the command )
	Callback = function(Sender, Alias, ...) end, -- The function to run when command is ran ( Overide this )
	Category = "", -- The category to list this command under
	Desc = "", -- Brief description of the command
	Alias = {}, -- A list of aliases the command uses
	Args = {}, -- A list of arguements the command requires
}

function unpackNil(t, i)
	-- Unpacks a table but replaces any string that is "nil" with nil
	i = i or 1
	if t[i] == "nil" then
		return nil, unpackNil(t, i + 1)
	elseif t[i] ~= nil then
		return t[i], unpackNil(t, i + 1)
	end
end

function _V.CommandLib.Command:addAlias(...)
	-- Adds the specified alias ( or aliases if multiple are supplied ) to the command
	for a, b in ipairs({...}) do
		if not table.HasValue(self.Alias, b) then
			table.insert(self.Alias, b)
		end
	end
	return self
end

function _V.CommandLib.Command:addArg(ArgType, ArgRequirement, Position)
	-- Adds the specified arg type and requirement into the commands args at the specified position
	local Arg = table.Copy(ArgType)
	Arg.required = ArgRequirement or true
	if Position then
		table.insert(self.Args, Position, Arg)
	else
		table.insert(self.Args, Arg)
	end
	return self, Arg
end

function _V.CommandLib.Command:preCall(Sender, Args, teamChat)
	-- This is called by the playersay hook to handle args and alias
	
	-- Makes sure the command isn't said in teamchat
	if teamChat then
		return
	end

	-- Check if the args contain the commands alias
	local AliasUsed = ""
	for a, b in ipairs(self.Alias) do
		if string.lower(Args[1]) == string.lower(b) then
			AliasUsed = b
			break
		end
	end
	
	if AliasUsed == "" then return end
	-- Remove the alias from the args to prevent it from being counted as an arg
	table.remove(Args, 1)

	-- Make sure there isn't any extra args
	if #Args > #self.Args then
		// ERROR INCORRECT USAGE
		return ""
	end
	
	--[[
	-- Make sure the sender can run the command
	if not Sender:HASPERM(self.Key) then
		// ERROR INCORRECT PERMS
		return ""
	end
	--]]
	
	-- Convert the args into the correct types
	local FinalArgs = {}
	for a, b in ipairs(self.Args) do
		local Arg = b.Parser(Args[a], Sender)
		if Arg != nil and Arg != "INC_TYPE" then
			table.insert(FinalArgs, Arg)
		elseif Arg == "INC_TYPE" then
			// "Arguement " .. a .. " was incorrect!" .. usage(?)
			return ""
		elseif b.required then
			// "Arguement " .. a .. " was missing" .. usage(?)
			return ""
		else
			table.insert(FinalArgs, "nil")
		end
	end
	
	-- Run the commands callback
	return self.Callback(Sender, AliasUsed, unpackNil(FinalArgs))
end

function _V.CommandLib.Command:getUsage(Alias, ArgPos)
	-- Returns the usage of the command or the type of a specific arguement
	-- Alias specifies the alias to be used and ArgPos specifies the arguement type to use
	if ArgPos then
		return self.Args[ArgPos]
	else
		local Alias = Alias or self.Alias[1]
		local Usage = Alias
		for a, b in ipairs(self.Args) do
			if b.required then
				Usage = Usage .. " " .. b.Name
			else
				Usage = Usage .. " [" .. b.Name .. "]"
			end
		end
		return Usage
	end
end

function _V.CommandLib.Command:new(LKey, LCallback, LCategory, LDesc)
	-- Creates a new command object and adds it to the command list
	-- Requires key to be valid
	local Object = {Key = LKey, Callback = LCallback, Category = LCategory, Desc = LDesc}
	setmetatable(Object, self)
	self.__index = self
	table.insert(_V.CommandLib.Commands, Object)
	return Object
end

hook.Add("PlayerSay", "_V-CommandLib-PlayerSay", function(Sender, Message, teamChat)
	local Args = string.Explode(Message, " ")
	local FinalMessage = nil
	for a, b in ipairs(_V.CommandLib.Commands) do
		if b.preCall then
			local Msg = b:preCall(Sender, Args, teamChat)
			if Msg then
				FinalMessage = Msg
			end
		end
	end
	return FinalMessage
end)