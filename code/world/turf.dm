/turf
	var/mineral = "iron"
	var/ambient_factor = 0

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
	ambient_factor = 1

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

#define LIQUIDCOST_CARDINAL 1 * 15
#define LIQUIDCOST_DIAGONAL 1.7 * 15

/turf/floor/outside/liquid
	name = "liquid"
	var/solidName = "liquidSolid"
	icon_state = "water"
	density = 0
	var/solid = 0
	var/damage = 0
	var/damageVerb = ""
	var/minDamDepth = 0
	var/depth = 5 //1 - 100

/turf/floor/outside/liquid/New()
	..()
	depth = rand(1,100)

/turf/floor/outside/liquid/proc/updateErodeDepth()
	if(!src || !istype(src,/turf/floor/outside/liquid))
		return

	var/surrounddepth = 9999999

	for(var/d in alldirs)
		var/turf/floor/outside/liquid/T = get_step(src,d)

		var/cost = LIQUIDCOST_DIAGONAL
		if(d in cardinal)
			cost = LIQUIDCOST_CARDINAL

		if(T)
			if(!istype(T))
				surrounddepth = min(surrounddepth,5)
			else
				surrounddepth = min(surrounddepth,T.depth+cost)

	depth = surrounddepth
	updateDepth()

/turf/floor/outside/liquid/proc/updateDepth()
	alpha = max(50,255 - depth*2)
	if(solid)
		name = solidName
		icon_state = "[initial(icon_state)]_solid"
	else
		name = initial(name)
		icon_state = "[initial(icon_state)]"

/turf/floor/outside/liquid/Enter(atom/movable/O)
	if(istype(O,/mob/player))
		var/mob/player/P = O
		if(solid)
			if(P.playerData.dex.statCur-P.weight <= depth)
				displayTo("You lose your balance and fall on [src], cracking it! ([P.playerData.dex.statCur-P.weight] v [depth])",P,src)
				for(var/turf/floor/outside/liquid/L in range(src,1))
					L.solid = 0
					L.updateDepth()
				P.stun(depth*15)
			return 1
		if(P.playerData.dex.statCur-P.weight >= depth)
			return 1
		else
			displayTo("[src] is too deep for you to wade in! ([P.playerData.dex.statCur-P.weight] v [depth])",P,src)
			return 0
	else
		return 1

/turf/floor/outside/liquid/Entered(atom/movable/O)
	if(solid)
		return
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
	if(solid)
		return
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

/turf/floor/outside/liquid/pit //what even does this mean :^)
	name = "Pit"
	icon_state = "asteroid1"
	color = "#999999"

/turf/floor/outside/liquid/pit/New()
	..()
	icon_state = "asteroid[rand(1,5)]"

/turf/floor/outside/liquid/water/ice
	solidName = "Ice"
	icon_state = "water"
	damage = 1
	solid = 1
	damageVerb = "drowning"
	minDamDepth = 35

/turf/floor/outside/liquid/lava
	name = "Lava"
	icon_state = "lava"
	damage = 1
	damageVerb = "burning"

	New()
		..()

		set_light(2,1,"#FF5500")

	Del()
		set_light(0)

//world walls

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