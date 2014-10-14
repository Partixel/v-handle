local CapitalLetters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

local AdvancedFilters = {{"a", "@", "2"}, {"3", "#"}, {"s", "$", "4"}, {"5", "%"}, {"6", "^"}, {"7", "&"}, {"8", "*"}, {"9", "("}, {"0", ")"}, {"i", "1", "!", "|"}, {"o", "0"}, {"ate", "8"}, {"e", "3"}, {"l", "|"}}

local function WordDifferences(WordA, WordB)
	local Differences = 0
	local ShortestWord = (#WordA < #WordB) and WordA or WordB
	local LongestWord = (#WordA < #WordB) and WordB or WordA
	if #ShortestWord ~= #LongestWord then
		Differences = Differences + #LongestWord - #ShortestWord
	end
	local LongTable = string.ToTable(LongestWord)
	for i, v in pairs(string.ToTable(ShortestWord)) do
		if v ~= LongTable[i] then
			Differences = Differences + 1
		end
	end
	return Differences
end

local function WordSimilar(WordA, WordB)
	local WordA = string.lower(WordA)
	local WordB = string.lower(WordB)
	if WordA == WordB then
		return true
	end
	if _V.Config.SpamFilter.AdvancedFiltering then
		if string.len(WordA) == string.len(WordB) then
			local NewWordA = WordA
			local NewWordB = WordB
			for _, v in ipairs(AdvancedFilters) do
				for i, x in ipairs(v) do
					if i == 1 then continue end
					NewWordA = string.Replace(NewWordA, v[i], v[1])
					NewWordB = string.Replace(NewWordB, v[i], v[1])
				end
			end
			if NewWordA == NewWordB then
				return true
			end
		end
	end
	if _V.Config.SpamFilter.ExtremeFiltering then
		local Differences = WordDifferences(WordA, WordB)
		if Differences <= #WordA/4 then
			return true
		end
	end
	return false
end

function PlayerTalk(Player, Message, TeamChat)
	if string.StartWith(Message, "!") then return end
	local Return = Message
	local BlacklistTable = _V.Config.SpamFilter.Blacklist
	local Explode = string.Explode(" ", Return)
	local TotalCensored = 0
	for i, word in pairs(Explode) do
		if string.len(word) > _V.Config.SpamFilter.MaxWordLength then
			Return = string.Replace(Return, word, string.sub(word, 1, _V.Config.SpamFilter.MaxWordLength - 2).."..")
		else
			local Caps = 0
			local Repeats = 0
			local LastLetter = ""
			local NewWord = ""
			for _, v in pairs(string.ToTable(word)) do
				if table.HasValue(CapitalLetters, v) then
					Caps = Caps + 1
				end
				if v == LastLetter then
					Repeats = Repeats + 1
					if Repeats < _V.Config.SpamFilter.LetterDragging then
						NewWord = NewWord..v
					end
				else
					LastLetter = v
					Repeats = 0
					NewWord = NewWord..v
				end
			end
			Return = string.Replace(Return, word, NewWord)
			
			local Percent = math.Round((Caps / string.len(word)) * 100)
			if Percent >= _V.Config.SpamFilter.CapsPercentage and string.len(word) > 2 then
				Return = string.Replace(Return, word, string.lower(word))
			end
			for _, v in pairs(BlacklistTable) do
				if WordSimilar(word, v) then
					Return = string.Replace(Return, word, "****")
					TotalCensored = TotalCensored + string.len(word)
				end
			end
		end
	end
	local Percent = math.Round((TotalCensored / string.len(Message)) * 100);
	if Percent >= _V.Config.SpamFilter.CensorPercentage then
		return ""
	end
	return Return
end

_V.HookLib.addHook("PlayerSay", _V.HookLib.HookPriority.Normal, "VH-SpamFilter", PlayerTalk)