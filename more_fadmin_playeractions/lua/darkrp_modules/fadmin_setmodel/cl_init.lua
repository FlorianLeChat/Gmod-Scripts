FAdmin.StartHooks["SetModel"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "setmodel",
		hasTarget = true,
		message = {"instigator", " set the model of ", "targets", " to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end

	})

	FAdmin.Access.AddPrivilege("SetModel", 2)

	FAdmin.Commands.AddCommand("model", nil, "[Player]", "<Model>")
	FAdmin.Commands.AddCommand("setmodel", nil, "[Player]", "<Model>")

	FAdmin.ScoreBoard.Player:AddActionButton("Set model", "icon16/user_suit.png", Color(255, 130, 0, 255),

		function(ply)

			return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetModel", ply)

		end,

		function(ply, button)

		end,

		function(ply, button)

			button.OnMousePressed = function()

				local window = Derma_StringRequest("Select model", "What do you want the model of the person to be?", "", function(text)

					RunConsoleCommand("fadmin", "setmodel", ply:UserID(), text)

				end)

				window:RequestFocus()

			end

		end

	)

end