/datum/faction
	var/name = "Neutral"
	var/list/friendlyTo = list() // who the faction is friendly to
	var/list/hostileTo = list() // who the faction is hostile to


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
	for(var/datum/faction/FA in friendlyTo)
		if(FA.name == F)
			return TRUE
	return FALSE

///////////// FACTIONS /////////////////////////

/datum/faction/crewmember
	name = "Station Crew"

/datum/faction/wildlife
	name = "Wildlife"

/datum/faction/generic_hostile
	name = "Hostile"
	hostileTo = list(/datum/faction/wildlife, /datum/faction/crewmember)

/datum/faction/grey
	name = "Mothership"
	hostileTo = list(/datum/faction/wildlife, /datum/faction/crewmember, /datum/faction/generic_hostile)