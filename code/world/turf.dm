/turf
	var/mineral = "iron"

/turf/floor
	icon = 'sprite/world/floors.dmi'
	icon_state = "floor"

/turf/wall
	icon = 'sprite/world/walls.dmi'
	icon_state = "0"
	density = 0
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

// World floors

/turf/floor/outside
	icon_state = "grass1"

/turf/floor/outside/grass
	name = "Grass"

/turf/floor/outside/grass/New()
	..()
	icon_state = "grass[rand(1,4)]"

/turf/floor/outside/dirt
	name = "Dirt"

/turf/floor/outside/dirt/New()
	..()
	icon_state = "asteroid[rand(0,4)]"

/turf/floor/outside/water
	name = "Water"
	icon_state = "water"
	density = 1

//world walls

/turf/wall/shimmering
	name = "Shimmering Wall"
	icon_state = "silver0"
	mineral = "silver"
	walltype = "silver"