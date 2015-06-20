///
// TEST SPELLS
///


///
// ASSASSIN SPELLS
///

/datum/ability/assassinate
	name = "Assassinate"
	desc = "Teleports you to the target, dealing a large amount of damage"
	abilityRange = 4
	abilityModifier = -5
	abilityCooldown = 25*60
	abilityState = "duel"
	abilityIconSelf = /obj/effect/pow
	abilityIconTarget = /obj/effect/strike
	abilityHitsPlayers = TRUE

/datum/ability/assassinate/Cast(var/mob/player/caster,var/target)
	caster.loc = target:loc
	..()

///
// MANAWEAVER SPELLS
///

/datum/ability/manablast
	name = "Mana Blast"
	desc = "Shoots a ball of pure mana."
	abilityRange = 8
	abilityModifier = -2
	abilityCooldown = 10*60
	abilityState = "redline"
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/manablast
	abilityIconTarget = /obj/effect/target

///
// HUNTER SPELLS
///

/datum/ability/slowbolt
	name = "Slowing Bolt"
	desc = "Fires a bolt that slows a target."
	abilityRange = 8
	abilityModifier = -1
	abilityCooldown = 10*60
	abilityState = "staff"
	abilityEffect = /datum/statuseffect/dazed
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/manablast
	abilityIconTarget = /obj/effect/target

///
// HERBALIST SPELLS
///

/datum/ability/toxicthrow
	name = "Toxin Throw"
	desc = "Flings a toxic sludge at the target."
	abilityRange = 8
	abilityModifier = -1
	abilityCooldown = 10*60
	abilityState = "staff"
	abilityEffect = /datum/statuseffect/poison
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/toxinthrow
	abilityIconTarget = /obj/effect/target

///
// BLACK MAGE SPELLS
///


/datum/ability/deathbeam
	name = "Death Beam"
	desc = "Charges a target with entropy, binding them, and then forcefully blowing them backwards."
	abilityRange = 8
	abilityModifier = -2
	abilityCooldown = 3*60
	abilityState = "d_beam"
	abilityIconSelf = /obj/effect/pow
	abilityIconTarget = /obj/effect/target

/datum/ability/deathbeam/Cast(var/mob/player/caster,var/target)
	var/atom/movable/AM = target
	if(AM)
		AM.anchored = 1
		caster.Beam(AM,time=15,icon_state=abilityState)
		for(var/turf/T in range(1,AM))
			if(prob(85))
				var/obj/effect/sparks/EM = new/obj/effect/sparks(get_turf(caster))
				if(EM)
					walk_to(EM,T)
		AM.anchored = 0
		AM.throw_at(GetPath(AM,caster.dir))
	..()