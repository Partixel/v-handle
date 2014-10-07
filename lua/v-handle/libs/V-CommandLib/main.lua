_V = _V or {}

_V.CommandLib = {}

_V.CommandLib.BoolTrue = {"true", "y", "yes", "1"}
_V.CommandLib.BoolFalse = {"false", "n", "no", "0"}

function _V.CommandLib.FormatList(List)
	for i, v in ipairs(List) do
		if i == #List - 1 then
			List[i] = v .. " and "
		elseif i != #List then
			List[i] = v .. ", "
		end
	end
	return List
end

function _V.CommandLib.FormatPlayer(Caller, Receiver, Player)
	if Caller == Receiver and Caller == Player then
		return "Yourself"
	elseif Caller == Player then
		return "Themselves"
	elseif Receiver == Player then
		return "You"
	else
		return Player:Nick()
	end
end

function _V.CommandLib.PlayersToString(Caller, Player, Players)
	local Names = {}
	for _, v in ipairs(Players) do
		table.insert(Names, _V.CommandLib.FormatPlayer(Caller, Player, v))
	end
	return table.concat(_V.CommandLib.FormatList(Names))
end

function _V.CommandLib.SendCommandMessage(Caller, PrePlayers, Players, PostPlayers, ExtraPlayers)
	for _, Player in ipairs(player.GetAll()) do
		local NewCaller = Caller:Nick()
		if Caller == Player then
			NewCaller = "You"
		end
		local NewPlayers = _V.CommandLib.PlayersToString(Caller, Player, Players)
		if ExtraPlayers then
			local NewExtraPlayers = _V.CommandLib.PlayersToString(Caller, Player, ExtraPlayers)
			vh.ChatUtil.SendMessage("_lime_ "..NewCaller.." _white_ "..PrePlayers.." _reset_ "..NewPlayers.." _white_ "..PostPlayers.." _reset_ "..NewExtraPlayers, Player)
		else
			vh.ChatUtil.SendMessage("_lime_ "..NewCaller.." _white_ "..PrePlayers.." _reset_ "..NewPlayers.." _white_ "..PostPlayers, Player)
		end
	end
end

function _V.CommandLib.DoToggleableCommand(Command, On, Off, Toggle)
	if table.HasValue(On, Command) then
		return true, false
	elseif table.HasValue(Off, Command) then
		return false, false
	elseif table.HasValue(Toggle, Command) then
		return false, true
	end
end

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

function _V.CommandLib.PlayerFromIP(String)
	if string.match(String, "(%d+)%.(%d+)%.(%d+)%.(%d+)") then
		for a, b in pairs(player.GetAll()) do
			if b:IPAddress() == String then
				return b
			end
		end
		return
	end
end

function _V.CommandLib.PlayerFromString(String)
	local PlrSpec = _V.CommandLib.PlayerFromSID(String)
	if PlrSpec then
		return PlrSpec
	end
	
	PlrSpec = _V.CommandLib.PlayerFromIP(String)
	if PlrSpec then
		return PlrSpec
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

_V.CommandLib.UserTypes = {
	User = function(Player) return true end,
	Admin = function(Player) return Player:IsAdmin() or Player:IsSuperAdmin() end,
	SuperAdmin = function(Player) return Player:IsSuperAdmin() end,
}

_V.CommandLib.ArgTypes = {
	Player = {Parser = function(self, Args, Sender)
		local Player = _V.CommandLib.PlayerFromString(Args[1])
		table.remove(Args, 1)
		if Player == nil then
			return
		end
		
		if self.requireTarget and not Player:PLCanTarget(Sender) then
			return
		end
		return Player
	end, Name = "Player", requireTarget = true}, -- A player ( If canTarget then the sender must be able to target the player )
	Players = {Parser = function(self, Args, Sender)
		local Players = {}
		if Args[1] == "*" then
			Players = player.GetAll()
			table.remove(Args, 1)
		elseif Args[1] == "@" then
			for a, b in ipairs(player.GetAll()) do
				if b:IsAdmin() then
					table.insert(Players, b)
				end
			end
			table.remove(Args, 1)
		elseif Args[1] == "!@" then
			for a, b in ipairs(player.GetAll()) do
				if not b:IsAdmin() then
					table.insert(Players, b)
				end
			end
			table.remove(Args, 1)
		else
			Players = {_V.CommandLib.PlayerFromString(Args[1])}
			table.remove(Args, 1)
		end
		
		local Targets = {}
		for a, b in ipairs(Players) do
			if self.requireTarget and not b:PLCanTarget(Sender) then
				continue
			end
			table.insert(Targets, b)
		end
		
		if #Targets == 0 then
			return
		end
		
		return Targets
	end, Name = "Players", requireTarget = true}, -- A table of players ( If canTarget then the sender must be able to target the players )
	SteamID = {Parser = function(self, Args, Sender)
		local String = Args[1]
		table.remove(Args, 1)
		if string.match(String, "STEAM_[0-5]:[0-9]:[0-9]+") then
			return String
		else
			local Player = _V.CommandLib.PlayerFromString(String)
			if Player == nil then
				return
			end
			return Player:SteamID()
		end
	end, Name = "SteamID"}, -- A steamID of a player (From string or player name or IP)
	IPAddress = {Parser = function(self, Args, Sender)
		local String = Args[1]
		table.remove(Args, 1)
		if string.match(String, "(%d+)%.(%d+)%.(%d+)%.(%d+)") then
			return String
		else
			local Player = _V.CommandLib.PlayerFromString(String)
			if Player == nil then
				return
			end
			return Player:IPAddress()
		end
	end, Name = "IPAddress"}, -- An IP Address of a player (From string or player name or SteamID)
	String = {Parser = function(self, Args)
		local Amount = self.argAmount or #Args
		local String = table.concat(Args, " ", 1, Amount)
		for a = 1, Amount do
			table.remove(Args, 1)
		end
		return String
	end, Name = "String", argAmount = nil}, -- A string, ArgAmount is how many args it will concat into the string, nil for all
	Number = {Parser = function(self, Args)
		local String = Args[1]
		table.remove(Args, 1)
		return tonumber(String)
	end, Name = "Number"}, -- A number
	Boolean = {Parser = function(self, Args)
		local String = Args[1]
		table.remove(Args, 1)
		if table.HasValue(_V.CommandLib.BoolTrue, string.lower(String)) then
			return true
		elseif stable.HasValue(_V.CommandLib.BoolFalse, string.lower(String)) then
			return false
		end
	end, Name = "Boolean"}, -- Check if the string is contained in either the Yes or No table
}

-- Command handling --

_V.CommandLib.Commands = {}

_V.CommandLib.Command = {
	Key = "", -- Key of the command ( Must be unique ) ( Recommended to be the name of the command )
	Callback = function(Sender, Alias, ...) end, -- The function to run when command is ran ( Overide this )
	UserType = function() end, -- The type of user that can use the command
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

function _V.CommandLib.Command:addArg(ArgType, CustomTable, Position)
	-- Adds the specified arg type and requirement into the commands args at the specified position
	local Arg = table.Copy(ArgType)
	
	if CustomTable then
		for a, b in pairs(CustomTable) do
			Arg[a] = b
		end
	end
	
	if Position then
		if self.Args[Position] then
			table.insert(self.Args[Position], Arg)
		else
			table.insert(self.Args, Position, {Arg})
		end
	else
		table.insert(self.Args, {Arg})
	end
	
	return self, Arg
end

function _V.CommandLib.Command:canUse(Sender)
	return self.UserType(Sender)
end

function _V.CommandLib.Command:preCall(Sender, Alias, Args, teamChat)
	-- This is called by the playersay hook
	
	-- Makes sure the command isn't said in teamchat
	if teamChat then
		return
	end
	
	-- Make sure the sender can run the command
	if not self:canUse(Sender) then
		return "noperms"
	end
	
	-- Convert the args into the correct types
	local FinalArgs = {}
	for a, b in ipairs(self.Args) do
		if Args[1] and string.lower(Args[1]) != "nil" then
			local Arg = nil
			for c, d in ipairs(b) do
				Arg = d:Parser(Args, Sender)
				if Arg then
					break
				end
			end
			
			if Arg != nil then
				table.insert(FinalArgs, Arg)
			else
				return "Argument " .. a .. " was incorrect! " .. "Usage: " .. self:getUsage()
			end
		elseif b.required then
			return "Argument " .. a .. " was missing! " .. "Usage: " .. self:getUsage()
		else
			table.insert(FinalArgs, "nil")
		end
	end
	
	if #Args != 0 then
		return "Too many arguments given! " .. "Usage: " .. self:getUsage()
	end
	
	-- Run the commands callback
	return self.Callback(Sender, Alias, unpackNil(FinalArgs))
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

function _V.CommandLib.Command:new(Key, UserType, Desc, Category, Callback)
	-- Creates a new command object and adds it to the command list
	-- Requires key to be valid
	local Object = table.Copy(self)
	Object.Key = Key
	Object.UserType = UserType
	Object.Desc = Desc
	Object.Category = Category
	Object.Callback = Callback
	table.insert(_V.CommandLib.Commands, Object)
	
	return Object
end

function _V.CommandLib.PlayerSay(Sender, Message, teamChat)
	local Args = string.Explode(" ", Message)
	local Alias = string.lower(Args[1])
	table.remove(Args, 1)
	
	for a, b in ipairs(_V.CommandLib.Commands) do
		local Found = false
		
		for a, b in ipairs(b.Alias) do
			if Alias == string.lower(b) then
				Found = true
				break
			end
		end
		
		if not Found then continue end
		
		return b:preCall(Sender, Alias, Args, teamChat)
	end
end

hook.Add("PlayerSay", "_V-CommandLib-PlayerSay", _V.CommandLib.PlayerSay)