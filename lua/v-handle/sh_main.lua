-- Handle dependancies --
function vh.IncludeFile(Name, Side)
	if Side == nil then
		if SERVER then
			AddCSLuaFile(Name)
		end
		include(Name)
	elseif string.lower(Side) == "sv" and SERVER then
		include(Name)
	else
		if SERVER then
			AddCSLuaFile(Name)
		else
			include(Name)
		end
	end
end

function vh.IncludeFolder(Name, Side)

	local Files, Dirs = file.Find("v-handle/" .. Name .. "/*", "LUA")

	for a, b in ipairs(Files) do
		if string.Right(b, 4) == ".lua" then
			vh.IncludeFile(Name .. "/" .. b, Side)
		end
	end

	for a, b in ipairs(Dirs) do
		if string.lower(b) == "server" then
			vh.IncludeFolder(Name .. "/" .. b, "sv")
		elseif string.lower(b) == "client" then
			vh.IncludeFolder(Name .. "/" .. b, "cl")
		end
	end
end

-- Loading external files --
vh.IncludeFolder("external")

-- Loading core files --
vh.IncludeFolder("vh_core")

vh.IncludeFile("libs/V-LogLib/main.lua")

_V.LogLib.Log("Hia", _V.LogLib.Type.SEVERE)
_V.LogLib.Log("Hia", _V.LogLib.Type.WARNING)
_V.LogLib.Log("Hia", _V.LogLib.Type.INFO)
_V.LogLib.Log("Hia", _V.LogLib.Type.DEBUG)
_V.LogLib.Log("Hia", _V.LogLib.Type.CONFIG)
vh.ConsoleMessage("_lcore_")

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
			vh.ChatUtil.Precached[a] = vh.ChatUtil.ParseColors(string.Explode(" ", b))
		end
	end
	vh.ConsoleMessage("Loaded _lime_ " .. Module.Name .. " _white_ as a Module")
end

vh.IncludeFolder("vh_modules")
