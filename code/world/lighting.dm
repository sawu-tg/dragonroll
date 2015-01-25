var/list/globalLightingUpdates = list()

/atom
	var/lightColor = "black"

/turf
	luminosity = 0 // this is byond's base luminosity, used for actual light level
	var/lightLevel = 0 // this is the level of light being projected onto a tile
	var/expectedLight = 0
	var/expectedColor
	var/oldLight
	var/ignoresLighting = 0
	var/obj/darkness/lightObj //holds the darkness overlays
	var/needsUpdate = TRUE

/mob/New()
	..()
	lightColor = rgb(rand(1,255),rand(1,255),rand(1,255))

/turf/proc/updateLighting()
	if(!ignoresLighting)
		needsUpdate = TRUE
		globalLightingUpdates |= src

/atom/movable/proc/updateLighting()
	var/totalLuminosity = 0
	totalLuminosity += luminosity
	for(var/obj/I in contents)
		if(I.luminosity > 0)
			totalLuminosity += I.luminosity
			lightColor = I.lightColor + lightColor
	var/inverseCounter = 0
	for(totalLuminosity; totalLuminosity > 0; --totalLuminosity)
		for(var/turf/T in (circle(src,totalLuminosity)))
			var/lumcount = min(LIGHTING_MAX_STATES,T.lightLevel + inverseCounter)
			if(T.lightLevel < lumcount)
				T.expectedLight = lumcount
				T.expectedColor = lightColor
				T.updateLighting()
		inverseCounter++

/turf/verb/examineLightData()
	set src in range(32)
	world << "Debugging Light of [src]"
	world << "- lightLevel: [lightLevel]"
	world << "- oldLight: [oldLight]"
	world << "- expectedLighting: [expectedLight]"
	world << "- ignoresLighting: [ignoresLighting]"
	world << "- lightObj: [lightObj]"
	world << "- expectedColor: <font color=[expectedColor]>[expectedColor]</font> (actual: [lightObj.color])"
	world << "- state: [lightObj.icon_state]"
	world << "- processing: [globalLightingUpdates.Find(src) ? "true" : "false"]"

/obj/darkness
	name = "darkness"
	desc = "What lurks here?"
	icon = 'sprite/world/lighting.dmi'
	mouse_opacity = 0
	layer = LAYER_LIGHTING
	anchored = TRUE

/datum/controller/lighting
	name = "Lighting"
	execTime = 1
	var/lightingIcon = 'sprite/world/lighting.dmi'

/datum/controller/lighting/New()
	for(var/turf/T in world.contents)
		T.updateLighting()

/datum/controller/lighting/doProcess()
	if(isRunning)
		for(var/turf/T in globalLightingUpdates)
			if(T.needsUpdate)
				if(!T.lightObj)
					T.lightObj = new(T)
				T.lightLevel = T.expectedLight - T.oldLight
				T.lightObj.icon_state = "[max(0,T.luminosity + T.lightLevel)]"
				if(T.expectedColor)
					T.lightObj.color = T.expectedColor
				T.oldLight = T.lightLevel
				T.expectedLight = 0
				if(T.lightLevel <= LIGHTING_MINIMUM_THRESHOLD)
					T.lightObj.color = "black"
					T.expectedColor = "black"
					T.needsUpdate = FALSE
					globalLightingUpdates -= T