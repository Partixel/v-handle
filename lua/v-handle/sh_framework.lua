
-- Handle dependancies --
if (SERVER) then
	AddCSLuaFile("v-handle/sh_util.lua")
end
include("v-handle/sh_util.lua")

vh.IncludeFolder("vh_core")

vh.ConsoleMessage("lcore")

-- Handle Modules --
vh.ModuleHooks = {}
vh.Modules = {}
concommand.Add("vh", function(Player, Command, Args)
	if CLIENT then
		net.Start("VH_ClientCCmd")
			net.WriteString(von.serialize({Player = Player, Args = Args}))
		net.SendToServer()
	else
		local Outcome = vh.HandleCommands(Player, Args, {})
		if Outcome and Outcome != "" then
			local Msg = vh.ChatUtil.ParseColors(Outcome)
			MsgC(Msg[1], Msg[2], Msg[3], Msg[4], Msg[5], Msg[6], Msg[7], Msg[8], Msg[9], Msg[10], Msg[11], Msg[12], Msg[13], Msg[14], Msg[15], Msg[16], Msg[17], Msg[18], Msg[19], Msg[20], "\n")
		end
	end
end)

if SERVER then
	usermessage.Hook("vh_clientccmd", function(Message)
		local Vars = von.deserialise(Message:ReadString())

		local Outcome = vh.HandleCommands(Vars.Player, Vars.Args, {})
		if Outcome and Outcome != "" then
			vh.ChatUtil.SendMessage(Outcome, Vars.Player)
		end
	end)
end

function vh.RegisterModule( Module )
	if Module.Disabled then
		vh.ConsoleMessage("Module _red_ " .. Module.Name .. " _white_ is _red_ disabled")
		return
	end
	for a, b in pairs (vh.Modules) do
		if b.Name == Module.Name then
			table.remove(vh.Modules, a)
		end
	end
	table.insert(vh.Modules, Module)
	if Module["ConCommands"] then
		for a, b in pairs(Module.ConCommands) do
			concommand.Add(a, b.Run)
		end
	end
	if Module["Hooks"] then
		for a, b in pairs(Module.Hooks) do
			if vh.ModuleHooks[b.Type] then
				table.insert(vh.ModuleHooks[b.Type], b.Run)
			else
				vh.ModuleHooks[b.Type] = {b.Run}
				local Hook = b.Type
				hook.Add(Hook, "vh_" .. Hook, function(q, w, e, r, t)
					local Returns = {}
					for c, d in pairs(vh.ModuleHooks[Hook]) do
						local Return = d(q, w, e, r, t)
						if Return then
							table.insert(Returns, Return)
						end
					end
					return Returns[1]
				end)
			end
		end
	end
	if Module["PrecacheStrings"] then
		for a, b in pairs(Module.PrecacheStrings) do
			vh.ChatUtil.Precached[a] = vh.ChatUtil.ParseColors(b)
		end
	end
	vh.ConsoleMessage("Loaded _lime_ " .. Module.Name .. " _white_ as a Module")
end

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

	local RankID = 0
	if Player:IsValid() then
		RankID = vh.RankTypeUtil.GetID(Player:VH_GetRank())
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

vh.IncludeFolder("vh_modules")
