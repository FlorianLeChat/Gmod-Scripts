FAdmin.StartHooks["PlaySound"] = function()

	FAdmin.Access.AddPrivilege("PlaySound", 2)
	FAdmin.Commands.AddCommand("playsound", nil, "<Sound>")

	FAdmin.ScoreBoard.Server:AddServerAction("PlaySound", "icon16/music.png", Color(155, 0, 0, 255),

	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "PlaySound", ply) end,

	function(ply, button)

		Derma_StringRequest("PlaySound command", "Enter a sound to be play on the server.", "", function(text)

			RunConsoleCommand("fadmin", "playsound", text)

		end)

	end)

end