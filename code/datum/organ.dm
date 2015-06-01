/datum/organ
	var/name = "piece of human"
	var/desc = "why"
	var/internal = FALSE // does not show on player icon rebuilding
	var/icon = 'sprite/mob/human.dmi' // icon the organ displays
	var/icon_state = "l_arm" // icon state the organ displays
	var/health = 100 // health of the organ

///
// What the organ does, called on a mob's process
///
/datum/organ/proc/organProc()
	if(health <= 0)
		organFail()
		return 0
	return 1 // return 1 for success, 0 for organ failiure
///
// When an organ fails, this is called
///
/datum/organ/proc/organFail()


//organs
/datum/organ/brain
	name = "brain"
	desc = "me thinkum good"
	internal = TRUE

/datum/organ/brain/organFail()
	//makem dem dum
	..()

/datum/organ/heart
	name = "heart"
	desc = "9/10 are probably broken"
	internal = TRUE

/datum/organ/heart/organFail()
	//makem dem ded
	..()

/datum/organ/l_arm
	name = "left arm"
	desc = "the left beats the rest"

/datum/organ/r_arm
	name = "right arm"
	desc = "righty tighty, lefty loosey"

/datum/organ/l_leg
	name = "left leg"
	desc = "the left beats the rest"

/datum/organ/r_leg
	name = "right leg"
	desc = "righty tighty, lefty loosey"

/datum/organ/chest
	name = "chest"
	desc = "aim for this"

/datum/organ/head
	name = "head"
	desc = "most things go to this"