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
	desc = "Throws a chain at a target, dragging them to you."
	abilityRange = 8
	abilityModifier = 0
	abilityCooldown = 5*60
	abilityState = "shout"
	abilityIconSelf = /obj/effect/pow
	abilityIconTarget = /obj/effect/target

/datum/ability/taunt/Cast(var/mob/player/caster,var/target)
	var/atom/movable/AM = target
	if(AM)
		AM.throw_at(caster)
		caster.Beam(AM,time=15,icon_state="c_beam")
	..()