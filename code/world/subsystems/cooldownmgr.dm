var/list/cooldownHandler = list()

/datum/controller/cooldowns
	name = "CD-Manager"
	execTime = 1

/datum/controller/cooldowns/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [cooldownHandler.len])")

/datum/controller/cooldowns/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [cooldownHandler.len])"

/datum/controller/cooldowns/doProcess()
	if(cooldownHandler.len)
		for(var/datum/ability/a in cooldownHandler)
			a.abilityCooldownTimer--
			if(a.abilityCooldownTimer <= 0)
				a.abilityCooldownTimer = 0 // just a redundancy
				cooldownHandler -= a
			if(a.holder)
				if(a.holder.client)
					a.holder.refreshInterface()
	scheck()