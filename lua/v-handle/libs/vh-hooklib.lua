VH_HookLib = {}

-- Custom hook system --

VH_HookLib.HookPriority = { -- Lowest is first, Highest is last -- If you are planning on disabling the hook, use lowest
	Lowest = 1,
	Low = 2,
	Normal = 3,
	High = 4,
	Highest = 5
}

VH_HookLib.Hooks = {}

function VH_HookLib.runHook(HookType, CanDisable, ...)

	if not VH_HookLib.Hooks[HookType] then
		hook.Run(HookType, ...)
		return
	end
	
	local ReturnValue, Disabled = nil
	
	for a, b in pairs(VH_HookLib.HookPriority) do
		if VH_HookLib.Hooks[HookType][b] then
			if Disabled and CanDisable then break end
			for c, d in pairs(VH_HookLib.Hooks[HookType][b]) do
				local TValue, TDisabled = d(...)
				if TempReturnValue ~= nil then
					ReturnValue = TValue
				end
				if TDisabled ~= nil then
					Disabled = TDisabled
				end
				if Disabled and CanDisable then break end
			end
		end
	end
	
	return ReturnValue, Disabled
end

function VH_HookLib.removeHook(HookType, Priority, Key)
	if VH_HookLib.Hooks[HookType] and VH_HookLib.Hooks[HookType][Priority] and VH_HookLib.Hooks[HookType][Priority][Key] then
		VH_HookLib.Hooks[HookType][Priority][Key] = nil
	end
end
function VH_HookLib.addHook(HookType, Key, Callback)
	VH_HookLib.addHook(HookType, VH_HookLib.HookPriority.Normal, Key, Callback)
end

function VH_HookLib.addHook(HookType, Priority, Key, Callback)
	VH_HookLib.Hooks[HookType] = VH_HookLib.Hooks[HookType] or {}
	VH_HookLib.Hooks[HookType][Priority] = VH_HookLib.Hooks[HookType][Priority] or {}
	VH_HookLib.Hooks[HookType][Priority][Key] = Callback
end

-- Convert default hooks --

local DefHooks = {
	{
	Key = "PlayerSay",
	CanDisable = true,
	Disable = ""
	},
	{
	Key = "PlayerInitialSpawn"
	}
}

local HookAdd = hook.Add
function hook.Add(HookType, Key, Callback, HookLib)
	if VH_HookLib.Hooks[HookType] and not HookLib then
		debug.Trace()
		print("VH_HookLib.addHook(" .. HookType .. ", " .. Key .. ", CALLBACK)")
		VH_HookLib.addHook(HookType, Key, Callback)
	else
		HookAdd(HookType, Key, Callback)
	end
end

local HookTable = hook.GetTable()
for a, b in ipairs(DefHooks) do
	if HookTable[b.Key] then
		for c, d in pairs(HookTable[b.Key]) do
			VH_HookLib.addHook(b.Key, c, d)
			hook.Remove(b.Key, c)
		end
	end
	hook.Add(b.Key, "HookLib_" .. b.Key, function(...)
		local ReturnValue, Disabled = VH_HookLib.runHook(b.Key, b.CanDisable, ...)
		if Disabled then
			return b.Disable
		else
			return ReturnValue
		end
	end, true)
end