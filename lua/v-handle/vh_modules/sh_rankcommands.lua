local Module = {}
Module.Name = "Rank Commands"
Module.Description = "Contains rank related commands"
Module.Commands = {}
Module.Commands.SetRank = {
  Aliases = {},
  Prefix = "!",
  Description = "Set a players rank",
  Usage = "<Player> <Rank>"
}

function Module.Commands.SetRank.Run(Player, Args)
	if #Args < 2 then
		return {"Incorrect usage - " .. Module.Commands.SetRank.Usage, 2}
	end
	local RankID = 0
	if Player:IsValid() then
		RankID = vh.RankTypeUtil.GetID(Player:VH_GetRank())
	end
	local Perm = vh.RankTypeUtil.HasPermission(RankID, "SetRank")
	if Perm != nil and Perm.Value then
		local Rank = vh.RankTypeUtil.GetID(table.concat(Args, " ", 2))
		if Rank then
			local Targets = vh.FindPlayers(Args[1])
			local Complete = {}
			for a, b in pairs(Targets) do
				local TargetID = b:VH_GetRank()
				if vh.RankTypeUtil.CanTarget(Perm, RankID, TargetID) then
					b:VH_SetRank(Rank)
					table.insert(Complete, b)
				end
			end
			if #Complete != 0 then
				return {"You set the rank of " .. vh.CreatePlayerList(Complete) .. " to " .. vh.RankTypeUtil.FromID(Rank).Name, 1}
			else
				return {"No valid players found", 0}
			end
		else
			return {"That is not a valid rank", 0}
		end
	else
		return {"You do not have sufficient permisions", 0}
	end
end

function Module.Commands.SetRank.Vars(ArgNumber)
	if (ArgNumber == 1) then
		local Players = {}
		for a, b in pairs(player.GetAll()) do
			table.insert(Players, b:Nick())
		end
		return Players
	elseif (ArgNumber == 2) then
		local Types = {}
		for a, b in pairs(vh.RankTypes) do
			table.insert(Types, b.Name)
		end
		return Types
	end
	return nil
end

vh.RegisterModule(Module)