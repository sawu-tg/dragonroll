/datum/ability/movement
	name = "movement ability"
	abilityRange = 16
	abilityModifier = 0
	abilityCooldown = 30
	abilityProjectiles = 8
	abilityState = "dodge"

	var/travel_icon = 'sprite/mob/mob.dmi'
	var/travel_state = "reappear"
	var/cost = 0 // mana cost per tick

/obj/vehicle/movementSpell
	name = "Magical Transport"
	desc = "Something is moving very fast!"
	vehicleFlags = VEHICLE_PASS_ANY
	maxSteps = 30

/obj/vehicle/movementSpell/New(var/turf/T, var/asIcon, var/asState, var/target)
	..(T)
	icon_state = asState
	icon = asIcon

/obj/vehicle/movementSpell/garbageCleanup()
	Eject(driver)
	for(var/A in passengers)
		Eject(A)
	..()

/datum/ability/movement/Cast(var/mob/player/caster,var/target)
	..(caster,target)
	var/turf/toTurf = get_turf(target)
	var/obj/vehicle/movementSpell/MS = new(get_turf(caster),travel_icon,travel_state,toTurf)
	MS.EnterVehicle(caster)