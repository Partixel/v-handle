local Module = {}
Module.Name = "AdvertsTab"
Module.Description = "Tab containing all Adverts"

function RenderCall(Frame, Table)
end

local AdvertsTab = _V.MenuLib.VTab:new("Adverts", RenderCall)

vh.RegisterModule(Module)