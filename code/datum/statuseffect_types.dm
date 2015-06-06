/datum/statuseffect/dead
	name = "Dead"
	id = "dead"
	desc = "You deadened."
	addedstacks = list("dead","laydown")

/datum/statuseffect/dazed
	name = "Dazed"
	id = "daze"
	desc = "You are dizzy."
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


// katawa shoujo things
/datum/statuseffect/decap
	name = "decapitation effect"
	var/lossStat = "str"

/datum/statuseffect/decap/applyStatus()
	if(mymob)
		var/datum/stat/S = mymob:findStat(lossStat)
		if(S)
			statchanges[lossStat] = -(S.statBase/4)
			//S.setTo(S.statCurr-lossAmount)
	..()

///datum/statuseffect/decap/removeStatus()
	//if(mymob)
		//var/datum/stat/S = mymob:findStat(lossStat)
		//if(S)
			//S.setTo(S.statCurr+lossAmount)
	//..()

/datum/statuseffect/decap/norleg
	name = "Missing Right Leg"
	id = "norleg"
	desc = "You are missing your Right Leg."

/datum/statuseffect/decap/nolleg
	name = "Missing Left Leg"
	id = "nolleg"
	desc = "You are missing your Left Leg."

/datum/statuseffect/decap/norarm
	name = "Missing Right Arm"
	id = "norarm"
	desc = "You are missing your Right Arm."

/datum/statuseffect/decap/nolarm
	name = "Missing Left Arm"
	id = "nolarm"
	desc = "You are missing your Left Arm."

/datum/statuseffect/decap/nochest
	name = "Missing Chest"
	id = "nochest"
	desc = "You are missing your Chest."

/datum/statuseffect/decap/nohead
	name = "Missing Head"
	id = "nohead"
	desc = "You are missing your Head."