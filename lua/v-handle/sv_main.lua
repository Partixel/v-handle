
vh.Data = vh.Data or {}

AddCSLuaFile("v-handle/sh_util.lua")

util.AddNetworkString("VH_ClientCCmd")

function vh.HandleCommands( Player, Args, Commands )
	local ValidCommands = {}
	
	if #Commands == 0 then
		for a, b in pairs(vh.Modules) do
			if (!b["Commands"]) then continue end
			for c, d in pairs(b.Commands) do
				Commands[c] = d
			end
		end
	end
	
	for a, b in pairs(Commands) do
		if (Args[1]:lower() == a:lower()) then
			table.insert(ValidCommands, b)
		elseif (b["Aliases"]) then
			for c, d in pairs(b["Aliases"]) do
				if (Args[1]:lower() == d:lower()) then
					table.insert(ValidCommands, b)
				end
			end
		end
	end
	
	if (#ValidCommands > 1) then
		for a, b in pairs(ValidCommands) do
			if string.lower(Args[1]) == string.lower(a) then
				ValidCommands = {a = b}
				break
			end
		end
		if (#ValidCommands > 1) then
			return "malias"
		end
	elseif (#ValidCommands == 0) then
		return
	end

	local RankID = -1
	if Player:IsValid() then
		RankID = Player:VH_GetRankObject().UID
	end

	local Perm = vh.RankTypeUtil.HasPermission(RankID, ValidCommands[1].Permission)
	if Perm != nil and Perm.Value then
		local Alias = Args[1]
		table.remove(Args, 1)

		if #Args < ValidCommands[1].MinArgs then
			return "_reset_ Incorrect usage - " .. ValidCommands[1].Usage
		end
		ValidCommands[1].Run(Player, Args, Alias, RankID, Perm)
		return ""
	else
		return "nperm"
	end
end

function vh.SetData(Key, Value)
	vh.Data[Key] = Value
	
	file.CreateDir("v-handle")
	fiel.Write("v-handle/" .. Key .. ".txt", util.Compress(von.serialize(vh.Data)))
end

function vh.GetData(Key, Default)
	if (vh.Data[Key]) then
		return vh.Data[Key]
	else
		local ReadData = file.Read("v-handle/" .. Key .. ".txt", "DATA")
		
		if ReadData and ReadData != "" then
			local DesData = von.deserialize(util.Decompress(ReadData))
			
			vh.Data[Key] = DesData[Key]
			return vh.Data[Key]
		end
	end

	return Default
end

concommand.Add("vh", function(Player, Command, Args)
	if #Args == 0 then return end
	local Outcome = vh.HandleCommands(Player, Args, {})
	if Outcome and Outcome != "" then
		vh.ConsoleMessage(Outcome, true)
	end
end)

hook.Add("PlayerSay", "vh_HandleCommands", function(Player, Message, TeamChat)
	if (TeamChat) then return end
	local Args = string.Explode(" ", Message)
	local Commands = {}
	for a, b in pairs(vh.Modules) do
		if (!b["Commands"]) then continue end
		for c, d in pairs(b.Commands) do
			if (b.Prefix == "") then continue end
			if (Args[1]:sub(1, 1):lower() == d.Prefix:lower()) then
				Commands[c] = d
			end
		end
	end
	Args[1] = string.sub(Args[1], 2)
	local Outcome = vh.HandleCommands(Player, Args, Commands)
	if Outcome then
		if Outcome != "" then
			vh.ChatUtil.SendMessage(Outcome, Player)
		end
		return ""
	end
end)

net.Receive( "VH_ClientCCmd", function( Length )
	local Vars = von.deserialize(net.ReadString())
	local Outcome = vh.HandleCommands(Vars.Player, Vars.Args, {})
	if Outcome and Outcome != "" then
		vh.ChatUtil.SendMessage(Outcome, Vars.Player)
	end
end)
