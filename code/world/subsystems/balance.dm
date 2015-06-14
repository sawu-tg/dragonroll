/datum/controller/balance
	name = "World Balance"
	execTime = 15
	var/shiftCause = 5 // shifts in this interval will cause events in the world
	var/lastBalance = 0
	var/balance = 0
	var/balanceMax = 100
	var/balanceMin = -100
	var/list/actsEvil = list() //list of evil things spawned
	var/list/actsGood = list() //list of good things spawned

/mob/verb/forceBalanceChange()
	set name = "Force Balance Change"
	set category = "Debug Verbs"

	var/change = input("By what?") as num
	if(change)
		balance.changeBalance(change)

/datum/controller/balance/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Bal: [balance] | Min: [balanceMin] | Max: [balanceMax])")

/datum/controller/balance/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Bal: [balance] | Min: [balanceMin] | Max: [balanceMax])"

/datum/controller/balance/proc/changeBalance(var/amount)
	lastBalance = balance
	balance = Clamp(balance + amount,balanceMin,balanceMax)

/datum/controller/balance/doProcess()
	if(balance % shiftCause == 0)
		if(balance > 0)
			doGoodAct(balance)
		else
			doEvilAct(balance)
	scheck()

/datum/controller/balance/proc/doGoodAct(var/atBalance)


/datum/controller/balance/proc/doEvilAct(var/atBalance)