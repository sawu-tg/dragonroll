/turf
	var/mineral = "iron"
	var/ambient_factor = 0
	luminosity = 1

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

//liquids

#define LIQUIDCOST_CARDINAL 1 * 15
#define LIQUIDCOST_DIAGONAL 1.7 * 15

/turf/floor/outside/liquid
	name = "liquid"
	var/solidName = "liquidSolid"
	icon_state = "water"
	density = 0
	layer = TURF_LAYER - 0.2
	var/corrosive = FALSE // does it burn through vehicles?
	var/solid = 0
	var/damage = 0
	var/damageVerb = ""
	var/minDamDepth = 0
	var/depth = 5 //1 - 100
	var/liquidopacity = 128

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
	//alpha = max(50,255 - depth*2)
	var/color_a = max(50,255 - depth*4)
	color_a = 255 - depth*4
	//color = rgb(color_a,color_a,color_a)

	overlays.Cut()
	//underlays.Cut()

	var/image/I = image(icon,src,icon_state)
	I.layer = layer+0.2
	I.color = color
	I.alpha = liquidopacity
	I.pixel_z = depth

	var/image/I2 = image(icon,src,"asteroid1")
	I2.layer = layer+0.1
	I2.pixel_z = 0
	I2.color = rgb(color_a,color_a,color_a)

	var/image/I3 = image(icon,src,"asteroid1")
	I3.layer = layer
	I3.pixel_y = 32
	I3.color = rgb(color_a*0.5,color_a*0.5,color_a*0.5)

	/*var/image/I3 = image(icon,src,"asteroid1")
	I3.pixel_z = -32
	I3.pixel_y = 64
	I3.color = rgb(color_a*0.5,color_a*0.5,color_a*0.5)*/

	//alpha = 255

	//var/image/I2 = image(icon,src,"asteroid1")
	//I2.color = rgb(128,128,128)
	//I2.pixel_z = -depth-32

	//underlays += I3
	overlays += I3
	overlays += I2
	overlays += I


	if(solid)
		name = solidName
		icon_state = "[initial(icon_state)]_solid"
	else
		name = initial(name)
		icon_state = "[initial(icon_state)]"

	pixel_z = -depth

/turf/floor/outside/liquid/Enter(atom/movable/O)
	if(istype(O,/mob/player))
		var/mob/player/P = O
		if(P.mounted)
			//always allow mounted people to pass, the mounts handle passing
			return 1
		if(solid)
			if(P.playerData.dex.statCurr-P.weight <= depth)
				displayTo("You lose your balance and fall on [src], cracking it! ([P.playerData.dex.statCurr-P.weight] v [depth])",P,src)
				for(var/turf/floor/outside/liquid/L in range(src,1))
					L.solid = 0
					L.updateDepth()
				P.stun(depth*15)
			return 1
		if(P.playerData.dex.statCurr-P.weight >= depth)
			return 1
		else
			displayTo("[src] is too deep for you to wade in! ([P.playerData.dex.statCurr-P.weight] v [depth])",P,src)
			return 1
	else
		return 1

/turf/floor/outside/liquid/Entered(atom/movable/O)
	if(solid)
		return
	if(damage > 0 && depth >= minDamDepth)
		//world << "Entered"
		if(istype(O,/mob/player))
			var/mob/player/P = O
			//
			var/calcDepth = (depth + P.weight)-(P.playerData.dex.statCurr + P.playerData.str.statCurr)
			//
			if(calcDepth >= minDamDepth && !P.mounted)
				var/datum/statuseffect/drowning/DReffect = P.addStatusEffect(/datum/statuseffect/drowning)
				if(DReffect)
					DReffect.setTile(src)
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
	minDamDepth = 15

/turf/floor/outside/liquid/pit //what even does this mean :^)
	name = "Pit"
	icon_state = "asteroid1"
	color = "#999999"
	liquidopacity = 0
	corrosive = TRUE

/turf/floor/outside/liquid/pit/New()
	..()
	icon_state = "asteroid[rand(1,5)]"

/turf/floor/outside/liquid/water/ice
	solidName = "Ice"
	icon_state = "water"
	damage = 1
	solid = 1
	damageVerb = "drowning"
	minDamDepth = 15

/turf/floor/outside/liquid/lava
	name = "Lava"
	icon_state = "lava"
	damage = 1
	damageVerb = "burning"
	liquidopacity = 200
	corrosive = TRUE

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