/datum/controller/balance
	name = "World Balance"
	execTime = 15
	var/shiftCause = 15 // shifts in this interval will cause events in the world
	var/lastBalance = 0
	var/balance = 0
	var/goodPoints = 0 // accumulates when the world has a good change
	var/evilPoints = 0 // accumulates when the world has an evil change
	var/balanceMax = 100
	var/balanceMin = -100
	var/apocTimer = 1200 // how long the apoc goes for
	var/list/actsEvil = list() //list of evil things spawned
	var/list/actsGood = list() //list of good things spawned

	//apocolypse vars
	var/apocEvil = FALSE
	var/apocGood = FALSE

/mob/verb/forceBalanceChange()
	set name = "Force Balance Change"
	set category = "Debug Verbs"

	var/change = input("By what?") as num
	if(change)
		balance.changeBalance(change)

/datum/controller/balance/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Bal: [balanceMin]/[balance]/[balanceMax] | GP: [goodPoints] | EP: [evilPoints] | Apoc: [apocTimer])")

/datum/controller/balance/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Bal: [balanceMin]/[balance]/[balanceMax] | GP: [goodPoints] | EP: [evilPoints] | Apoc: [apocTimer])"

/datum/controller/balance/proc/changeBalance(var/amount)
	lastBalance = balance
	if(amount > 0)
		goodPoints += (amount*10)
	else
		evilPoints += (-amount*10)
	balance = Clamp(balance + amount,balanceMin,balanceMax)

/datum/controller/balance/doProcess()
	scheck()
	if(apocEvil)
		doEvilApoc()
	if(apocGood)
		doGoodApoc()
	if(balance % shiftCause == 0)
		if(balance > 0)
			doGoodAct()
		else
			doEvilAct()

/datum/controller/balance/proc/doEvilApoc()
	if(balance > 0)
		apocEvil = FALSE
		messageWarningAll("Balance has been restored; The Dark Apocolypse ends!")
		return
	evilPoints += 100
	if(apocTimer > 0)
		--apocTimer
	else
		messageWarningAll("Darkness has consumed the land; The Pristine flee before it's might!")
		world.Reboot()

/datum/controller/balance/proc/doGoodApoc()
	if(balance < 0)
		apocGood = FALSE
		messageWarningAll("Balance has been restored; The Pristine Apocolypse ends!")
		return
	goodPoints += 100
	if(apocTimer > 0)
		--apocTimer
	else
		messageWarningAll("The Pristine Light prevails, Darkness has been driven from the land!")
		world.Reboot()

/datum/controller/balance/proc/doGoodAct()
	set background = 1
	//Cleanse the land of an evil act
	if(balance >= balanceMax && !apocGood)
		apocGood = TRUE
		apocTimer = initial(apocTimer)
		messageWarningAll("A Pristine light shines upon the land, the Dark will be cleansed!")
		return
	if(actsEvil.len && goodPoints > 0)
		var/A = pick(actsEvil)
		if(A)
			if(istype(A,/turf/wall))
				new/turf/wall/balance/good(get_turf(A))
			else if(istype(A,/turf/floor))
				new/turf/floor/balance/good(get_turf(A))
			else
				sdel(A)
			--goodPoints

/datum/controller/balance/proc/doEvilAct()
	set background = 1
	//Cleanse the land of a good act
	if(balance <= balanceMin && !apocEvil)
		apocEvil = TRUE
		apocTimer = initial(apocTimer)
		messageWarningAll("A Darkness falls upon the land, the Pristine shall fall!")
		return
	if(evilPoints > 0)
		if(actsGood.len)
			var/A = pick(actsGood)
			if(A)
				if(istype(A,/turf/wall))
					new/turf/wall/balance/evil(get_turf(A))
				else if(istype(A,/turf/floor))
					new/turf/floor/balance/evil(get_turf(A))
				else
					sdel(A)
				--evilPoints
		if(prob(25))
			var/turf/T = locate(rand(1,world.maxx),rand(1,world.maxy),rand(2,world.maxz))
			if(T)
				--evilPoints
				new/turf/floor/balance/evil(get_turf(T))
