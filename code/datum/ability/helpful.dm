/datum/ability/heal
	name = "Heal"
	desc = "Heals a target"
	abilityRange = 8
	abilityModifier = 1
	abilityCooldown = 1*60
	abilityState = "redcross"
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/healingblast
	abilityIconTarget = /obj/effect/heal

///
// DEFENDER SPELLS
///

/datum/ability/taunt
	name = "Taunt"
	desc = "Taunts a target to attack you."
	abilityRange = 8
	abilityModifier = 0
	abilityCooldown = 5*60
	abilityState = "shout"
	abilityHitsPlayers = TRUE
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/taunt
	abilityIconTarget = /obj/effect/target