_V = _V or {}

_V.HookLib = {}

-- Custom hook system --

_V.HookLib.HookPriority = { -- Lowest is first, Highest is last -- If you are planning on disabling the hook, use lowest
	Lowest = 1,
	Low = 2,
	Normal = 3,
	High = 4,
	Highest = 5
}

_V.HookLib.HookInfo = {
	Disabled = false,
	ReturnValue = nil
}

_V.HookLib.Hooks = {}

function _V.HookLib.runHook(HookType, ...)

	if not _V.HookLib.Hooks[HookType] then return end
	
	local HookInfo = table.Copy(_V.HookLib.HookInfo)
	
	for a, b in pairs(_V.HookLib.HookPriority) do
		if _V.HookLib.Hooks[HookType][b] then
			for c, d in pairs(_V.HookLib.Hooks[HookType][b]) do
				d(HookInfo, ...)
				if HookInfo.Disabled then break end
			end
		end
		if HookInfo.Disabled then break end
	end
	
	return HookInfo.ReturnValue, HookInfo.Disabled
end

function _V.HookLib.removeHook(HookType, Priority, Key)
	if _V.HookLib.Hooks[HookType] and _V.HookLib.Hooks[HookType][Priority] and _V.HookLib.Hooks[HookType][Priority][Key] then
		_V.HookLib.Hooks[HookType][Priority][Key] = nil
	end
end

function _V.HookLib.addHook(HookType, Priority, Key, Callback)
	_V.HookLib.Hooks[HookType] = _V.HookLib.Hooks[HookType] or {}
	_V.HookLib.Hooks[HookType][Priority] = _V.HookLib.Hooks[HookType][Priority] or {}
	_V.HookLib.Hooks[HookType][Priority][Key] = Callback
end

-- Convert default hooks --

local Registry = debug.getregistry()

hook.Add("PlayerSay", "HookLib_PlayerSay", function(...)
	local ReturnValue, Disabled = _V.HookLib.runHook("PlayerSay", ...)
	if Disabled then
		return ""
	else
		return ReturnValue
	end
end)