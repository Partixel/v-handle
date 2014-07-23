local addon = {}
addon.Name = "Cloak"
addon.Description = "Cloak or uncloak a player"
addon.Commands = {}
addon.Commands.Cloak = {
  Aliases = {"uncloak"},
  Prefix = "!",
  Description = addon.Description,
  Usage = "<Player>"
}

function addon.Commands.Cloak.Run(Player, Args)
	vh.ConsoleMessage("Ran cloak, todo.")
	local Players = vh.FindPlayers(Arg, Player)
	local Success = false
	local Toggle = false
	if (not Players or #Players == 0) then return "No players found." end
	
	for _, ply in ipairs(Players) do
		ply:SetNoDraw(true)
	end
	
	return "You cloaked "..vh:CreatePlayerList(Players)
end

function addon.Commands.Cloak.Vars(ArgNumber)
	local playerList = {}
	for _, v in pairs(player.GetAll()) do
		table.insert(playerList, v:Nick())
	end
	if (ArgNumber == 1) then
		return playerList
	end
	return
end

vh.RegisterAddon(addon)