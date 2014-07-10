
-- Handle dependancies --
include("vector-moderation/vm_util.lua")

vm.IncludeFolder("vm_util")

vm.ConsoleMessage("Loading dependancies")

-- Handle variables --
vm.Version = version_util.Version( 0, 0, 1 )

-- Handle config defaults --
vm.ConfigDefaults = {}
vm.ConfigDefaults["AutoUpdate"] = false

-- Handle addons --
vm.Addons = {}
concommand.Add("vm", function(Player, Command, Args)
	
	local ValidCommands = {}
	
	for a, b in pairs(vm.Addons) do
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

function vm.RegisterAddon( Addon )
	for a, b in pairs (vm.Addons) do
		if b.Name == Addon.Name then
			vm.ConsoleMessage("Already loaded " .. Addon.Name .. "!")
			return
		end
	end
	table.insert(vm.Addons, Addon)
	if (Addon["ConCommands"]) then
		for a, b in pairs(Addon.ConCommands) do
			concommand.Add(a, b.Run)
		end
	end
	vm.ConsoleMessage("Loaded " .. Addon.Name .. " as an addon")
end

function vm.HandleCommands( Player, Args )
	local ValidCommands = {}
	
	for a, b in pairs(vm.Addons) do
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

vm.IncludeFolder("vm_addons")
