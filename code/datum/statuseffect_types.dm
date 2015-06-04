/datum/statuseffect/dead
	name = "Dead"
	id = "dead"
	desc = "You deadened."
	addedstacks = list("dead","laydown")

/datum/statuseffect/dazed
	name = "Dazed"
	id = "daze"
	desc = "Probably does a thing but I forgot." //Give this an actual description you nigga
	addedstacks = list("no_act","daze")

/datum/statuseffect/disabled
	name = "Disabled"
	id = "disable"
	desc = "Can't do anything."
	addedstacks = list("no_act")

/datum/statuseffect/dying
	name = "Dying"
	id = "dying"
	desc = "Not really that dead yet."
	addedstacks = list("laydown")

/datum/statuseffect/drowning
	name = "Drowning"
	id = "drown"
	desc = "Underwater and dying."
	addedstacks = list("drown")

/datum/statuseffect/stun
	name = "Stunned"
	id = "stun"
	desc = "No action possible (I think)"
	addedstacks = list("no_move","no_act","laydown")

/datum/statuseffect/poison
	name = "Poison"
	id = "poison"
	desc = "It courses through your veins."
	addedstacks = list("poison")