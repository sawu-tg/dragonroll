var/list/globalLightingUpdates = list()

/atom
	var/lightColor = "black"
	var/list/litWhat = list()

/turf
	luminosity = 0 // this is byond's base luminosity, used for actual light level
	var/lightLevel = 0 // this is the level of light being projected onto a tile
	var/expectedLight = 0
	var/expectedColor
	var/oldLight = -1
	var/ignoresLighting = 0
	var/obj/darkness/lightObj //holds the darkness overlays
	var/needsUpdate = TRUE
	var/list/litBy = list()

/mob/New()
	..()
	lightColor = rgb(rand(1,255),rand(1,255),rand(1,255))

/turf/proc/updateLighting()
	if(!ignoresLighting)
		needsUpdate = TRUE
		globalLightingUpdates |= src

/atom/movable/proc/updateLighting()
	if(isRunningSafe("Lighting"))
		var/totalLuminosity = 0
		totalLuminosity += luminosity
		for(var/obj/I in contents)
			if(I.luminosity > 0)
				totalLuminosity += I.luminosity
				lightColor = I.lightColor + lightColor
		var/inverseCounter = 0
		var/list/around = range(8,src)
		for(var/atom/A in litWhat)
			if(!around.Find(A))
				litWhat -= A
		for(totalLuminosity; totalLuminosity > 0; --totalLuminosity)
			for(var/turf/T in (circle(src,totalLuminosity)))
				T.expectedLight = 0
				var/lumcount = inverseCounter
				if(T.lightLevel < lumcount)
					if(!T.litBy[src])
						if(!litWhat.Find(T))
							litWhat += T
						T.litBy[src] = min(LIGHTING_MAX_STATES,lumcount)
					T.expectedColor = lightColor
					T.updateLighting()
			inverseCounter++

/turf/proc/gatherLightData()
	var/tr = 0
	for(var/atom/A in litBy)
		tr += litBy[A]
	return tr

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
	for(var/atom/A in litBy)
		world << "Lit by: [A]"

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
	isRunning = FALSE
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
				T.expectedLight = T.gatherLightData()
				if(T.lightLevel < T.expectedLight)
					T.lightLevel = min(LIGHTING_MAX_STATES,T.lightLevel + 1)
				else if(T.litBy.len <= 0)
					T.lightLevel = max(0,T.lightLevel - 1)
				T.lightObj.icon_state = "[max(0,T.lightLevel)]"
				if(T.expectedColor)
					T.lightObj.color = T.expectedColor
				T.oldLight = T.lightLevel
				if(T.lightLevel <= LIGHTING_MINIMUM_THRESHOLD)
					T.lightObj.color = "black"
					T.expectedColor = "black"
					T.needsUpdate = FALSE
					T.luminosity = 0
					globalLightingUpdates -= T