local addon = {}
addon.Name = "Config"
addon.Description = "Adds a config file"

vh.Config = vh.GetData("Config") or {}

if vh.Config == {} then
    vh.ConsoleMessage("No config found, creating defaults")
end

function vh.ForceDefaultConfig()
    for a, b in pairs(vh.ConfigDefaults) do
        vh.Config[a] = vh.ConfigDefaults[a]
    end
end

function vh.DefaultConfig()
    for a, b in pairs(vh.ConfigDefaults) do
        if vh.Config[a] == nil then
            vh.Config[a] = vh.ConfigDefaults[a]
        elseif type(vh.Config[a]) != type(vh.ConfigDefaults[a]) then
            vh.ConsoleMessage("Config value " .. a .. " with value " .. vh.Config[a] .. " is not the correct type, reverting to default")
            vh.Config[a] = vh.ConfigDefaults[a]
        end
    end
end

function vh:GetConfig( Key )
    return vh.Config[Key] or vh.ConsoleMessage("Attempted to find config value " .. key .. " but found none, please report this error to the developers")
end

vh.DefaultConfig()

vh.RegisterAddon(addon)