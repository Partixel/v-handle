local Module = {}
Module.Name = "Chat Blacklist"
Module.Description = "Allows for a list of blacklists and filters them out of chat"

Blacklist = _V.ConfigLib.ConfigValue:new("ChatBlacklist", "SpamFilter", {"PutBlacklistWordsHere", "LikeTheseWords"}, "Add words you want blacklisted into the table, requires a comma at end")

local BlacklistTable = Blacklist:Get()
for _, v in pairs(BlacklistTable) do
	print(v)
end
function PlayerSay(Player, Message, TeamChat)
	local BlacklistTable = Blacklist:Get()
end

Module.Hooks = {
	{Type = "PlayerSay", Run = PlayerSay}
}

vh.RegisterModule(Module)