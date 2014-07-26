
-- Handle dependancies --
include("v-handle/sh_util.lua")

vh.IncludeFolder("vh_core")

vh.ConsoleMessage("lcore")

-- Handle Modules --
vh.ModuleHooks = {}
vh.Modules = {}

function vh.RegisterModule( Module )
	if Module.Disabled then
		vh.ConsoleMessage("Module _red_ " .. Module.Name .. " _white_ is _red_ disabled")
		return
	end
	for a, b in pairs (vh.Modules) do
		if b.Name == Module.Name then
			table.remove(vh.Modules, a)
		end
	end
	table.insert(vh.Modules, Module)
	if Module["ConCommands"] then
		for a, b in pairs(Module.ConCommands) do
			concommand.Add(a, b.Run)
		end
	end
	if Module["Hooks"] then
		for a, b in pairs(Module.Hooks) do
			if vh.ModuleHooks[b.Type] then
				table.insert(vh.ModuleHooks[b.Type], b.Run)
			else
				vh.ModuleHooks[b.Type] = {b.Run}
				local Hook = b.Type
				hook.Add(Hook, "vh_" .. Hook, function(q, w, e, r, t)
					local Returns = {}
					for c, d in pairs(vh.ModuleHooks[Hook]) do
						local Return = d(q, w, e, r, t)
						if Return then
							table.insert(Returns, Return)
						end
					end
					return Returns[1]
				end)
			end
		end
	end
	if Module["PrecacheStrings"] then
		for a, b in pairs(Module.PrecacheStrings) do
			vh.ChatUtil.Precached[a] = vh.ChatUtil.ParseColors(b)
		end
	end
	vh.ConsoleMessage("Loaded _lime_ " .. Module.Name .. " _white_ as a Module")
end

vh.IncludeFolder("vh_modules")
