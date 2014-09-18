local Module = {}
Module.Name = "AdvertsTab"
Module.Description = "Tab containing all Adverts"

function RenderCall(Frame, Table)
end

local AdvertsTab = _V.MenuLib.VTab:new("Adverts", RenderCall, Color(70, 90, 160), "adverts")

vh.RegisterModule(Module)