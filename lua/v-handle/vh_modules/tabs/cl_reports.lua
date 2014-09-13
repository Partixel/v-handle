local Module = {}
Module.Name = "ReportsTab"
Module.Description = "Tab containing all Reports"

function RenderCall(Frame, Table)
end

local ReportsTab = _V.MenuLib.VTab:new("Reports", RenderCall, 1)

vh.RegisterModule(Module)