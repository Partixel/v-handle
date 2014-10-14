local Command = _V.CommandLib.Command:new("Clean", _V.CommandLib.UserTypes.Admin, "Commands for cleaning props, decals and freeze props.", "")
Command:addAlias({Prefix = "!", Alias = {"cleanup", "cleandecals", "cleanragdolls", "freezeprops"}})

if SERVER then
	util.AddNetworkString("vh-clearragdolls")
else
	net.Receive("vh-clearragdolls", function(Plr, Length)
		game.RemoveRagdolls()
	end)
end

Command.Callback = function(Sender, Alias, Targets)
	if Alias == "cleanup" then
		game.CleanUpMap()
		_V.CommandLib.SendCommandMessage(Sender, "cleaned up the map", {}, "")
	elseif Alias == "cleandecals" then
		for _, Player in ipairs(player.GetAll()) do
			Player:ConCommand("r_cleardecals")
		end
		_V.CommandLib.SendCommandMessage(Sender, "cleaned up all decals", {}, "")
	elseif Alias == "cleanragdolls" then
		net.Start("vh-clearragdolls")
		net.Broadcast()
		_V.CommandLib.SendCommandMessage(Sender, "cleaned up all ragdolls", {}, "")
	elseif Alias == "freezeprops" then
		for _, Prop in pairs(ents.FindByClass("prop_physics")) do
			if Prop:IsValid() and Prop:IsInWorld() then
				Prop:GetPhysicsObject():EnableMotion(false)
			end
		end
		_V.CommandLib.SendCommandMessage(Sender, "froze all props", {}, "")
	end
	
	return ""
end