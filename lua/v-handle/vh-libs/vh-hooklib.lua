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

function VH_HookLib.runHook(HookType, ...)

	if not VH_HookLib.Hooks[HookType] then return end
	
	local ReturnValue, Disabled = nil
	
	for a, b in pairs(VH_HookLib.HookPriority) do
		if VH_HookLib.Hooks[HookType][b] then
			for c, d in pairs(VH_HookLib.Hooks[HookType][b]) do
				local TValue, TDisabled = d(...)
				if TempReturnValue ~= nil then
					ReturnValue = TValue
				end
				if TDisabled ~= nil then
					Disabled = TDisabled
				end
				if Disabled then break end
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
	Disable = ""
	},
	{
	Key = "PlayerInitialSpawn",
	Disable = nil
	}
}

for a, b in ipairs(DefHooks) do
	hook.Add(b.Key, "HookLib_" .. b.Key, function(...)
		local ReturnValue, Disabled = VH_HookLib.runHook(b.Key, ...)
		if Disabled then
			return b.Disable
		else
			return ReturnValue
		end
	end)
end