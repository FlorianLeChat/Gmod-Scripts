FAdmin.StartHooks["SetArmor"] = function()

	FAdmin.Messages.RegisterNotification({
		name = "setarmor",
		hasTarget = true,
		message = {"instigator", " set the armor of ", "targets", " to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end
	})

	FAdmin.Access.AddPrivilege("SetArmor", 2)

	FAdmin.Commands.AddCommand("armor", nil, "<Player>", "<Armor>")
	FAdmin.Commands.AddCommand("setarmor", nil, "[Player]", "<Armor>")

	FAdmin.ScoreBoard.Player:AddActionButton("Set armor", "icon16/shield.png", Color(20, 20, 255, 255),

	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetArmor", ply) end,

	function(ply, button)

	end,

	function(ply, button)

		button.OnMousePressed = function()

			local window = Derma_StringRequest("Select armor", "What do you want the armor of the person to be?", "", function(text)

				RunConsoleCommand("fadmin", "setarmor", ply:UserID(), text)

			end)

			window:RequestFocus()

		end

	end)

end