
-- Handle dependancies --

vm.ConsoleMessage("Loading dependancies")

include(vm_util.lua)
vm.IncludeFolder("vm_util")

-- Handle variables --
vm.Version = version_util.Version( 0, 0, 1 )

-- Handle config defaults --
vm.ConfigDefaults = {}
vm.ConfigDefaults["AutoUpdate"] = false

-- Handle addons --
vm.Addons = {}
vm.IncludeFolder("vm_addons")

function vm.RegisterAddon( Addon )
	table.insert(vm.Addons, Addon)
	vm.ConsoleMessage("Loaded " .. Addon.Name .. " as an addon")
end

function vm.HandleCommands( Player, Message )
	local ValidCommands = {}
	local Args = {}
	for a in Message:sub(2):gmatch("%S+") do
	    table.insert(Args, a)
	end
	for a, b in pairs(vm.Addons) do
		if (!b["Commands"]) then continue end
		for c, d in pairs(b.Commands) do
			if (Message:sub(1, 1):lower() == d.Prefix:lower()) then
				if (Args[1]:lower == d.Name:lower()) then
					ValidCommands:insert(d)
				elseif (d["Aliases"]) then
					for e in d["Aliases"] do
						if (Args[1]:lower() == e:lower() then
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
	
	ValidCommands[1]:Run(Player, Message:sub(1 + Args[1]:len())
end
