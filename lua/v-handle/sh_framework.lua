
-- Handle dependancies --
if (SERVER) then
	AddCSLuaFile("v-handle/sh_util.lua")
end
include("v-handle/sh_util.lua")

vh.IncludeFolder("vh_lib")

vh.ConsoleMessage("Loading libs")

-- Handle variables --
vh.Version = version_util.Version( 0, 0, 1 )

-- Handle Modules --
vh.ModuleHooks = {}
vh.Modules = {}
concommand.Add("vh", function(Player, Command, Args)
	
	local ValidCommands = {}
	
	for a, b in pairs(vh.Modules) do
		if (!b["Commands"]) then continue end
		for c, d in pairs(b.Commands) do
			if (Args[1]:lower() == c:lower()) then
				table.insert(ValidCommands, d)
			elseif (d["Aliases"]) then
				for _, e in pairs(d["Aliases"]) do
					if (Args[1]:lower() == e:lower()) then
						table.insert(ValidCommands, d)
					end
				end
			end
		end
	end
	
	if (ValidCommands == {}) then
		return
	elseif (#ValidCommands > 1) then
		Player:PrintMessage( HUD_PRINTTALK, "Multiple commands found using that alias" )
		return ""
	end
	if (not ValidCommands[1]) then return end
	table.remove(Args, 1)
	ValidCommands[1].Run(Player, Args)
end)

function vh.RegisterModule( Module )
	for a, b in pairs (vh.Modules) do
		if b.Name == Module.Name then
			vh.ConsoleMessage("Already loaded " .. Module.Name .. "!")
			return
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
				hook.Add(Hook, "vh_" .. Hook, function(...)
					for c, d in pairs(vh.ModuleHooks[Hook]) do
						d(arg)
					end
				end)
			end
		end
	end
	vh.ConsoleMessage("Loaded " .. Module.Name .. " as an Module")
end

function vh.HandleCommands( Player, Args )
	local ValidCommands = {}
	
	for a, b in pairs(vh.Modules) do
		if (!b["Commands"]) then continue end
		for c, d in pairs(b.Commands) do
			if (b.Prefix == "") then continue end
			if (Args[1]:sub(1, 1):lower() == d.Prefix:lower()) then
				if (Args[1]:sub(2):lower() == c:lower()) then
					table.insert(ValidCommands, d)
				elseif (d["Aliases"]) then
					for _, e in pairs(d["Aliases"]) do
						if (Args[1]:sub(2):lower() == e:lower()) then
							table.insert(ValidCommands, d)
						end
					end
				end
			end
		end
	end
	
	if (ValidCommands == {}) then
		return
	elseif (#ValidCommands > 1) then
		Player:PrintMessage( HUD_PRINTTALK, "Multiple commands found using that alias" )
		return ""
	end
	if (not ValidCommands[1]) then return end
	table.remove(Args, 1)
	ValidCommands[1].Run(Player, Args)
	return ""
end

vh.IncludeFolder("vh_modules")
