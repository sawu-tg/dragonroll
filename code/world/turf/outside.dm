///
// FLOORS
///

/turf/floor/outside
	icon_state = "grass1"
	ambient_factor = 1

/turf/floor/outside/grass
	name = "Grass"
	useNaturalTiling = TRUE
	var/datum/material/grassMaterial = new/datum/material/grass1
	edge_weight = 1

/turf/floor/outside/grass/New()
	..()
	icon_state = "grassf[rand(1,4)]"
	update_icon()
	generate_edges()

/turf/floor/outside/grass/update_icon()
	color = grassMaterial.color

/turf/floor/outside/snow
	name = "Snow"
	useNaturalTiling = TRUE
	edge_weight = 2

/turf/floor/outside/snow/New()
	..()
	icon_state = "snow[rand(1,3)]"
	generate_edges()

/turf/floor/outside/dirt
	name = "Dirt"
	useNaturalTiling = TRUE
	edge_weight = 3

/turf/floor/outside/dirt/New()
	..()
	icon_state = "asteroid[rand(1,5)]"
	generate_edges()

/turf/floor/outside/dirt/lava
	name = "Ashen Dirt"

/turf/floor/outside/dirt/lava/New()
	..()
	icon_state = "ironsand[rand(1,15)]"

/turf/floor/outside/shimmering
	icon_state = "freezerfloor"

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