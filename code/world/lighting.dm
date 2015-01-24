var/list/globalLightingUpdates = list()

/turf
	luminosity = 0 // this is byond's base luminosity, used for actual light level
	var/lightLevel = 0 // this is the level of light being projected onto a tile
	var/oldLight
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
		for(var/turf/T in (circle(src,totalLuminosity)))
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
	world << "- oldLight: [oldLight]"
	world << "- ignoresLighting: [ignoresLighting]"
	world << "- lightObj: [lightObj]"
	world << "- state: [lightObj.icon_state]"
	for(var/t in beingLit)
		world << "- beingLit by [t]"

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

/datum/controller/lighting/proc/gatherLit()
	var/list/newList = list()
	for(var/atom/a in globalLightingUpdates)
		if(a:beingLit)
			for(var/b in a:beingLit)
				if(!newList.Find(b:name))
					newList[b:name] = 1
				else
					newList[b:name] = newList[b:name] + 1
	return newList

/datum/controller/lighting/Stat()
	..()
	var/list/gathered = gatherLit()
	stat("== Lightsources ==")
	for(var/a in gathered)
		stat("	[a]: [gathered[a]]")

/datum/controller/lighting/New()
	for(var/turf/T in world.contents)
		T.updateLighting()

/datum/controller/lighting/doProcess()
	if(isRunning)
		for(var/turf/T in globalLightingUpdates)
			//if(T.luminosity + T.lightLevel < LIGHTING_MAX_STATES)
			if(!T.lightObj)
				T.lightObj = new(T)
			//if(T.lightLevel != T.oldLight)
			T.lightObj.icon_state = "[max(0,T.luminosity + T.lightLevel)]"

			T.lightLevel = T.lightLevel - T.oldLight
			if(!T.beingLit.len)
				--T.lightLevel
			T.oldLight = T.lightLevel

			if(T.lightLevel <= LIGHTING_MINIMUM_THRESHOLD)
				T.lightObj.icon_state = "0"
				globalLightingUpdates -= T