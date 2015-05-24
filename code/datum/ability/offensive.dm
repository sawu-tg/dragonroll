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
	abilityState = "staff"
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
	abilityEffect = ACTIVE_STATE_DAZED
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
	abilityEffect = ACTIVE_STATE_POISONED
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/toxinthrow
	abilityIconTarget = /obj/effect/target