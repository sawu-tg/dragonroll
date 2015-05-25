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
	density = 0
	var/damage = 0
	var/damageVerb = ""
	var/minDamDepth = 0
	var/depth = 5 //1 - 100

/turf/floor/outside/liquid/New()
	..()
	depth = rand(1,100)

/turf/floor/outside/liquid/proc/updateDepth()
	alpha = 255 - depth*2

/turf/floor/outside/liquid/Enter(atom/movable/O)
	if(istype(O,/mob/player))
		var/mob/player/P = O
		if(P.playerData.dex.statCur-P.weight >= depth)
			return 1
		else
			displayTo("[src] is too deep for you to wade in! ([P.playerData.dex.statCur-P.weight] v [depth])",P,src)
			return 0
	else
		return 1

/turf/floor/outside/liquid/Entered(atom/movable/O)
	if(damage > 0 && depth >= minDamDepth)
		if(istype(O,/mob/player))
			var/mob/player/P = O
			//
			var/calcDepth = (depth + P.weight)-(P.playerData.dex.statCur + P.playerData.str.statCur)
			//
			if(calcDepth >= minDamDepth)
				P.inDPSLiquid = TRUE
				P.liquidVerb = damageVerb
				P.liquidDamage = damage

/turf/floor/outside/liquid/Exited(atom/movable/O)
	if(damage > 0 && depth >= minDamDepth)
		if(istype(O,/mob/player))
			var/mob/player/P = O
			P.inDPSLiquid = FALSE
			P.liquidVerb = ""
			P.liquidDamage = 0

/turf/floor/outside/liquid/water
	name = "Water"
	icon_state = "water"
	damage = 1
	damageVerb = "drowning"
	minDamDepth = 35

/turf/floor/outside/liquid/lava
	name = "Lava"
	icon_state = "lava"
	damage = 1
	damageVerb = "burning"

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