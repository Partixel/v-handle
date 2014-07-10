local addon = {}
addon.Name = "Config"
addon.Description = "Adds a config file"

vm.Config = vm.GetData("Config") or {}

if vm.Config == {} then
    vm.ConsoleMessage("No config found, creating defaults")
end

vm.DefaultConfig()

function vm.ForceDefaultConfig()
    for a, b in pairs(vm.ConfigDefaults) do
        vm.Config[a] = vm.ConfigDefaults[a]
    end
end

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

vm.RegisterAddon(addon)
