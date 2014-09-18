local Module = {}
Module.Name = "LogsTab"
Module.Description = "Tab containing all Logs"

function RenderCall(Frame, Table)
end

local LogsTab = _V.MenuLib.VTab:new("Logs", RenderCall, Color(140, 140, 140), "logs")

vh.RegisterModule(Module)