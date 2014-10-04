local Command = _V.CommandLib.Command:new("Freeze", _V.CommandLib.UserTypes.Admin, "Freeze or thaw the player(s).", "")
Command:addArg(_V.CommandLib.ArgTypes.Players, {required = false})
Command:addAlias("!freeze", "!unfreeze", "!thaw", "!tfreeze")

local Registry = debug.getregistry()

local PlrLock = Player.Lock
local PlrUnLock = Player.UnLock

function Registry.Player:Lock(State)
	if State then
		PlrLock(self)
		self.isLocked = true
	else
		PlrUnLock(self)
		self.isLocked = false
	end
end

Command.Callback = function(Sender, Alias, Targets)
	local Targets = Targets or {Sender}
	local Success, Toggle = _V.CommandLib.DoToggleableCommand(Alias, {"!freeze"}, {"!unfreeze", "!thaw"}, {"!tfreeze"})
	
	for _, ply in ipairs(Targets) do
		if Toggle then
			ply:Lock(!ply.isLocked)
		else
			ply:Lock(Success)
		end
	end
	
	return ""
end