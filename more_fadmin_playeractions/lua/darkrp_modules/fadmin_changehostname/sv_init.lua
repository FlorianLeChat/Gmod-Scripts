local function SetHostName(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetHostName") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local value = args[1]

	if not value or value == "" then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Value)"))

		return false

	end

	RunConsoleCommand("hostname", value)

	FAdmin.Messages.FireNotification("sethostname", ply, nil, {value})

	return true, value

end

FAdmin.StartHooks["SetHostName"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "sethostname",
		receivers = "involved+superadmins",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " changed the hostname to ", "extraInfo.1"},
		extraInfoColors = {Color(255, 102, 0)}

	})

	FAdmin.Access.AddPrivilege("SetHostName", 3)
	FAdmin.Commands.AddCommand("hostname", SetHostName)
	FAdmin.Commands.AddCommand("sethostname", SetHostName)

end