local function PlaySound(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "PlaySound") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local value = args[1]

	if not value or value == "" then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Value)"))

		return false

	end

	local players = player.GetAll()

	for i = 1, #players do

		players[i]:ConCommand("play " .. value)

	end

	return true

end

FAdmin.StartHooks["PlaySound"] = function()

	FAdmin.Access.AddPrivilege("PlaySound", 2)
	FAdmin.Commands.AddCommand("playsound", PlaySound)

end