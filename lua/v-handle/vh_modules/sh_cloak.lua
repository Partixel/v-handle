local Module = {}
Module.Name = "Cloak"
Module.Description = "Cloak or uncloak a player"
Module.Commands = {}
Module.Commands.Cloak = {
	Aliases = {"uncloak", "tcloak"},
	Prefix = "!",
	Description = Module.Description,
	Usage = "<Player>",
	Permission = "Cloak",
	MinArgs = 0
}

function Module.Commands.Cloak.Run(Player, Args, Alias, RankID, Perm)
	local Players = vh.FindPlayers(Args, Player)
	local Success = false
	local Toggle = false
	if (not Players or #Players == 0) then
		vh.ChatUtil.SendMessage("nplr", Player)
		return
	end
	
	if (string.lower(Alias) == "cloak") then
		Success = true
		for _, ply in ipairs(Players) do
			ply:SetNoDraw(true)
		end
	end
	if (string.lower(Alias) == "uncloak") then
		Success = false
		for _, ply in ipairs(Players) do
			ply:SetNoDraw(false)
		end
	end
	if (string.lower(Alias) == "tcloak") then
		Toggle = true
		for _, ply in ipairs(Players) do
			ply:SetNoDraw(!ply:GetNoDraw())
		end
	end
	
	if Toggle then
		vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has toggled cloak on _reset_ " .. vh.CreatePlayerList(Players))
	else
		vh.ChatUtil.SendMessage("_lime_ " .. Nick .. " _white_ has " .. (!Success and "un" or "") .. "cloaked _reset_ " .. vh.CreatePlayerList(Players))
	end
	return
end

function Module.Commands.Cloak.Vars(ArgNumber)
	if (ArgNumber == 1) then
		local playerList = {}
		for _, v in pairs(player.GetAll()) do
			table.insert(playerList, v:Nick())
		end
		return playerList
	end
	return
end

vh.RegisterModule(Module)