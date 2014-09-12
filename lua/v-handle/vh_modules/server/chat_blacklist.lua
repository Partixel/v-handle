local Module = {}
Module.Name = "Chat Blacklist"
Module.Description = "Allows for a list of blacklists and filters them out of chat"

Blacklist = _V.ConfigLib.ConfigValue:new("ChatBlacklist", "SpamFilter", {"Test"})

function PlayerSay(Player, Message, TeamChat)
	local BlacklistTable = Blacklist:Get()
end

Module.Hooks = {
	{Type = "PlayerSay", Run = PlayerSay}
}

vh.RegisterModule(Module)
