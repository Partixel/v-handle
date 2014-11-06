local Ranks = {
	"20" = "Diamond",
	"15" = "Gold",
	"10" = "Silver",
	"5" = "Bronze",
	"1" = "Copper"
}

Registry = debug.getregistry()

function Registry.Player:getDonatorRank()
	local Amount = self:getDonatorAmount()
	if Amount == nil then return "None" end
	for i, v in pairs(Table) do
		if i <= Amount then
			return v
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
