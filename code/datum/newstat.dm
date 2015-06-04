/mob/player/proc/archiveStats()
	for(var/datum/stat/S in playerData.playerStats)
		S.archive()

/mob/player/proc/recapStats()
	for(var/datum/stat/S in playerData.playerStats)
		S.recap()

/mob/player/proc/recalculateStats()
	for(var/datum/stat/S in playerData.playerStats)
		S.recalculate()

/mob/player/proc/recalculateBaseStats()
	var/datum/race/R = playerData.playerRace
	var/datum/class/C = playerData.playerClass

	for(var/datum/stat/S in playerData.playerStats)
		S.recalculateBase()
		R.recalculateStat(S)
		C.recalculateStat(C)

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

/datum/stat/proc/change(var/n)
	statCurr += n

	if(isLimited)
		statCurr = Clamp(statCurr,statMin,statModified)
	else
		statCurr = statModified

/datum/stat/proc/setTo(var/n)
	statCurr = n

	if(isLimited)
		statCurr = Clamp(statCurr,statMin,statModified)
	else
		statCurr = statModified