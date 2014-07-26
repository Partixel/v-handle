
AddCSLuaFile("v-handle/sh_util.lua")

hook.Add("PlayerSay", "vh_HandleCommands", function(Player, Message, TeamChat)
	if (TeamChat) then return end
	local Args = string.Explode(" ", Message)
	local Commands = {}
	for a, b in pairs(vh.Modules) do
		if (!b["Commands"]) then continue end
		for c, d in pairs(b.Commands) do
			if (b.Prefix == "") then continue end
			if (Args[1]:sub(1, 1):lower() == d.Prefix:lower()) then
				Commands[c] = d
			end
		end
	end
	Args[1] = string.sub(Args[1], 2)
	local Outcome = vh.HandleCommands(Player, Args, Commands)
	if Outcome then
		if Outcome != "" then
			vh.ChatUtil.SendMessage(Outcome, Player)
		end
		return ""
	end
end)

util.AddNetworkString("VH_ClientCCmd")

net.Receive( "VH_ClientCCmd", function( Length )
	local Vars = von.deserialize(net.ReadString())
	local Outcome = vh.HandleCommands(Vars.Player, Vars.Args, {})
	if Outcome and Outcome != "" then
		vh.ChatUtil.SendMessage(Outcome, Vars.Player)
	end
end)

usermessage.Hook("vh_clientccmd", function(Message)
	local Vars = von.deserialise(Message:ReadString())

	local Outcome = vh.HandleCommands(Vars.Player, Vars.Args, {})
	if Outcome and Outcome != "" then
		vh.ChatUtil.SendMessage(Outcome, Vars.Player)
	end
end)
