local function CreateVote(ply, cmd, args)

	if not FAdmin.Access.PlayerHasPrivilege(ply, "SetHostName") then

		FAdmin.Messages.SendMessage(ply, 5, "No access!")

		return false

	end

	local value = args[1]

	if not value or value == "" then

		FAdmin.Messages.SendMessage(ply, 5, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "(Value)"))

		return false

	end

	DarkRP.createVote(value, nil, ply, 30, function(vote, win)

		local voters = table.Count(vote.voters)

		if voters > 0 then

			if win == 1 then

				PrintMessage(HUD_PRINTTALK, "The answer \"Yes\" won over the vote \"" .. vote.question .. "\" at " .. math.Round(vote.yea * 100 / voters) .. "%.")

			else

				PrintMessage(HUD_PRINTTALK, "The answer \"No\" won over the vote \"" .. vote.question .. "\" at " .. math.Round(vote.nay * 100 / voters) .. "%.")

			end

		else

			PrintMessage(HUD_PRINTTALK, "Nobody replied to the vote \"" .. vote.question .. "\".")

		end

	end, {}, nil, nil, nil)

	FAdmin.Messages.FireNotification("createvote", ply, nil, {value})

	return true, value

end

FAdmin.StartHooks["CreateVote"] = function()

	FAdmin.Messages.RegisterNotification({

		name = "createvote",
		receivers = "everyone",
		writeExtraInfo = function(info) net.WriteString(info[1]) end,
		message = {"instigator", " created a vote with the question ", "extraInfo.1"},
		extraInfoColors = {Color(255, 102, 0)}

	})

	FAdmin.Access.AddPrivilege("CreateVote", 2)

	FAdmin.Commands.AddCommand("vote", CreateVote)
	FAdmin.Commands.AddCommand("createvote", CreateVote)

end