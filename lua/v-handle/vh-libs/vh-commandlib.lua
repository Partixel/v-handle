VH_CommandLib = {}

VH_FileLib.IncludeFile("v-handle/vh-libs/vh-hooklib.lua", VH_FileLib.Side.Shared)

VH_CommandLib.BoolTrue = {"true", "y", "yes", "1"}
VH_CommandLib.BoolFalse = {"false", "n", "no", "0"}
VH_CommandLib.TimeEnds = {S = 1, M = 60, H = 3600, D = 86400, W = 604800}

function VH_CommandLib.FormatList(List)
	for i, v in ipairs(List) do
		if i == #List - 1 then
			List[i] = v .. " and "
		elseif i != #List then
			List[i] = v .. ", "
		end
	end
	return List
end

function VH_CommandLib.FormatPlayer(Caller, Receiver, Player)
	if Caller == Receiver and Caller == Player then
		return "Yourself"
	elseif Caller == Player then
		return "Themselves"
	elseif Receiver == Player then
		return "You"
	elseif type(Player) == "string" then
		return VH_DataLib.getData(Player, "SavedNick") or Player
	else
		return Player:Nick()
	end
end

function VH_CommandLib.PlayersToString(Caller, Player, Players)
	local Names = {}
	for _, v in ipairs(Players) do
		table.insert(Names, VH_CommandLib.FormatPlayer(Caller, Player, v))
	end
	return table.concat(VH_CommandLib.FormatList(Names))
end

function VH_CommandLib.SendCommandMessage(Caller, PrePlayers, Players, PostPlayers, ExtraPlayers)
	for _, Player in ipairs(player.GetAll()) do
		local NewCaller = Caller:Nick()
		if Caller == Player then
			NewCaller = "You"
		end
		local NewPlayers = VH_CommandLib.PlayersToString(Caller, Player, Players)
		if ExtraPlayers then
			local NewExtraPlayers = VH_CommandLib.PlayersToString(Caller, Player, ExtraPlayers)
			--vh.ChatUtil.SendMessage("_lime_ "..NewCaller.." _white_ "..PrePlayers.." _reset_ "..NewPlayers.." _white_ "..PostPlayers.." _reset_ "..NewExtraPlayers, Player)
		else
			--vh.ChatUtil.SendMessage("_lime_ "..NewCaller.." _white_ "..PrePlayers.." _reset_ "..NewPlayers.." _white_ "..PostPlayers, Player)
		end
	end
end

function VH_CommandLib.DoToggleableCommand(Command, On, Off, Toggle)
	if table.HasValue(On, Command) then
		return true, false
	elseif table.HasValue(Off, Command) then
		return false, false
	elseif table.HasValue(Toggle, Command) then
		return false, true
	end
end

function VH_CommandLib.PlayerFromSID(String)
	if String == nil then
		return nil
	end
	if string.match(String, "STEAM_[0-5]:[0-9]:[0-9]+") then
		for a, b in pairs(player.GetAll()) do
			if b:SteamID() == String then
				return b
			end
		end
		return
	end
end

function VH_CommandLib.PlayerFromIP(String)
	if String == nil then
		return nil
	end
	if string.match(String, "(%d+)%.(%d+)%.(%d+)%.(%d+)") then
		for a, b in pairs(player.GetAll()) do
			if b:IPAddress() == String then
				return b
			end
		end
		return
	end
end

function VH_CommandLib.SIDFromString(String)
	for a, b in pairs(VH_DataLib.DataTable) do
		if b.SavedNick and string.find(string.lower(b.SavedNick), string.lower(String)) then
			return a
		end
	end
end

function VH_CommandLib.PlayerFromString(String)
	if String == nil then
		return nil
	end

	local PlrSpec = VH_CommandLib.PlayerFromSID(String)
	if PlrSpec then
		return PlrSpec
	end
	
	PlrSpec = VH_CommandLib.PlayerFromIP(String)
	if PlrSpec then
		return PlrSpec
	end
	
	local Found = {}
	for a, b in ipairs(player.GetAll()) do
		if string.lower(b:Nick()) == string.lower(String) then
			return b
		elseif string.find(string.lower(b:Nick()), string.lower(String)) then
			table.insert(Found, b)
		end
	end
	
	if #Found == 1 then
		return Found[1]
	end
end

VH_CommandLib.UserTypes = {
	User = function(Player) return true end,
	Admin = function(Player) return Player:IsAdmin() or Player:IsSuperAdmin() end,
	SuperAdmin = function(Player) return Player:IsSuperAdmin() end,
}

VH_CommandLib.ArgTypes = {
	Player = {Parser = function(self, Args, Sender)
		local Player = nil
		if (Args[1] == "" or Args[1] == nil) and not self.notSelf and type(Sender) == "Player" then
			Player = Sender
		else
			Player = VH_CommandLib.PlayerFromString(Args[1])
			table.remove(Args, 1)
		end
		
		if Player == nil then
			return nil, "No player was found!"
		end
		
		if self.requireTarget and Player.PLCanTarget and not Player:PLCanTarget(Sender) then
			return nil, "No targetable player was found!"
		end
		return Player
	end, Name = "Player", requireTarget = true}, -- A player ( If requireTarget then the sender must be able to target the player )
												 -- ( If notSelf then target must not be sender )
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
		elseif Args[1] == "#" then
			table.insert(Players, player.GetAll()[math.random(1, #player.GetAll())])
			table.remove(Args, 1)
		else
			if (Args[1] == "" or Args[1] == nil) and not self.notSelf and type(Sender) == "Player" then
				Players = {Sender}
			else
				Players = {VH_CommandLib.PlayerFromString(Args[1])}
				table.remove(Args, 1)
			end
		end
		
		local Targets = {}
		for a, b in ipairs(Players) do
			if self.requireTarget and b.PLCanTarget and not b:PLCanTarget(Sender) then
				continue
			end
			if self.notSelf and b == Sender then
				continue
			end
			table.insert(Targets, b)
		end
		
		if #Targets == 0 then
			if self.requireTarget then
				return nil, "No targetable players were found!"
			else
				return nil, "No players were found!"
			end
		end
		
		return Targets
	end, Name = "Players", requireTarget = true}, -- A table of players ( If requireTarget then the sender must be able to target the players )
	SteamID = {Parser = function(self, Args, Sender)
		local String = Args[1]
		table.remove(Args, 1)
		if string.match(String, "STEAM_[0-5]:[0-9]:[0-9]+") then
			return String
		else
			local Player = VH_CommandLib.PlayerFromString(String)
			if Player then
				return Player:SteamID()
			else
				return VH_CommandLib.SIDFromString(String), "No Steam ID was found!"
			end
			return Player:SteamID()
		end
		return nil, "No Steam ID was found!"
	end, Name = "SteamID"}, -- A steamID of a player (From string or player name or IP)
	IPAddress = {Parser = function(self, Args, Sender)
		local String = Args[1]
		table.remove(Args, 1)
		if string.match(String, "(%d+)%.(%d+)%.(%d+)%.(%d+)") then
			return String
		else
			local Player = VH_CommandLib.PlayerFromString(String)
			if Player == nil then
				return
			end
			return Player:IPAddress()
		end
		return nil, "No IP Address was found!"
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
		return tonumber(String), "No number found!"
	end, Name = "Number"}, -- A number
	Boolean = {Parser = function(self, Args)
		local String = Args[1]
		table.remove(Args, 1)
		if table.HasValue(VH_CommandLib.BoolTrue, string.lower(String)) then
			return true
		elseif stable.HasValue(VH_CommandLib.BoolFalse, string.lower(String)) then
			return false
		end
		return nil, "No boolean found!"
	end, Name = "Boolean"}, -- Check if the string is contained in either the Yes or No table
	Time = {Parser = function(self, Args)
		local String = string.lower(Args[1])
		table.remove(Args, 1)
		local Time, End = tonumber(string.Left(String, #String -1)), String.GetChar(String, #String)
		if Time and VH_CommandLib.TimeEnds[End] then
			return Time * VH_CommandLib.TimeEnds[End], "No time found!"
		end
		return nil, "No time found!"
	end, Name = "Time"}, -- A time value, formatted as Number-TimeFrame, e.g 2D, 20M
}

-- Command handling --

VH_CommandLib.Commands = VH_CommandLib.Commands or {}
VH_CommandLib.CommandKeys = VH_CommandLib.CommandKeys or {}

VH_CommandLib.Command = {
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

function VH_CommandLib.Command:addAlias(...)
	-- Adds the specified alias ( or aliases if multiple are supplied ) to the command
	
	for a, b in ipairs({...}) do
		if not table.HasValue(self.Alias, b) then
			table.insert(self.Alias, b)
		end
	end
	
	return self
end

function VH_CommandLib.Command:addArg(ArgType, CustomTable, Position)
	-- Adds the specified arg type and requirement into the commands args at the specified position
	local Arg = table.Copy(ArgType)
	
	if CustomTable then
		for a, b in pairs(CustomTable) do
			Arg[a] = b
		end
	end
	
	if Position then
		table.insert(self.Args, Position, Arg)
	else
		table.insert(self.Args, Arg)
	end
	
	return self, Arg
end

function VH_CommandLib.Command:canUse(Sender)
	return Sender == nil or self.UserType(Sender)
end

function VH_CommandLib.Command:preCall(Sender, Alias, Args, teamChat)
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
		local Arg, Reason = b:Parser(Args, Sender)
		
		if Arg then
			table.insert(FinalArgs, Arg)
		elseif b.required then
			Reason = Reason or "Argument " .. a .. " was incorrect!"
			return Reason .. "\nUsage: " .. self:getUsage()
		else
			table.insert(FinalArgs, "nil")
		end
	end
	
	if #Args != 0 then
		return "Too many arguments given!\nUsage: " .. self:getUsage()
	end
	
	-- Run the commands callback
	return self.Callback(Sender, Alias, unpackNil(FinalArgs))
end

function VH_CommandLib.Command:getUsage(Alias, ArgPos)
	-- Returns the usage of the command or the type of a specific arguement
	-- Alias specifies the alias to be used and ArgPos specifies the arguement type to use
	if ArgPos then
		return self.Args[ArgPos][1]
	else
		local Alias = Alias or self.Alias[1]
		if type(Alias) == "table" then
			if Alias.Prefix and Alias.Alias then
				if type(Alias.Alias) == "table" then
					Alias = Alias.Alias[1]
				else
					Alias = Alias.Alias
				end
			end
		end
		
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

function VH_CommandLib.Command:new(Key, UserType, Desc, Category, Callback)
	-- Creates a new command object and adds it to the command list
	-- Requires key to be valid
	local Object = table.Copy(self)
	Object.UserType = UserType or VH_CommandLib.UserTypes.Admin
	Object.Desc = Desc or ""
	Object.Category = Category or ""
	Object.Callback = Callback
	VH_CommandLib.Commands[Key] = Object
	VH_CommandLib.CommandKeys = table.GetKeys(VH_CommandLib.Commands)
	
	return Object
end

function VH_CommandLib.PlayerSay(Sender, Message, teamChat, Console)
	local Args = (type(Message) == "table") and Message or string.Explode(" ", Message)
	
	local Alias = string.lower(Args[1])
	table.remove(Args, 1)
	
	local MatchingCmds = {}
	local TempCmds = VH_CommandLib.CommandKeys
	
	-- First filter out any commands that can't be ran
	for a, b in ipairs(TempCmds) do
		local Cmd = VH_CommandLib.Commands[b]
		if Console and not Cmd.ChatOnly then
			table.insert(MatchingCmds, b)
			continue
		end
		if not Console and not Cmd.ConsoleOnly then
			table.insert(MatchingCmds, b)
			continue
		end
	end
	
	local CmdKey = nil
	
	-- Next filter out any commands that don't match the alias
	for a, b in ipairs(MatchingCmds) do
		local Cmd = VH_CommandLib.Commands[b]
		for c, d in ipairs(Cmd.Alias) do
			-- String alias may only be used by console
			if type(d) == "string" and Console then
				if string.lower(d) == Alias then
					CmdKey = b
					break
				end
			end
			
			if type(d) == "table" then
				-- Check the user is correct type for the alias
				if d.ConsoleOnly and not Console then continue end
				if d.ChatOnly and Console then continue end
				
				-- Check the alias matches with/out the prefix
				if Console or string.StartWith(Alias, string.lower(d.Prefix)) then
					local ActAlias = (Console) and Alias or string.sub(Alias, string.len(d.Prefix) + 1)
					
					if type(d.Alias) == "table" then
						for e, f in ipairs(d.Alias) do
							if string.lower(f) == ActAlias then
								CmdKey = b
								Alias = ActAlias
								break
							end
						end
					elseif string.lower(d.Alias) == ActAlias then
						CmdKey = b
						Alias = ActAlias
						break
					end
				end
			end
		end
		if CmdKey then break end
	end
	
	-- If the command was found 
	if CmdKey then
		local Cmd = VH_CommandLib.Commands[CmdKey]
		
		local Outcome = Cmd:preCall(Sender, Alias, Args, teamChat)
		
		if Outcome and Outcome == "" then
			return nil, true
		else
			return Outcome, true
		end
	end
end

VH_HookLib.addHook("PlayerSay", VH_HookLib.HookPriority.Low, "VH-CommandLib-PlayerSay", VH_CommandLib.PlayerSay)

concommand.Add("vh", function(Player, Command, Args)
	if #Args == 0 then return end
	
	if SERVER then
		local ReturnValue = VH_CommandLib.PlayerSay(Player, Args, false, true)
		if ReturnValue then
			print(ReturnValue)
		end
	else
		net.Start("VH_ClientCCmd")
			net.WriteTable({Player = Player, Args = Args})
		net.SendToServer()
	end
end)

if SERVER then
	util.AddNetworkString("VH_ClientCCmd")
	
	net.Receive( "VH_ClientCCmd", function( Length )
		local Vars = net.ReadTable()
		ReturnValue = VH_CommandLib.PlayerSay(Vars.Player, Vars.Args, false, true)
		if ReturnValue then
			print(Outcome.ReturnValue)
		end
	end)
end