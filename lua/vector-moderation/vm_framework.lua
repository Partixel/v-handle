
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
