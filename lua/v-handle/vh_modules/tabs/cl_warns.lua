local Module = {}
Module.Name = "WarnsTab"
Module.Description = "Tab containing all Warns"

function RenderCall(Frame, Table)
end

local WarnsTab = _V.MenuLib.VTab:new("Warns", RenderCall, 1)

vh.RegisterModule(Module)