_V = _V or {}

_V.CommandLib = {}

_V.CommandLib.BoolTrue = {"true", "y", "yes", "1"}
_V.CommandLib.BoolFalse = {"false", "n", "no", "0"}

_V.CommandLib.ArgTypes = {
	TargetPlayer = function(String, Sender)
		local Player = GETPLAYERHERE
		if SENDERCANTARGETPLAYER then
			return Player
		end
	end, -- A player that the sender can target
	MultiTargetPlayer = function(String, Sender)
		local Players = GETPLAYERSHERE
		local TargetablePlayers = {}
		for a, b in pairs(Players) do
			if SENDERCANTARGETB then
				table.insert(TargetablePlayers, b)
			end
		end
		return TargetablePlayers
	end, -- A list of players that the sender can target
	Player = function(String, Sender)
		return GETPLAYERHERE
	end, -- A player ( doesn't require targetability )
	MultiPlayer = function(String, Sender)
		return GETPLAYERSHERE
	end, -- A list of players ( doesn't require targetability )
	String = function(String)
		return String
	end, -- A string
	Number = function(String)
		return tonumber(String)
	end, -- A number
	Boolean = function(String)
		if table.HasValue(_V.CommandLib.BoolTrue, string.lower(String)) then
			return true
		elseif stable.HasValue(_V.CommandLib.BoolFalse, string.lower(String)) then
			return false
		end
	end, -- Check if the string is contained in either the Yes or No table
}

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
	for a, b in pairs(arg) do
		if not table.HasValue(self.Alias, b) then
			table.insert(self.Alias, b)
		end
	end
	return self
end

function _V.CommandLib.Command:addArg(ArgType, ArgRequirement, Position)
	-- Adds the specified arg type and requirement into the commands args at the specified position
	table.insert(self.Args, Position, {type = ArgType, required = ArgRequirement})
	return self
end

function _V.CommandLib.Command:preCall(Sender, Args, teamChat)
	-- This is called by the playersay hook to handle args and alias
	-- Can be overriden if the command requires something different
	
	-- Makes sure the command isn't said in teamchat
	if teamChat then
		return
	end

	-- Check if the args contain the commands alias
	local AliasUsed = ""
	for a, b in pairs(self.Alias) do
		if string.lower(Args[1]) == string.lower(b) do
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
	
	-- Make sure the sender can run the command
	if not Sender:HASPERM(self.Key) then
		// ERROR INCORRECT PERMS
		return ""
	end
	
	-- Convert the args into the correct types
	local FinalArgs = {}
	for a, b in ipairs(self.Args) do
		local Arg = b.type(Args[a], Sender)
		if Arg then
			table.insert(FinalArgs, Arg)
		elseif b.required then
			// ERROR MISSING ARG
			return ""
		else
			table.insert(FinalArgs, "nil")
		end
	end
	
	-- Run the commands callback
	return self.Callback(Sender, AliasUsed, unpackNil(FinalArgs))
end

function _V.CommandLib.Command:new(Key, Callback, Category, Desc)
	-- Creates the new command with they Key and Callback (Callback can be provided later)
	local Object = {Key = Key, Callback = Callback, Category = Category, Desc = Desc}
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