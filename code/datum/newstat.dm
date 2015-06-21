/mob/player/proc/archiveStats()
	for(var/datum/stat/S in playerData.playerStats)
		S.archive()

/mob/player/proc/recapStats()
	for(var/datum/stat/S in playerData.playerStats)
		S.recap()

/mob/player/proc/recalculateStats(var/list/filter)
	for(var/datum/stat/S in playerData.playerStats)
		if(filter && filter.len && !(S.statId in filter))
			continue

		S.recalculate()

		for(var/datum/statuseffect/status in statuseffects)
			if(status) //If sawu breaks a thing again
				status.recalculateStat(S)

		for(var/obj/item/I in playerEquipped)
			if(I)
				I.recalculateStat(S)

/mob/player/proc/recalculateBaseStats()
	var/datum/race/R = playerData.playerRace
	var/datum/class/C = playerData.playerClass

	for(var/datum/stat/S in playerData.playerStats)
		S.recalculateBase()
		if(R)
			R.recalculateStat(S)
		if(C)
			C.recalculateStat(S)

/mob/player/proc/findStat(var/ofname)
	for(var/datum/stat/S in playerData.playerStats)
		if(S.statId == ofname)
			return S
	return null

/datum/race
	var/list/stat_mods = list() //Balance around 0

/datum/race/proc/recalculateStat(var/datum/stat/S)
	if(!S || !istype(S))
		return

	var/statmod = stat_mods[S.statId]

	S.statNormal += statmod

/datum/class
	var/list/stat_mods = list() //Balance around 0

/datum/class/proc/recalculateStat(var/datum/stat/S)
	if(!S || !istype(S))
		return

	var/statmod = stat_mods[S.statId]

	S.statNormal += statmod

/datum/stat
	var/statName = "noname"	//Name of the stat
	var/statDesc = ""		//Description of the stat
	var/statId = ""			//Id of the stat for referencing it
	var/statIcon = ""		//Iconstate of the stat

	var/statBase = 0		//The rolled base stat
	var/statBaseOld = 0		//For rerolls

	var/statNormal = 0 		//The base stat with class and race modifiers

	var/statModified = 0 	//The modified stat from buffs etc etc
	var/statCurr = 100

	var/statMin = 0 // The minimum a stat can reach
	var/statMax = 100 // The maximum a stat can reach

	var/isLimited = FALSE // Toggles depletion on, like hp

	var/totalXP = 0 // total gained XP
	var/xpToLevel = 120 // base XP per level
	var/xpModifier = 1.5 // the amount xpToLevel is times'd by each level

/datum/stat/New(var/name = "error", var/id = "", var/limit=FALSE, var/cur=0, var/min=0, var/max=100, var/staticon = "")
	if(limit)
		isLimited = limit
		statMin = min
	statName = name
	statId = id
	statIcon = staticon

	statBase = cur
	statCurr = statBase

	archive()

//Recalculates the statNormal from the rolled statBase + all race/class modifiers etc
/datum/stat/proc/recalculateBase()
	statNormal = statBase

//Recalculates the modified stat from statNormal and all applied buffs etc
/datum/stat/proc/recalculate()
	statModified = statNormal

//Recalculates the current value the stat is at (for hp and mp etc) and clamps it between statMin and statModified
/datum/stat/proc/recap()
	statModified = statNormal

//Archive the base stat so we can revert to it later
/datum/stat/proc/archive()
	statBaseOld = statBase

/datum/stat/proc/setBaseTo(var/n)
	statBase = n

//Revert the base stat
/datum/stat/proc/revert()
	statBase = statBaseOld

/datum/stat/proc/addxp(var/n)
	totalXP += n
	if(totalXP >= xpToLevel)
		change(1)
		var/temp_xp = xpToLevel * xpModifier
		xpToLevel += temp_xp

/datum/stat/proc/change(var/n)
	if(isLimited)
		statCurr += n
		statCurr = Clamp(statCurr,statMin,statModified)
	else
		statModified += n
		statCurr = statModified

/datum/stat/proc/setTo(var/n)
	if(isLimited)
		statCurr = n
		statCurr = Clamp(statCurr,statMin,statModified)
	else
		statModified = n
		statCurr = statModified

/datum/stat/woodcutting // buying willow logs 200gp
	xpToLevel = 83
	xpModifier = 1.104
	statMax = 120
