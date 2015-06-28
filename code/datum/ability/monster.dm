/datum/ability/taunt/web
	name = "Web Throw"
	beamIcon = "w_beam"

/datum/ability/assassinate/leap
	name = "Pounce"

/datum/ability/deathbeam/leer
	name = "Leer"
	abilityState = "r_beam"

/datum/ability/toxicthrow/spit
	name = "Toxic Spit"

/datum/ability/heal/lickwounds
	name = "Lick Wounds"

/datum/ability/assassinate/gore
	name = "Gore"

/datum/ability/assassinate/gore/Cast(var/mob/caster,var/mob/player/target)
	..()
	caster.Move(target)
	messageInfo("You feel an unbearable pain inside you!",target,caster)
	spawn(15)
		target.bloodSpray(target.dir,1,-abilityModifier/4)
		messageInfo("[caster] bursts fourth from your chest!",target,caster)
		for(var/datum/organ/O in target.playerOrgans)
			O.health -= rand(1,-abilityModifier)