FAdmin.StartHooks["SetHunger"] = function()

	if DarkRP.disabledDefaults["modules"]["hungermod"] then return end

	FAdmin.Messages.RegisterNotification({

		name = "sethunger",
		hasTarget = true,
		message = {"instigator", " set the hunger of ", "targets", " to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end

	})

	FAdmin.Access.AddPrivilege("SetHunger", 2)

	FAdmin.Commands.AddCommand("hunger", nil, "[Player]", "<Hunger>")
	FAdmin.Commands.AddCommand("sethunger", nil, "[Player]", "<Hunger>")

	FAdmin.ScoreBoard.Player:AddActionButton("Set hunger", "icon16/cup.png", Color(255, 130, 0, 255),

		function(ply)

			return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetHunger", ply)

		end,

		function(ply, button)

		end,

		function(ply, button)

			button.OnMousePressed = function()

				local window = Derma_StringRequest("Select hunger", "What do you want the hunger of the person to be?", "", function(text)

					RunConsoleCommand("fadmin", "sethunger", ply:UserID(), text)

				end)

				window:RequestFocus()

			end

		end

	)

end