/datum/ability/movement
	name = "movement ability"
	abilityRange = 0
	abilityModifier = 0
	abilityCooldown = 30
	abilityProjectiles = 8
	abilityState = "Dodge"
	abilitySelfCast = TRUE
	var/travel_icon = 'sprite/mob/mob.dmi'
	var/travel_state = "reappear"
	var/cost = 0 // mana cost per tick
	var/trailIcon
	var/trailState

/obj/vehicle/movementSpell
	name = ""
	desc = ""
	var/count = 15
	vehicleFlags = VEHICLE_PASS_ANY
	maxSteps = 30
	hidesPlayer = TRUE
	locksPlayerIn = TRUE
	noMessage = TRUE
	trailType = /obj/effect/sparks


/obj/vehicle/movementSpell/New(var/turf/T, var/asIcon, var/asState, var/target)
	..(T)
	icon_state = asState
	icon = asIcon
	addProcessingObject(src)

/obj/vehicle/movementSpell/doProcess()
	dir = driver.dir
	driver.Move(get_step(src,dir))

/obj/vehicle/movementSpell/garbageCleanup()
	Eject(driver)
	for(var/A in passengers)
		Eject(A)
	..()

/datum/ability/movement/Cast(var/mob/player/caster,var/target)
	..(caster,target)
	var/turf/toTurf = get_turf(target)
	var/obj/vehicle/movementSpell/MS = new(get_turf(caster),travel_icon,travel_state,toTurf)
	if(trailIcon && trailState)
		MS.trailIcon = trailIcon
		MS.trailState = trailState
	MS.EnterVehicle(caster)

///
// MOVEMENT SPELLS
///

/datum/ability/movement/Charge
	name = "Charge-Slide"
	travel_icon = 'sprite/mob/mob.dmi'
	travel_state = "phaseout"

/datum/ability/movement/WispForm
	name = "Wisp Form"
	travel_icon = 'sprite/obj/projectiles.dmi'
	travel_state = "magicm"
	trailIcon = 'sprite/obj/projectiles.dmi'
	trailState = "magicm"

/datum/ability/movement/Cloud
	name = "Cloud Form"
	travel_icon = 'sprite/obj/tg_effects/effects.dmi'
	travel_state = "extinguish"
	trailIcon = 'sprite/obj/tg_effects/effects.dmi'
	trailState = "extinguish"

/datum/ability/movement/Dash
	name = "Dash"
	travel_icon = 'sprite/obj/tg_effects/effects.dmi'
	travel_state = "blank"
	trailIcon = 'sprite/obj/tg_effects/effects.dmi'
	trailState = "blank"