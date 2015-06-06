/datum/ability/bolster
	name = "Bolster"
	desc = "Increases the HP and DEF of nearby units."
	abilityRange = 8
	abilityModifier = 2
	abilityCooldown = 5*60
	abilityState = "shout"
	abilityHitsPlayers = TRUE
	abilityIconSelf = /obj/effect/pow
	abilityIconTarget = /obj/effect/aoe_tile/bolster
	abilityAoe = -2