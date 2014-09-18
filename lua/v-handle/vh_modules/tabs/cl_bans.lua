local Module = {}
Module.Name = "BansTab"
Module.Description = "Tab containing all Bans"

function RenderCall(Frame, Table)
end

local BansTab = _V.MenuLib.VTab:new("Bans", RenderCall, Color(50, 10, 10), "bans")

vh.RegisterModule(Module)