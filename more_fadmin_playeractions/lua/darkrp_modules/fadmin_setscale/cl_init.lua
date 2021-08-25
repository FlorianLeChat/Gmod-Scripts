FAdmin.StartHooks["SetScale"] = function()

	FAdmin.Messages.RegisterNotification({
		name = "setscale",
		hasTarget = true,
		message = {"instigator", " set the scale of ", "targets", " to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end
	})

	FAdmin.Access.AddPrivilege("SetScale", 2)

	FAdmin.Commands.AddCommand("scale", nil, "<Player>", "<Scale>")
	FAdmin.Commands.AddCommand("setscale", nil, "[Player]", "<Scale>")

	FAdmin.ScoreBoard.Player:AddActionButton("Set scale", "icon16/shape_align_bottom.png", Color(255, 130, 0, 255),

	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetScale", ply) end,

	function(ply, button)

	end,

	function(ply, button)

		button.OnMousePressed = function()

			local window = Derma_StringRequest("Select scale", "What do you want the scale of the person to be?", "", function(text)

				RunConsoleCommand("fadmin", "setscale", ply:UserID(), text)

			end)

			window:RequestFocus()

		end

	end)

end