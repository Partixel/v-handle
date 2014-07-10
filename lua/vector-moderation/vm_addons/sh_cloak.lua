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
  vm.ConsoleMessage("Ran cloak, todo.")
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

vm.RegisterAddon(addon)