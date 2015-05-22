/turf
	var/mineral = "iron"

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

// World floors

/turf/floor/outside
	icon_state = "grass1"

/turf/floor/outside/grass
	name = "Grass"

/turf/floor/outside/grass/New()
	..()
	icon_state = "grass[rand(1,4)]"

/turf/floor/outside/snow
	name = "Snow"

/turf/floor/outside/snow/New()
	..()
	icon_state = "snow[rand(1,3)]"

/turf/floor/outside/dirt
	name = "Dirt"

/turf/floor/outside/dirt/New()
	..()
	icon_state = "asteroid[rand(1,5)]"

/turf/floor/outside/dirt/lava
	name = "Ashen Dirt"

/turf/floor/outside/dirt/lava/New()
	..()
	icon_state = "ironsand[rand(1,15)]"

/turf/floor/outside/shimmering
	icon_state = "white"

//liquids

/turf/floor/outside/liquid
	name = "liquid"
	icon_state = "water"
	density = 1

/turf/floor/outside/liquid/water
	name = "Water"
	icon_state = "water"

/turf/floor/outside/liquid/lava
	name = "Lava"
	icon_state = "lava"

//world walls

/turf/wall/shimmering
	name = "Shimmering Wall"
	icon_state = "silver0"
	mineral = "silver"
	walltype = "silver"

/turf/wall/woodWall
	name = "Wooden Wall"
	icon_state = "wood0"
	mineral = "wood"
	walltype = "wood"