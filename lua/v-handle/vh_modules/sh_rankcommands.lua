local Module = {}
Module.Name = "Rank Commands"
Module.Description = "Contains rank related commands"
Module.Commands = {}
Module.Commands.SetRank = {
  Aliases = {},
  Prefix = "!",
  Description = "Set a players rank",
  Usage = "<Player> <Rank>",
  Permission = "SetRank",
  MinArgs = 2
}

function Module.Commands.SetRank.Run(Player, Args, RankID, Perm)
	local Rank = vh.RankTypeUtil.GetID(table.concat(Args, " ", 2))
	if Rank then
	
		local Targets = vh.FindPlayers(Args[1])
		local Complete = {}
		local Invalid = {}
		
		for a, b in pairs(Targets) do
			local TargetID = b:VH_GetRank()
			if vh.RankTypeUtil.CanTarget(Perm, RankID, TargetID) then
				b:VH_SetRank(Rank)
				table.insert(Complete, b)
			else
				table.insert(Invalid, b)
			end
		end
		
		if #Complete != 0 then
			local Nick = "Console"
			if Player:IsValid() then
				Nick = Player:Nick()
			end
			vh.ChatUtil.SendMessage(Nick .. " has set the rank of " .. vh.CreatePlayerList(Complete) .. " to " .. vh.RankTypeUtil.FromID(Rank).Name)
			return {"You set the rank of " .. vh.CreatePlayerList(Complete) .. " to " .. vh.RankTypeUtil.FromID(Rank).Name, 1}
		end
		
		if #Invalid != 0 then
			return {"You cannot set the rank of " .. vh.CreatePlayerList(Invalid) .. " to " .. vh.RankTypeUtil.FromID(Rank).Name, 0}
		end
		
		return {"No valid players found", 0}
	else
		return {"That is not a valid rank", 0}
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