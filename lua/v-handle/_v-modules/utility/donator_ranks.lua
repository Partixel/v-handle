local Ranks = {
	"1" = "Copper",
	"5" = "Bronze",
	"10" = "Silver",
	"15" = "Gold",
	"20" = "Diamond"
}

Registry = debug.getregistry()

function Registry.Player:getDonatorRank()
	local Table = table.Reverse(Ranks)
	local Amount = self:getDonatorAmount()
	for i, v in pairs(Table) do
		if i <= Amount then
			return v
		end
	end
end

function Registry.Player:getDonatorAmount()
	return self:getPlayerData("vh_donation_amount")
end

function Registry.Player:setDonationAmount(Amount)
	self:setPlayerData("vh_donation_amount", Amount)
end

function Registry.Player:addDonationAmount(Amount)
	self:setPlayerData("vh_donation_amount", self:getPlayerData("vh_donation_amount") + Amount)
end

function PlayerInitialSpawn(Player)
	if Player:getDonatorAmount() == nil then
		Player:setDonationAmount(0)
	end
end

_V.HookLib.addHook("PlayerInitialSpawn", _V.HookLib.HookPriority.Normal, "VH-DonatorRanks-InitialSpawn", PlayerInitialSpawn)