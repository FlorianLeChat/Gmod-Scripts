FAdmin.StartHooks["CreateVote"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "createvote",
		message = {"instigator", " created a vote with the question ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end,
		extraInfoColors = {Color(255, 102, 0)}

	})

	FAdmin.Access.AddPrivilege("CreateVote", 2)

	FAdmin.Commands.AddCommand("vote", nil, "[Question]")
	FAdmin.Commands.AddCommand("createvote", nil, "[Question]")

	FAdmin.ScoreBoard.Server:AddServerAction("Create vote", "icon16/timeline_marker.png", Color(155, 0, 0, 255),

		function(ply)

			return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "CreateVote", ply)

		end,

		function(ply, button)

			Derma_StringRequest("Create vote", "What do you want the vote to be about?", "", function(text)

				RunConsoleCommand("fadmin", "createvote", text)

			end)

		end

	)

end