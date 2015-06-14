/turf
	var/mineral = "iron"
	var/ambient_factor = 0
	luminosity = 1
	var/turfCreeps = FALSE // does the turf slowly spread over time?
	var/maxCreeps = 8 // maximum times this turf can creep
	var/creepRate = 60
	var/list/nearby

/turf/New()
	if(turfCreeps)
		spawn(creepRate)
			nearby = range(1,src)
			for(var/turf/T in nearby)
				if(T.type == src.type)
					maxCreeps--
			if(maxCreeps > 0)
				addProcessingObject(src)
	..()

/turf/doProcess()
	if(maxCreeps > 0 && turfCreeps)
		if(creepRate > 0)
			--creepRate
		else
			creepRate = initial(creepRate)
			--maxCreeps
			var/turf/T = get_turf(pick(nearby))
			if(T)
				if(!istype(T.type,src.type))
					var/turf/S = new src.type(T)
					S.maxCreeps = initial(maxCreeps) - 1
	else
		remProcessingObject(src)

/turf/floor
	icon = 'sprite/world/floors.dmi'
	icon_state = "floor"

/turf/wall
	icon = 'sprite/world/walls.dmi'
	icon_state = "0"
	density = 1
	opacity = 1
	anchored = 1
	var/walltype = "metal"

/turf/wall/lobbyWall
	name = "Lobby Wall"
	icon_state = "wood0"
	mineral = "wood"
	walltype = "wood"

/turf/floor/lobbyFloor
	name = "Lobby Floor"
	icon_state = "wood"

/turf/floor/voidFloor
	name = "Void Space"
	icon_state = "black"
	density = 1
	opacity = 1


//End of default floors