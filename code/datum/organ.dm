/datum/organ
	var/name = "piece of human"
	var/desc = "why"
	var/internal = FALSE // does not show on player icon rebuilding
	var/icon = 'sprite/mob/human.dmi' // icon the organ displays
	var/icon_state = "l_arm" // icon state the organ displays
	var/health = 100 // health of the organ
	var/datum/race/race
	var/mob/owner

/datum/organ/New(var/asrace,var/toOwner)
	..()
	race = asrace
	if(toOwner)
		owner = toOwner
	if(fexists("sprite/mob/dismemberment/r_def_[lowertext(race.raceName)].dmi"))
		icon = file("sprite/mob/dismemberment/r_def_[lowertext(race.raceName)].dmi")
	else
		world << "<b>INVALID:</b> sprite/mob/dismemberment/r_def_[lowertext(race.raceName)].dmi"

/mob/player/verb/debugOrgans()
	set category = "Debug Verbs"
	for(var/datum/organ/O in playerOrgans)
		world << "[name]'s [O.name]"
		world << "sprite/mob/dismemberment/r_def_[lowertext(O.race.raceName)].dmi"
		var/icon/i = icon(O.icon,O.icon_state)
		world << "\icon[i]"
		world << "[O.icon_state]"

/mob/player/verb/gibSelf()
	set name = "Gib"
	set desc = "Auto gibs you"
	set src = usr
	for(var/datum/organ/O in playerOrgans)
		O.gib(src)
		playerOrgans -= O

/datum/organ/proc/gib(var/where)
	var/obj/item/organ/O = new/obj/item/organ(get_turf(where))
	O.createFrom(src)
	O.throw_at(pick(orange(where,3)))

/obj/item/organ
	name = "organ"
	desc = "tasty"
	itemMaterial = new/datum/material/flesh

/obj/item/organ/proc/createFrom(var/datum/organ/of)
	name = "[of.race.raceName] [of.name]"
	desc = of.desc
	icon = of.icon
	icon_state = of.icon_state

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
	gib(get_turf(owner))


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
	icon_state = "l_arm"

/datum/organ/r_arm
	name = "right arm"
	desc = "righty tighty, lefty loosey"
	icon_state = "r_arm"

/datum/organ/l_leg
	name = "left leg"
	desc = "the left beats the rest"
	icon_state = "l_leg"

/datum/organ/r_leg
	name = "right leg"
	desc = "righty tighty, lefty loosey"
	icon_state = "r_leg"

/datum/organ/chest
	name = "chest"
	desc = "aim for this"
	icon_state = "torso_m"

/datum/organ/head
	name = "head"
	desc = "most things go to this"
	icon_state = "head"