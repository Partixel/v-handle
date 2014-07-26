vh.ConfigDefaults = {}
vh.ConfigDefaults["Test"] = false

vh.Config = vh.GetData("Config") or table.Copy(vh.ConfigDefaults)

function vh.CheckConfig()
    for a, b in pairs(vh.ConfigDefaults) do
        if vh.Config[a] == nil then
            vh.Config[a] = vh.ConfigDefaults[a]
        elseif type(vh.Config[a]) != type(vh.ConfigDefaults[a]) then
            vh.ConsoleMessage("Config value " .. a .. " with value " .. vh.Config[a] .. " is not the correct type, reverting to default")
            vh.Config[a] = vh.ConfigDefaults[a]
        end
    end
    vh.SetData("Config", vh.Config)
end

function vh.GetConfigValue( Key )
    return vh.Config[Key] or vh.ConsoleMessage("Attempted to find config value " .. key .. " but found none, please report this error to the developers")
end

vh.CheckConfig()