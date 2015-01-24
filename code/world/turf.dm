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
	icon_state = "gold0"
	mineral = "gold"
	walltype = "gold"

/turf/floor/lobbyFloor
	name = "Lobby Floor"
	icon_state = "gold"

/turf/floor/voidFloor
	name = "Void Space"
	icon_state = "black"
	density = 1
	opacity = 1
	ignoresLighting = 1