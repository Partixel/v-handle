_V = _V or {}

_V.CommandLib = {}

_V.CommandLib.ArgTypes = {
	TargetPlayer = function(String, Sender) local Player = GETPLAYERHERE if SENDERCANTARGETPLAYER then return Player end end, -- A player that the sender can target
	Player = function(String, Sender) return GETPLAYERHERE end, -- A player ( doesn't require targetability )
	String = function(String) return String or nil end, -- A string
	Number = function(String) return tonumber(String) or nil end, -- A number
	Boolean = function(String) if string.lower(String) == "true" or string.lower(String) == "y" then return true elseif string.lower(String) == "false" or string.lower(String) == "n" then return false end end, -- True / false OR Y / N
}

_V.CommandLib.Commands = {}

_V.CommandLib.Command = {
	Key = "", -- Key of the command ( Must be unique ) ( Recommended to be the name of the command )
	Callback = function(Sender, ...) end, -- The function to run when command is ran ( Overide this )
	Category = "", -- The category to list this command under
	Desc = "", -- Brief description of the command
	Alias = {}, -- A list of aliases the command uses
	Args = {}, -- A list of arguements the command requires
}

function unpackNil(t, i)
	i = i or 1
	if t[i] == "nil" then
		return nil, unpackNil(t, i + 1)
	elseif t[i] ~= nil then
		return t[i], unpackNil(t, i + 1)
	end
end

function _V.CommandLib.Command:addAlias(...)
	for a, b in pairs(arg) do
		if not table.HasValue(self.Alias, b) then
			table.insert(self.Alias, b)
		end
	end
	return self
end

function _V.CommandLib.Command:addArg(ArgType, ArgRequirement, Position)
	table.insert(self.Args, Position, {type = ArgType, required = ArgRequirement})
	return self
end

function _V.CommandLib.Command:preCall(Sender, Args)
	if #Args > #self.Args then
		// ERROR INCORRECT USAGE
		return ""
	end
	
	if not Sender:HASPERM(self.Key) then
		// ERROR INCORRECT PERMS
		return ""
	end
	
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
	return self.Callback(Sender, unpackNil(FinalArgs))
end

function _V.CommandLib.Command:new(Key, Callback)
	local Object = {Key = Key, Callback = Callback}
	setmetatable(Object, self)
	self.__index = self
	Object
	return Object
end