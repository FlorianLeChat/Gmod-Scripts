FAdmin.StartHooks["SetName"] = function()

	FAdmin.Messages.RegisterNotification({
		name = "setname",
		hasTarget = true,
		message = {"instigator", " set the name of ", "targets", " to ", "extraInfo.1"},
		readExtraInfo = function() return {net.ReadString()} end
	})

	FAdmin.Access.AddPrivilege("SetName", 2)
	FAdmin.Commands.AddCommand("setname", nil, "<Player>", "<Name>")

	FAdmin.ScoreBoard.Player:AddActionButton("Set name", "icon16/textfield_rename.png", Color(0, 200, 0, 255),

	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SetName", ply) end,

	function(ply, button)

	end,

	function(ply, button)

		button.OnMousePressed = function()

			local window = Derma_StringRequest("Select name", "What do you want the name of the person to be?", "", function(text)

				RunConsoleCommand("fadmin", "setname", ply:UserID(), text)

			end)

			window:RequestFocus()

		end

	end)

end