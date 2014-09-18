local Module = {}
Module.Name = "SettingsTab"
Module.Description = "Tab containing settings"

function RenderCall(Frame, Table)
end

local SettingsTab = _V.MenuLib.VTab:new("Settings", RenderCall, Color(70, 60, 70), "settings")

vh.RegisterModule(Module)