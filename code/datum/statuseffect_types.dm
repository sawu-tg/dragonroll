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

/datum/statuseffect/suffocating
	name = "Suffocating"
	id = "drown"
	desc = "Suffocating from something."

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

/datum/statuseffect/poison/applyStatus()
	if(mymob)
		for(var/datum/organ/O in mymob:playerOrgans)
			O.health -= rand(1,10)
	..()

/datum/statuseffect/bolster
	name = "Bolster"
	id = "bolster"
	desc = "Your HP and DEF are increased"

/datum/statuseffect/bolster/applyStatus()
	if(mymob)
		var/datum/stat/S = mymob:findStat("str")
		var/datum/stat/SS = mymob:findStat("hp")
		if(S && SS)
			statchanges["str"] = 5
			statchanges["hp"] = 5
	..()

// katawa shoujo things
/datum/statuseffect/decap
	name = "decapitation effect"
	var/lossStat = "str"
	var/idToLink
	var/obj/interface/slot/linkedSlot

/datum/statuseffect/decap/New()
	..()
	for(var/Sid in mymob:slots)
		var/obj/interface/slot/S = mymob.slots[Sid]
		if(S:id == idToLink)
			linkedSlot = S

/datum/statuseffect/decap/applyStatus()
	if(mymob)
		if(linkedSlot)
			spawn(1)
				if(linkedSlot.is_hand)
					if(idToLink && mymob)
						mymob.selectSlot(idToLink)
						mymob.DropItem()
				else
					var/obj/item/I
					for(var/obj/item/A in mymob)
						if(A.slot == idToLink)
							I = A
					mymob:unEquipItem(I)
					mymob:remFromInventory(I)
			linkedSlot.blocked = TRUE
		var/datum/stat/S = mymob:findStat(lossStat)
		if(S)
			statchanges[lossStat] = -(S.statBase/4)
			//S.setTo(S.statCurr-lossAmount)
	..()

datum/statuseffect/decap/removeStatus()
	if(mymob)
		if(linkedSlot)
			linkedSlot.blocked = FALSE
	..()

/datum/statuseffect/decap/norleg
	name = "Missing Right Leg"
	id = "norleg"
	idToLink = "r_foot"
	desc = "You are missing your Right Leg."

/datum/statuseffect/decap/nolleg
	name = "Missing Left Leg"
	id = "nolleg"
	idToLink = "l_foot"
	desc = "You are missing your Left Leg."

/datum/statuseffect/decap/norarm
	name = "Missing Right Arm"
	id = "norarm"
	idToLink = "r_hand"
	desc = "You are missing your Right Arm."

/datum/statuseffect/decap/nolarm
	name = "Missing Left Arm"
	id = "nolarm"
	idToLink = "l_hand"
	desc = "You are missing your Left Arm."

/datum/statuseffect/decap/nochest
	name = "Missing Chest"
	id = "nochest"
	idToLink = "chest"
	desc = "You are missing your Chest."

/datum/statuseffect/decap/nohead
	name = "Missing Head"
	id = "nohead"
	idToLink = "head"
	desc = "You are missing your Head."


///
// FOOD STATUS
///

/datum/statuseffect/wellfed
	name = "Well Fed"
	id = "wellfed"
	desc = "You feel satiated, and are healing over time."
	addedstacks = list("wellfed")

/datum/statuseffect/wellfed/removeStatus()
	mymob:healDamage(1)
	..()

/datum/statuseffect/regenerate
	name = "Regeneration"
	id = "regenfed"
	desc = "You feel satiated, and are restoring over time."
	addedstacks = list("wellfed")

/datum/statuseffect/regenerate/removeStatus()
	mymob:healDamage(1)
	mymob:healMana(1)
	..()