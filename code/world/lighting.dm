var/list/globalLightingUpdates = list()

/turf
	luminosity = 0 // this is byond's base luminosity, used for actual light level
	var/lightLevel = 0 // this is the level of light being projected onto a tile
	var/ignoresLighting = 0
	var/obj/darkness/lightObj //holds the darkness overlays
	var/list/beingLit = list()

/turf/proc/updateLighting()
	if(!ignoresLighting)
		globalLightingUpdates |= src

/atom/movable/proc/updateLighting()
	var/totalLuminosity = 0
	totalLuminosity += luminosity
	for(var/obj/I in contents)
		if(I.luminosity > 0)
			totalLuminosity += I.luminosity
	var/inverseCounter = 0
	for(totalLuminosity; totalLuminosity > 0; --totalLuminosity)
		for(var/turf/T in view(totalLuminosity,src))
			var/lumcount = min(LIGHTING_MAX_STATES,T.lightLevel + inverseCounter)
			if(T.lightLevel < lumcount)
				T.lightLevel = lumcount
				T.beingLit |= src
				T.updateLighting()
		inverseCounter++

/turf/verb/examineLightData()
	set src in range(32)
	world << "Debugging Light of [src]"
	world << "- lightLevel: [lightLevel]"
	world << "- ignoresLighting: [ignoresLighting]"
	world << "- lightObj: [lightObj]"
	world << "- state: [lightObj.icon_state]"
	for(var/t in beingLit)
		world << "- beingLit by [t]"

/obj/darkness
	name = "darkness"
	desc = "What lurks here?"
	icon = 'sprite/world/lighting_iso.dmi'
	mouse_opacity = 0
	layer = LAYER_LIGHTING
	anchored = TRUE

/datum/controller/lighting
	var/lightingIcon = 'sprite/world/lighting_iso.dmi'

/datum/controller/lighting/New()
	for(var/turf/T in world.contents)
		T.updateLighting()

/datum/controller/lighting/doProcess()
	if(isRunning)
		for(var/turf/T in globalLightingUpdates)
			//if(T.luminosity + T.lightLevel < LIGHTING_MAX_STATES)
			if(!T.lightObj)
				T.lightObj = new(T)
			T.lightObj.icon_state = "[T.luminosity + T.lightLevel][(T.density || T.contents.len > 1) ? "_d" : ""]"

			var/list/nearby = range(LIGHTING_MAX_STATES/2,T)
			for(var/atom/A in T.beingLit)
				if(!locate(A) in nearby)
					T.beingLit.Remove(A)

			if(T.lightLevel >= 0 && !T.beingLit.len)
				if(prob(LIGHTING_DECAY_RATE))
					T.lightLevel--

			if(T.lightLevel <= LIGHTING_MINIMUM_THRESHOLD && !T.beingLit.len)
				globalLightingUpdates.Remove(T)