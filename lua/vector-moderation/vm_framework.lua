
-- Handle dependancies --

vm.ConsoleMessage("Loading dependancies")

include(vm_util.lua)
vm.IncludeFolder( "vm_util" )

-- Handle variables --
vm.Version = version_util.Version( 0, 0, 1 )

-- Handle config defaults --
vm.ConfigDefaults = {}
vm.ConfigDefaults["AutoUpdate"] = false

-- Handle config --
vm.ConsoleMessage("Loading config")
vm.Config = vm.GetData("Config") or {}

if vm.Config == {} then
    vm.ConsoleMessage("No config found, creating defaults")
end

vm.DefaultConfig()

function vm.DefaultConfig()
    for a, b in pairs(vm.ConfigDefaults) do
        if vm.Config[a] == nil then
            vm.Config[a] = vm.ConfigDefaults[a]
        elseif type(vm.Config[a]) != type(vm.ConfigDefaults[a]) then
            vm.ConsoleMessage("Config value " .. a .. " with value " .. vm.Config[a] .. " is not the correct type, reverting to default")
            vm.Config[a] = vm.ConfigDefaults[a]
        end
    end
end

function vm:GetConfig( Key )
    return vm.Config[Key] or vm.ConsoleMessage("Attempted to find config value " .. key .. " but found none, please report this error to the developers")
end
