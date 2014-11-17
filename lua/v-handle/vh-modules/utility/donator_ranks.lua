local DonatorRanks = {
	{Name = "Diamond", Amount = 20},
	{Name = "Gold", Amount = 15},
	{Name = "Silver", Amount = 10},
	{Name = "Bronze", Amount = 5},
	{Name = "Copper", Amount = 1},
}

Registry = debug.getregistry()

function Registry.Player:getDonatorRank()
	local Amount = self:getDonatorAmount()
	if Amount == 0 then return "None" end
	for a, b in pairs(DonatorRanks) do
		if Amount >= b.Amount then
			return b.Name
		end
	end
end

function Registry.Player:getDonatorAmount()
	return self:getPlayerData("DonationAmount") or 0
end

function Registry.Player:setDonationAmount(Amount)
	self:setPlayerData("DonationAmount", Amount)
end

function Registry.Player:addDonationAmount(Amount)
	self:setPlayerData("DonationAmount", self:getDonatorAmount() + Amount)
end
