local Module = {}
Module.Name = "CommandsTab"
Module.Description = "Tab containing all commands"

function RenderCall(Frame, Table)
	--[[local CurrentCommands = 0
	for _, a in pairs(vh.Modules) do
		if (!a["Commands"]) then continue end
		for i, v in pairs(a.Commands) do
			Table[i] = vgui.Create("DButton", Frame)
			Table[i]:SetPos(Frame:GetWide() * 0.2 - (3 * CurrentCommands), 10 + (35 * CurrentCommands))
			Table[i]:SetSize(Frame:GetWide() * 0.6, 30)
			Table[i]:SetText("")
			Table[i].Paint = function()
				_V.MenuLib.DrawTrapezoidFancy(0, 0, Table[i]:GetWide(), Table[i]:GetTall(), _V.MenuLib.GetSettings().Colors.MainButton, 2, 2)
				draw.SimpleText(i, "VHUIFontSmall", Table[i]:GetWide()/2, Table[i]:GetTall()/2 - 4, Color(50, 50, 50, 255), 1, 1)
			end
			Table[i].DoClick = function()
				CommandOpen = v
				OpenCommandView(Frame, Table, v)
			end
			CurrentCommands = CurrentCommands + 1
		end
	end]]
end

function GetValidArguments(ArgType)
	local ReturnTable = {}
	if ArgType == "Player" then
		table.insert(ReturnTable, "All")
		table.insert(ReturnTable, "Me")
		table.insert(ReturnTable, "Others")
		table.insert(ReturnTable, "Admins")
		table.insert(ReturnTable, "Non-Admins")
		for _, v in pairs(player.GetAll()) do
			table.insert(ReturnTable, v:GetName())
		end
	elseif ArgType == "Rank" then
		for _, v in pairs(vh.RankTypes) do
			table.insert(ReturnTable, v.Name)
		end
	elseif ArgType == "String" then
		ReturnTable = "String"
	end
	return ReturnTable
end

function OpenCommandView(Frame, Table, Command)
	Table.CommandPanel = vgui.Create("DPanel", Frame)
	Table.CommandPanel:SetPos(0, 0)
	Table.CommandPanel:SetSize(Frame:GetWide(), Frame:GetTall())
	Table.CommandPanel.Paint = function()
		_V.MenuLib.DrawTrapezoidSemiFancy(0, 0, Frame:GetWide(), Frame:GetTall(), _V.MenuLib.GetSettings().Colors.Main, 40, 5)
	end
	Table.BackButton = vgui.Create("DButton", Table.CommandPanel)
	Table.BackButton:SetPos(Frame:GetWide() - 90, 10)
	Table.BackButton:SetSize(80, 30)
	Table.BackButton:SetText("")
	Table.BackButton.Paint = function()
		_V.MenuLib.DrawTrapezoidFancy(0, 0, Table.BackButton:GetWide(), Table.BackButton:GetTall(), _V.MenuLib.GetSettings().Colors.SecondaryButton, 2, 2)
		draw.SimpleText("<", "VHUIFont", Table.BackButton:GetWide()/2, Table.BackButton:GetTall()/2 - 4, Color(50, 50, 50, 255), 1, 1)
	end
	Table.BackButton.DoClick = function()
		Table.CommandPanel:Remove()
	end
	local Arguments = Command.Arguments
	local CurrentArguments = 0
	for i, v in pairs(Arguments) do
		Table["Arguments"..i] = vgui.Create("DComboBox", Table.CommandPanel)
		Table["Arguments"..i]:SetPos(Frame:GetWide() * 0.2 - (3 * CurrentArguments), 10 + (35 * CurrentArguments))
		Table["Arguments"..i]:SetSize(Frame:GetWide() * 0.6, 30)
		Table["Arguments"..i]:SetText("")
		Table["Arguments"..i].Paint = function()
			_V.MenuLib.DrawTrapezoidFancy(0, 0, Table["Arguments"..i]:GetWide(), Table["Arguments"..i]:GetTall(), _V.MenuLib.GetSettings().Colors.MainButton, 2, 2)
			draw.SimpleText(v, "VHUIFontSmall", Table["Arguments"..i]:GetWide()/2, Table["Arguments"..i]:GetTall()/2 - 4, Color(50, 50, 50, 255), 1, 1)
		end
		for _, a in pairs(GetValidArguments(v)) do
			if type(a) == "string" then
				Table["Arguments"..i]:AddChoice(a)
			end
		end
		CurrentArguments = CurrentArguments + 1
	end
end

local CommandsTab = _V.MenuLib.VTab:new("Commands", RenderCall, Color(70, 140, 80), "commands", 1)

vh.RegisterModule(Module)