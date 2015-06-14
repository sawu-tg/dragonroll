///
// FLOORS
///

/turf/floor/outside
	icon_state = "grass1"
	ambient_factor = 1

/turf/floor/outside/grass
	name = "Grass"
	var/datum/material/grassMaterial = new/datum/material/grass1

/turf/floor/outside/grass/New()
	..()
	icon_state = "grassf[rand(1,4)]"
	update_icon()

/turf/floor/outside/grass/proc/update_icon()
	color = grassMaterial.color

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

///
// WALLS
///

/turf/wall/shimmering
	name = "Shimmering Wall"
	icon_state = "silver0"
	mineral = "silver"
	walltype = "silver"
	ambient_factor = 1

/turf/wall/woodWall
	name = "Wooden Wall"
	icon_state = "wood0"
	mineral = "wood"
	walltype = "wood"
	ambient_factor = 1