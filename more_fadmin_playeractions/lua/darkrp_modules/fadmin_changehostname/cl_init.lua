FAdmin.StartHooks["SetHostName"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "sethostname",
		message = {"instigator", " changed the hostname to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end,
		extraInfoColors = {Color(255, 102, 0)}

	})

	FAdmin.Access.AddPrivilege("SetHostName", 3)

	FAdmin.Commands.AddCommand("hostname", nil, "[Hostname]")
	FAdmin.Commands.AddCommand("sethostname", nil, "[Hostname]")

	FAdmin.ScoreBoard.Server:AddServerAction("Hostname", "icon16/text_smallcaps.png", Color(155, 0, 0, 255),

		function(ply)

			return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetHostName", ply)

		end,

		function(ply, button)

			Derma_StringRequest("Set hostname", "What do you want the new hostname to be?", GetHostName(), function(text)

				RunConsoleCommand("fadmin", "sethostname", text)

			end)

		end

	)

end