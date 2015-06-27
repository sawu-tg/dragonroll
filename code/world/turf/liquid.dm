///
// LIQUIDS
///

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
	var/slippery = FALSE
	var/damage = 0
	var/damageVerb = ""
	var/minDamDepth = 0
	var/depth = 5 //1 - 100
	var/liquidopacity = 128
	var/docile = 0

/turf/floor/outside/liquid/New()
	..()
	depth = rand(1,100)

/turf/floor/outside/liquid/proc/updateErodeDepth()
	if(!src || !istype(src,/turf/floor/outside/liquid))
		return

	var/surrounddepth = 9999999
	var/list/tiles_to_activate = list()

	for(var/d in alldirs)
		var/turf/floor/outside/liquid/T = get_step(src,d)

		var/cost = LIQUIDCOST_DIAGONAL
		if(d in cardinal)
			cost = LIQUIDCOST_CARDINAL

		if(T)
			if(!istype(T))
				surrounddepth = min(surrounddepth,5)
				break
			else
				surrounddepth = min(surrounddepth,T.depth+cost)
				tiles_to_activate |= T

	if(depth != surrounddepth)
		for(var/turf/floor/outside/liquid/T in tiles_to_activate)
			T.docile = 0
	else
		docile++

		if(docile >= 2)
			updateDepth()
			erodeLiquids -= src

	depth = surrounddepth

/turf/floor/outside/liquid/proc/updateDepth()
	var/color_a = max(50,255 - depth*4)
	color_a = 255 - depth*4
	overlays.Cut()

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
			if(P.playerData.dex.statModified-P.weight <= depth)
				messagePlayer("You lose your balance and fall on [src], cracking it! ([P.playerData.dex.statCurr-P.weight] v [depth])",P,src)
				for(var/turf/floor/outside/liquid/L in range(src,1))
					L.solid = 0
					L.updateDepth()
				if(!P.isSliding)
					P.stun(depth*15)
			return 1
		if(P.playerData.dex.statModified-P.weight >= depth)
			return 1
		else
			messagePlayer("[src] is too deep for you to wade in! ([P.playerData.dex.statCurr-P.weight] v [depth])",P,src)
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
			var/calcDepth = (depth + P.weight)-(P.playerData.dex.statCurr + P.playerData.str.statCurr)
			//
			if(calcDepth >= minDamDepth && !P.mounted)
				var/datum/statuseffect/suffocating/DReffect = P.addStatusEffect(/datum/statuseffect/suffocating)
				if(DReffect)
					//world << "Drowning in [src]"
					DReffect.setTile(src)
					P.inDPSLiquid = TRUE
					P.liquidVerb = damageVerb
					P.liquidDamage = damage

/turf/floor/outside/liquid/Exited(atom/movable/O)
	if(solid)
		return
	if(istype(O.loc,/turf/floor/outside/liquid))
		return
	if(istype(O,/mob/player))
		var/mob/player/P = O
		if(damage > 0 && depth >= minDamDepth)
			P.inDPSLiquid = FALSE
			P.liquidVerb = ""
			P.liquidDamage = 0
		P.isSliding = FALSE

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
	slippery = TRUE
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
