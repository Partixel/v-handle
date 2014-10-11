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
	ReturnValue = nil,
	Args = {}
}

_V.HookLib.Hooks = {}

function _V.HookLib.runHook(HookType, Args)

	if not _V.HookLib.Hooks[HookType] then return end
	
	local HookInfo = table.Copy(_V.HookLib.HookInfo)
	HookInfo.Args = Args
	
	for a, b in pairs(_V.HookLib.HookPriority) do
		for c, d in pairs(_V.HookLib.Hooks[HookType][b]) do
			d(HookInfo)
			if HookInfo.Disabled then break break end
		end
	end
	
	return HookInfo.ReturnValue
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

local Registry = debug.getregistry()

