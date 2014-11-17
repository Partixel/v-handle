---- SpamFilter Config ----
VH_SpamFilter = VH_SpamFilter or {}
VH_SpamFilter.ChatBlacklist = {
	"Retard",
	"Faggot",
	"Fagget",
	"Fag"
}
-- Add words you want blacklisted into the table, requires a comma at end
VH_SpamFilter.MaxWordLength = 15
-- Maximum length of words
VH_SpamFilter.CapsPercentage = 70
-- Maximum percentage of capitals per word
VH_SpamFilter.CensorPercentage = 70
-- Maximum percentage of censoring per word
VH_SpamFilter.LetterDragging = 3
-- Maximum letters in a row
VH_SpamFilter.AdvancedFiltering = true
-- Checks for common letter changes to bypass filters, e.g using @ instead of a
VH_SpamFilter.SoftFiltering = true
-- Checks for similarities in words that bypass filters, allows 1 difference per 4 letters compared to blacklisted words
VH_SpamFilter.MatchingChars = {
	{"a", "@", "2", "ª", "À", "Á", "Â", "Ã", "Ä", "Å", "à", "á", "â", "ã", "ä", "å"},
	{"b", "þ", "ß", "Þ"},
	{"c", "¢", "©", "Ç", "ç"},
	{"d", "Ð"},
	{"e", "3", "€", "È", "É", "Ë", "Ê", "è", "é", "ê", "ë"},
	{"f", "ƒ"},
	{"g"},
	{"h"},
	{"i", "1", "!", "|", "¡", "Ì", "Í", "Î", "Ï", "Ù", "Ú", "Û", "Ü", "ù", "ú", "û", "ü"},
	{"j"},
	{"k"},
	{"l", "|"},
	{"m"},
	{"n", "ñ", "Ñ"},
	{"o", "0", "°", "º", "Ò", "Ó", "Ô", "Õ", "Ö", "Ø", "ò", "ó", "ô", "õ", "ö", "ø", "ð"},
	{"p", "Þ"},
	{"q", "¶"},
	{"r"},
	{"s", "Š", "š", "$", "5", "$"},
	{"t", "†"},
	{"u", "Ù", "Ú", "Û", "Ü", "ù", "ú", "û", "ü"},
	{"v"},
	{"w", "vv"},
	{"x", "×"},
	{"y", "ý", "ÿ", "Ÿ", "¥", "Ý"},
	{"z", "Ž"},
	{"ate", "8"},
	{"tm", "™"},
	{"oe", "Œ", "œ"},
	{"ae", "Æ", "æ"}
}
-- Characters that may be used in place of other characters
-- e.g. 1 instead of I