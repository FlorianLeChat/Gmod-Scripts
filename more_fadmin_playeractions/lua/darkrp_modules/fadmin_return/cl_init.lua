FAdmin.StartHooks["Return"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "return",
		hasTarget = true,
		message = {"instigator", " has returned ", "targets", " at its last position"}

	})

	FAdmin.Access.AddPrivilege("Return", 2)
	FAdmin.Commands.AddCommand("return", nil, "[Player]")

	FAdmin.ScoreBoard.Player:AddActionButton("Return", "icon16/arrow_redo.png", Color(0, 200, 0, 255),

		function(ply)

			return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "Return", ply)

		end,

		function(ply, button)

		end,

		function(ply, button)

			button.OnMousePressed = function()

				RunConsoleCommand("fadmin", "return", ply:UserID())

			end

		end

	)

end