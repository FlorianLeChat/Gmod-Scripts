FAdmin.StartHooks["SetMoney"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "setmoney",
		hasTarget = true,
		message = {"instigator", " set the money of ", "targets", " to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end

	})

	FAdmin.Access.AddPrivilege("SetMoney", 3)
	FAdmin.Commands.AddCommand("money", nil, "[Player]", "<Money>")

	FAdmin.ScoreBoard.Player:AddActionButton("Set money", "icon16/money.png", Color(20, 150, 20, 255),

		function(ply)

			return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetMoney", ply)

		end,

		function(ply, button)

		end,

		function(ply, button)

			button.OnMousePressed = function()

				local window = Derma_StringRequest("Select money", "What do you want the money of the person to be?", "", function(text)

					RunConsoleCommand("fadmin", "money", ply:UserID(), text)

				end)

				window:RequestFocus()

			end

		end

	)

end