
-- Handle dependancies --
if (SERVER) then
	AddCSLuaFile("v-handle/sh_util.lua")
end
include("v-handle/sh_util.lua")

vh.IncludeFolder("vh_util")

vh.ConsoleMessage("Loading dependancies")

-- Handle variables --
vh.Version = version_util.Version( 0, 0, 1 )

-- Handle config defaults --
vh.ConfigDefaults = {}
vh.ConfigDefaults["AutoUpdate"] = false

-- Handle addons --
vh.Addons = {}
concommand.Add("vh", function(Player, Command, Args)
	
	local ValidCommands = {}
	
	for a, b in pairs(vh.Addons) do
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

function vh.RegisterAddon( Addon )
	for a, b in pairs (vh.Addons) do
		if b.Name == Addon.Name then
			vh.ConsoleMessage("Already loaded " .. Addon.Name .. "!")
			return
		end
	end
	table.insert(vh.Addons, Addon)
	if (Addon["ConCommands"]) then
		for a, b in pairs(Addon.ConCommands) do
			concommand.Add(a, b.Run)
		end
	end
	vh.ConsoleMessage("Loaded " .. Addon.Name .. " as an addon")
end

function vh.HandleCommands( Player, Args )
	local ValidCommands = {}
	
	for a, b in pairs(vh.Addons) do
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

vh.IncludeFolder("vh_addons")
