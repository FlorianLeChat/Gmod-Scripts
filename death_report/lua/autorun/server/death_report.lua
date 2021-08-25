util.AddNetworkString("Gmod.Workshop.Death_Report")

hook.Add("PlayerDeath", "Gmod.Workshop.Death_Report", function(victim, inflictor, attacker)
	if victim ~= attacker and victim:IsPlayer() and attacker:IsPlayer() then
		net.Start("Gmod.Workshop.Death_Report")
		net.Send(victim)
	end
end)