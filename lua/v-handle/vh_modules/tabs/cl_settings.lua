local Module = {}
Module.Name = "SettingsTab"
Module.Description = "Tab containing settings"

function RenderCall(Frame, Table)
end

local SettingsTab = _V.MenuLib.VTab:new("Settings", RenderCall)

vh.RegisterModule(Module)