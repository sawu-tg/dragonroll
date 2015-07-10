/datum/ability/heal
	name = "Heal"
	desc = "Heals a target"
	abilityRange = 8
	abilityModifier = 5
	abilityCooldown = 15
	abilityProjectiles = 8
	abilityState = "redcross"
	abilityProjectile = /obj/projectile/healingblast
	abilityIconTarget = /obj/effect/heal

///
// DEFENDER SPELLS
///

/datum/ability/taunt
	name = "Chain-Throw"
	desc = "Throws a chain at a target, dragging them to you."
	abilityRange = 8
	abilityModifier = -1
	abilityCooldown = 10
	abilityState = "shout"
	abilityHitsPlayers = TRUE
	abilityProjectile = /obj/projectile/spear
	abilityIconTarget = /obj/effect/target
	var/beamIcon = "c_beam"

/datum/ability/taunt/Cast(var/mob/player/caster,var/target)
	..()
	var/atom/movable/AM = target
	if(AM)
		caster.Beam(abilityCastedProjectile,time=15,icon_state=beamIcon)