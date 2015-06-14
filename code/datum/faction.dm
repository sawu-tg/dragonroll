/datum/faction
	var/name = "Neutral"
	var/list/friendlyTo = list() // who the faction is friendly to
	var/list/hostileTo = list() // who the faction is hostile to


/datum/faction/garbageCleanup()
	..()
	friendlyTo = null
	hostileTo = null


///
// Checks whether a faciton is hostile to the given faction
///
/datum/faction/proc/isHostile(var/datum/faction/F)
	for(var/datum/faction/FA in hostileTo)
		if(FA.name == F.name)
			return TRUE
	return FALSE

///
// Checks whether a faciton is friendly to the given faction
///
/datum/faction/proc/isFriendly(var/datum/faction/F)
	if(F.name == name)
		return TRUE
	for(var/datum/faction/FA in friendlyTo)
		if(FA.name == F.name)
			return TRUE
	return FALSE

///////////// FACTIONS /////////////////////////

/datum/faction/colonist
	name = "Colonists"

/datum/faction/wildlife
	name = "Wildlife"

/datum/faction/generic_hostile
	name = "Hostile"
	hostileTo = list(new/datum/faction/wildlife, new/datum/faction/colonist)

/datum/faction/grey
	name = "Mothership"
	hostileTo = list(new/datum/faction/wildlife, new/datum/faction/colonist, new/datum/faction/generic_hostile)