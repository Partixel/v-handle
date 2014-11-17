local DonatorRanks = {
	Diamond = 20,
	Gold = 15,
	Silver = 10,
	Bronze = 5,
	Copper = 1
}

Registry = debug.getregistry()

function Registry.Player:getDonatorRank()
	local Amount = self:getDonatorAmount()
	if Amount == 0 then return "None" end
	for a, b in pairs(DonatorRanks) do
		if Amount >= b then
			return a
		end
	end
end

function Registry.Player:getDonatorAmount()
	return self:getPlayerData("vh_donation_amount") or 0
end

function Registry.Player:setDonationAmount(Amount)
	self:setPlayerData("vh_donation_amount", Amount)
end

function Registry.Player:addDonationAmount(Amount)
	self:setPlayerData("vh_donation_amount", self:getDonatorAmount() + Amount)
end
