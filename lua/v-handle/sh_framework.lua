
-- Handle dependancies --
if (SERVER) then
	AddCSLuaFile("v-handle/sh_util.lua")
end
include("v-handle/sh_util.lua")

vh.IncludeFolder("vh_core")

vh.ConsoleMessage("Loading core files")

-- Handle variables --
vh.Version = version_util.Version( 0, 0, 1 )

-- Handle Modules --
vh.ModuleHooks = {}
vh.Modules = {}
concommand.Add("vh", function(Player, Command, Args)
	local Outcome = vh.HandleCommands(Player, Args, {})
	if Outcome and Outcome != "" then
		local Msg = vh.ChatUtil.ParseColors(Outcome)
		MsgC(Msg[1], Msg[2], Msg[3], Msg[4], Msg[5], Msg[6], Msg[7], "\n")
	end
end)

function vh.RegisterModule( Module )
	if Module.Disabled then
		vh.ConsoleMessage("Module " .. Module.Name .. " is disabled")
		return
	end
	for a, b in pairs (vh.Modules) do
		if b.Name == Module.Name then
			table.remove(vh.Modules, a)
		end
	end
	vh.ConsoleMessage("Loading module " .. Module.Name)
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
	vh.ConsoleMessage("Loaded " .. Module.Name .. " as a Module")
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
		return "_RED_ Multiple commands found using that alias"
	elseif (#ValidCommands == 0) then
		return
	end

	local RankID = 0
	if Player:IsValid() then
		RankID = vh.RankTypeUtil.GetID(Player:VH_GetRank())
	end

	local Perm = vh.RankTypeUtil.HasPermission(RankID, ValidCommands[1].Permission)
	if Perm != nil and Perm.Value then
		table.remove(Args, 1)

		if #Args < ValidCommands[1].MinArgs then
			return "_RESET_ Incorrect usage - " .. ValidCommands[1].Usage
		end
		local Outcome = ValidCommands[1].Run(Player, Args, RankID, Perm)
		if Outcome[2] == 0 then
			return "_RED_ " .. Outcome[1]
		elseif Outcome[2] == 1 then
			return "_GREEN_ " .. Outcome[1]
		else
			return "_RESET_ " .. Outcome[1]
		end
	else
		return "_RED_ You do not have permission to use this"
	end
end

vh.IncludeFolder("vh_modules")
