VH_FileLib = {}

VH_FileLib.Side = {
	Client = 0,
	Server = 1,
	Shared = 2
}

VH_FileLib.Loaded = {"vh-libs/vh-filelib.lua"}

function VH_FileLib.IncludeFile(Location, Side)
	local File = file.Find(Location, "LUA")
	if File then
		if table.HasValue(VH_FileLib.Loaded, Location) then
			return
		end
		
		if Side == VH_FileLib.Side.Client then
			if SERVER then
				AddCSLuaFile(Location)
			else
				table.insert(VH_FileLib.Loaded, Location)
				include(Location)
			end
		elseif Side == VH_FileLib.Side.Server then
			if SERVER then
				table.insert(VH_FileLib.Loaded, Location)
				include(Location)
			end
		elseif Side == VH_FileLib.Side.Shared then
			if SERVER then
				table.insert(VH_FileLib.Loaded, Location)
				AddCSLuaFile(Location)
				include(Location)
			else
				table.insert(VH_FileLib.Loaded, Location)
				include(Location)
			end
		else
			print("VH-LogLib - Invalid side for file " .. Location)
		end
	else
		print("VH-LogLib - File not found: " .. Location)
	end
end

function VH_FileLib.IncludeDir(Dir)
	local Files, Dirs = file.Find("v-handle/" .. Dir .. "/*", "LUA")

	for a, b in ipairs(Files) do
		if string.lower(string.Right(b, 4)) == ".lua" then
			if string.lower(string.Left(b, 3)) == "cl_" then
				VH_FileLib.IncludeFile(Dir .. "/" .. b, VH_FileLib.Side.Client)
			elseif string.lower(string.Left(b, 3)) == "sv_" then
				VH_FileLib.IncludeFile(Dir .. "/" .. b, VH_FileLib.Side.Server)
			else
				VH_FileLib.IncludeFile(Dir .. "/" .. b, VH_FileLib.Side.Shared)
			end
		end
	end

	for a, b in ipairs(Dirs) do
		VH_FileLib.IncludeDir(Dir .. "/" .. b)
	end
end

function VH_FileLib.AddResourceDir(Dir)
	local Files, Dirs = file.Find("v-handle/" .. Dir .. "/*", "LUA")

	for a, b in ipairs(Files) do
		resource.AddFile(Dir .. "/" .. b)
	end

	for a, b in ipairs(Dirs) do
		VH_FileLib.AddResourceDir(Dir .. "/" .. b)
	end
end