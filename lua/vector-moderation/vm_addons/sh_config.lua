--[[
Default addon settings:

local addon = {}
addon.Name = "Default"
addon.Description = "Default addon"
addon.Commands = {}
addon.Commands.DefaultCommand = {
  Name = "DefaultCommand",
  Aliases = {"AnotherCommand"},
  Description = "Does default stuff"
  Usage = "<Player>"
}

function addon.Commands.DefaultCommand.Run(Player, Args)
  vm.ConsoleMessage("Ran default command")
end

function addon.Commands.DefaultCommand.Vars(ArgNumber)
  if (ArgNumber == 1) then
    return {"1", "2"}
  elseif (ArgNumber == 2) then
    return {"NotNow", "Okay"}
  end
  return
end

addon.ConCommands - {}
addon.ConCommands.DefaultConCommand = {}

function addon.ConCommands.DefaultConCommand.Run(Player, Args)
  vm.ConsoleMessage("Ran default con command")
end

vm.RegisterAddon(addon)

]]--

local addon = {}
addon.Name = "Config"
addon.Description = "Adds a config file"
addon.Commands = {}
addon.ConCommands = {}

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
