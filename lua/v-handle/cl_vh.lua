concommand.Add("vh", function(Player, Command, Args)
	if #Args == 0 then return end
	net.Start("VH_ClientCCmd")
		net.WriteString(von.serialize({Player = Player, Args = Args}))
	net.SendToServer()
end)