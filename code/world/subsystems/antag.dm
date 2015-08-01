var/list/globalAntags = list()

/datum/controller/antags
	name = "Antagonists"
	execTime = 15
	var/objectivesPerPerson = 4
	var/maxAntags = 10

/datum/controller/antags/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalAntags.len])")

/datum/controller/antags/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalAntags.len])"

/datum/controller/antags/proc/registerPlayer(var/mob/player/P)
	if(globalAntags.len < maxAntags)
		globalAntags |= P
		return TRUE
	return FALSE

/datum/controller/antags/proc/unregisterPlayer(var/mob/player/P)
	globalAntags -= P

/datum/controller/antags/proc/validateObjective(var/datum/objective/O,var/mob/player/P)
	if(O.completed)
		return FALSE

	if(!O.target)
		return TRUE

	switch(O.obj_type)
		if(OBJ_STEAL)
			if(O.target.loc == P)
				return TRUE
		if(OBJ_DESTROY)
			if(istype(O.target,/mob/player))
				var/mob/player/T = O.target
				if(T.playerData.hp.statCurr <= 0)
					return TRUE
			else
				if(!O.target)
					return TRUE
		if(OBJ_RULE)
			if(!istype(O.target,/datum/faction))
				return FALSE
			var/datum/faction/F = O.target
			if(F.factionCreator == P && F.factionMembers.len >= O.number)
				return TRUE
		if(OBJ_USURP)
			if(!istype(O.target,/datum/faction))
				return FALSE
			var/datum/faction/F = O.target
			if(F.factionCreator != P && P in F.factionOwners && F.factionMembers.len >= O.number)
				return TRUE
		if(OBJ_HITLER)
			if(!istype(O.target,/datum/faction))
				return FALSE
			var/datum/faction/F = O.target
			if(F.factionMembers.len <= 0)
				return TRUE
		///
		// TODO OBJECTIVES
		///
		if(OBJ_DISCOVER)
			return TRUE
		if(OBJ_AVENGE)
			return TRUE

/datum/controller/antags/doProcess()
	if(globalAntags.len)
		for(var/mob/player/P in globalAntags)
			if(P.playerAntag)
				if(P.playerAntag.antag_objectives.len < objectivesPerPerson + P.playerAntag.completedObjectives)
					generateObj(P)
				var/toAdd = 0
				var/totalScore = 0
				for(var/datum/objective/O in P.playerAntag.antag_objectives)
					if(O.completed)
						toAdd++
						totalScore += O.number
						continue
					if(validateObjective(O,P))
						if(P.client)
							addScore(P.client.key,"Completed Objectives")
						O.completed = TRUE
				P.playerAntag.completedObjectives = toAdd
				P.playerAntag.score = totalScore + toAdd
	scheck()


////
// STORYTELLER
////

/mob/player/verb/clearObjectives()
	set name = "Clear Objectives"
	set desc = "Clears all active objectives for you"
	set category = "Debug Verbs"
	playerAntag.antag_objectives.Cut()

/proc/objectiveName(var/datum/objective/O)
	switch(O.obj_type)
		if(1)
			return "Steal"
		if(2)
			return istype(O.target,/mob/player) ? "Kill" : "Destroy"
		if(3)
			return "Rule"
		if(4)
			return "Usurp"
		if(5)
			return "Eradicate"

/proc/generateObjDesc(var/datum/objective/O)
	switch(O.obj_type)
		if(1)
			return "You are required to [objectiveName(O)] at least [O.number] [O.target][O.number > 1 ? "'s" : ""]"
		if(2)
			return "You are required to [objectiveName(O)] at least [O.number] [O.target][O.number > 1 ? "'s" : ""]"
		if(3,4,5)
			return "You are required to [objectiveName(O)] the faction of [O.target], while they have at least [O.number] members."
	return "You are required to [objectiveName(O)] at least [O.number] [O.target][O.number > 1 ? "'s" : ""]"

/datum/controller/antags/proc/generateObj(var/mob/player/P)
	var/choice = rand(1,5)
	for(var/datum/objective/O in P.playerAntag.antag_objectives)
		if(O.obj_type == choice && (choice == 3 || choice == 4))
			choice = pick(1,2,5)
	var/datum/objective/O = new
	O.obj_type = choice
	switch(choice)
		if(1)
			var/index = rand(1,globalObjList.len)
			O.target = globalObjList[index]
		if(2)
			var/index = rand(1,globalMobList.len)
			O.target = globalMobList[index]
		if(3)
			O.number = rand(1,round(globalMobList.len/2))
			if(P.mobFaction.factionCreator == P && P in P.mobFaction.factionMembers)
				O.target = P.mobFaction
			else
				var/datum/faction/F = new()
				F.name = "[P]'s Kingdom"
				F.hostileTo = list("Hostile")
				F.friendlyTo = list("Wildlife")
				F.factionImage = new('sprite/obj/flags.dmi',icon_state = pick(icon_states('sprite/obj/flags.dmi')))
				globalFactions += F
				P.forceJoinFaction(F.name)
				P.mobFaction.factionCreator = P
				messageInfo("You have been selected as a ruler!",P,P)
				O.target = F
		if(4,5)
			O.number = rand(1,round(globalMobList.len/2))
			O.target = pick(globalFactions)
	O.name = "[objectiveName(O)] [O.target][(O.number > 1 && O.number < 3) ? "'s" : ""]"
	O.desc = generateObjDesc(O)
	P.playerAntag.antag_objectives += O
	P << "<text style='text-align: center; vertical-align: middle; font-size: 3;'>\red New Objective!</text>"
	P << "<text style='text-align: center; vertical-align: middle; font-size: 2;'><b>[O.name]</b><br>[O.desc]</text>"
