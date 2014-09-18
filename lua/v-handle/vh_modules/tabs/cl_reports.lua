local Module = {}
Module.Name = "ReportsTab"
Module.Description = "Tab containing all Reports"

function RenderCall(Frame, Table)
end

local ReportsTab = _V.MenuLib.VTab:new("Reports", RenderCall, Color(90, 150, 90), "reports")

vh.RegisterModule(Module)