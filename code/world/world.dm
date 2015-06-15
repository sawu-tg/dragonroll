var/list/procObjects = list()
var/list/cooldownHandler = list()
var/list/globalSuns = list()
var/list/levelNames = list()
var/list/regions = list()
var/list/erodeLiquids = list()
var/list/newErodeLiquids = list()
var/datum/controller_master/CS
var/datum/controller/balance/balance

/world
	turf = /turf/floor/voidFloor
	mob = /mob/player
	view = 9
	fps = 15
	icon_size = 32
	loop_checks = 0

/world/New()
	. = ..()
	spawn(1)
		//CONTROLLERS
		CS = new
		CS.addControl(new /datum/controller/machinery)
		CS.addControl(new /datum/controller/lighting)
		CS.addControl(new /datum/controller/hivemind)
		CS.addControl(new /datum/controller/chemicals)
		CS.addControl(new /datum/controller/sdel)
		balance = CS.addControl(new /datum/controller/balance)
		CS.process()
	spawn(10)
		var/icon/face = icon('sprite/mob/human_face.dmi')
		for(var/i in face.IconStates())
			if(copytext(i,1,7) == "facial")
				playerValidFacial |= i
			else if(copytext(i,1,5) == "hair")
				playerValidHair |= i
		messageSystemAll("GENERATING WORLD..")
		spawn(1)
			for(var/i = 1; i < world.maxz; i++)
				generate(i)
		spawn(10)
			messageSystemAll("FINISHED!")
		processObjects()
		processCooldowns()
		processRegions()
		spawn(1) processLiquids()
	..()

/proc/addProcessingObject(var/atom/movable/a)
	a.preProc()
	procObjects += a

/proc/remProcessingObject(var/atom/movable/r)
	r.postProc()
	procObjects -= r

/proc/processLiquids()
	var/processed = 0

	while(1)
		for(var/turf/floor/outside/liquid/T in erodeLiquids)
			if(T && istype(T))
				T.updateErodeDepth()
				processed++
			else
				erodeLiquids -= T
			if(processed > 100)
				processed = 0
		sleep(10) //While I've optimised this loop, bord had it at spawn(10) so 1 whole second it is!


/proc/filterList(var/filter, var/list/inList, var/list/explicitExcluded)
	set background = 1
	var/list/newList = list()
	for(var/i = 1, i <= inList.len, i++)
		var/j = inList[i]
		if(explicitExcluded)
			if(j in explicitExcluded)
				continue
		if(!istype(j, filter))
			continue

		newList += j
	. = newList

/proc/processCooldowns()
	while(1)
		if(cooldownHandler.len)
			for(var/datum/ability/a in cooldownHandler)
				a.abilityCooldownTimer = max(0,--a.abilityCooldownTimer)
				if(a.abilityCooldownTimer <= 0)
					cooldownHandler -= a
				if(a.holder)
					if(a.holder.client)
						a.holder.refreshInterface()
		sleep(1)

/proc/processRegions()
	while(1)
		if(regions.len)
			for(var/datum/zregion/R in regions)
				R.doProcess()
		sleep(1)


/proc/processObjects()
	while(1)
		if(procObjects.len)
			for(var/atom/i in procObjects)
				i.doProcess()
		sleep(1)


/proc/parseIcon(var/toWhere, var/parse, var/chat = TRUE)
	var/icon/i
	if(istype(parse,/mob))
		var/mob/m = parse
		i = icon(m.icon)
		for(var/o in m.overlays)
			i.Blend(icon(icon=o:icon,icon_state=o:icon_state),ICON_OVERLAY)
			if(o:color)
				i.Blend(o:color,ICON_MULTIPLY)
		toWhere << browse_rsc(i,"[parse:icon_state].png")
		if(chat)
			return {"<img src="\ref[fcopy_rsc(i)]">"}
		else
			return {"<img src='[parse:icon_state].png'>"}
	if(istype(parse,/obj))
		var/obj/m = parse
		i = icon(m.icon,m.icon_state)
		for(var/o in m.overlays)
			i.Blend(icon(icon=o:icon,icon_state=o:icon_state),ICON_OVERLAY)
			if(o:color)
				i.Blend(o:color,ICON_MULTIPLY)
		toWhere << browse_rsc(i,"[parse:icon_state].png")
		if(chat)
			return {"<img src="\ref[fcopy_rsc(i)]">"}
		else
			return {"<img src='[parse:icon_state].png'>"}
	else
		return "\icon[parse]"

/proc/generateName(var/forWhat)
	if(forWhat == 0)
		var/list/prefix = list("Kal'","Kom'","Bre'","Tor","Jan'","Min","Zer'","Na")
		var/list/suffix = list("toth","kim","herl","bof","rend","fren","roff","hert","pindreth","gallod")
		return "[pick(prefix)][pick(suffix)]"

//terrain generation

#define lowestChance 1
#define maxColonists 25

/proc/generate(var/zLevel)
	var/cB = pick(validBiomes)
	var/datum/biome/chosenBiome = new cB()

	var/decoChance = chosenBiome.debrisChance
	var/turfScale = chosenBiome.turfSize
	var/liquidScale = chosenBiome.liquidSize
	var/liquidErosion = chosenBiome.liquidErode

	var/x = world.maxx
	var/y = world.maxy

	if(zLevel == 1)
		levelNames.Add("Lobby")
	else
		levelNames.Add(generateName(0))

	var/tilesBetweenLiquid = 1024
	//var/tile2LiquidCounter = 0

	//world << GetNextPrime(rand(1000000,100000000))

	var/datum/zregion/R = new(zLevel,chosenBiome,levelNames[zLevel])
	var/datum/noise/liquidnoise = new()
	var/datum/noise/dirtnoise = new()
	//var/datum/noise/rivernoise = new()

	//world << dirtnoise.PerlinNoise2D(120,64,1,4)

	regions += R

	messageSystemAll("GENERATING TURFS ON Z[zLevel]..")

	spawn(1)
		var/list/liqMade = list()
		var/genstart = world.timeofday

		for(var/a = 1; a <= x; ++a)
			for(var/b = 1; b <= y; ++b)
				if(zLevel == 1)
					continue
				var/turf/T = locate(a,b,zLevel)

				var/liquidval = liquidnoise.PerlinNoise2D(a / 10,b / 10,1,1)
				liquidval += liquidnoise.PerlinNoise2D(a,b,1,1) / 10

				var/dirtval = dirtnoise.PerlinNoise2D(a / 4,b / 4,1,1)
				dirtval += dirtnoise.PerlinNoise2D(a,b,1,1) / 10

				/*var/riverval = rivernoise.PerlinNoise2D(a / 10,b / 10,1,1)
				riverval += rivernoise.PerlinNoise2D(a,b,1,1) / 10

				var/placeriver = riverval > 0.4 && riverval < 0.5*/

				if(liquidval >= 0.6)
					var/turf/T3 = pick(chosenBiome.validLiquids)
					T = new T3(T)
					liqMade |= T
				else if(dirtval >= 0.65 && chosenBiome.dirtTurf)
					var/turf/T3 = chosenBiome.dirtTurf
					T = new T3(T)
				else
					T = new chosenBiome.baseTurf(T)
				//if(prob(lowestChance))
					//world << "[a],[b]"



				//if(dirtnoise.PerlinNoise2D(a,b,0.25,4) > 0.5)
					//world << dirtnoise.PerlinNoise2D(a,b,1,4)
					//for(var/turf/T2 in range(T,rand(0,turfScale)))
					//	var/turf/T3 = pick(chosenBiome.validTurfs)
					//	T2 = new T3(T2)
		erodeLiquids += liqMade
		liqMade.Cut()

		messageSystemAll("FINISHED GENERATING TURFS ON Z[zLevel].. TOOK [(world.timeofday - genstart) / 10]s")

	//world << "<i>GENERATING LIQUIDS ON Z[zLevel]..</i>"

	/*spawn(1)
		for(var/a = 1; a <= x; ++a)
			for(var/b = 1; b <= y; ++b)
				if(zLevel == 1)
					continue
				var/turf/T = locate(a,b,zLevel)
				if(chosenBiome.validLiquids.len)
					if(prob(lowestChance) && tile2LiquidCounter <= 0)
						tile2LiquidCounter = tilesBetweenLiquid
						//for(var/i = liquidScale; i > 0; --i)
						for(var/turf/T2 in circle(T,rand(liquidScale / 3,liquidScale)))
							var/turf/T3 = pick(chosenBiome.validLiquids)
							var/turf/floor/outside/liquid/T4 = new T3(T2)
							T4.depth = 0
							//T4.depth = (liquidScale - i) * 15
							//T4.updateDepth()
							liqMade |= T4
					if(tile2LiquidCounter > 0)
						tile2LiquidCounter--*/

	/*spawn(1)
		var/maxnoise = 0
		var/list/liqMade = list()

		for(var/a = 1; a <= x; ++a)
			for(var/b = 1; b <= y; ++b)
				if(zLevel == 1)
					continue
				var/turf/T = locate(a,b,zLevel)
				var/noiseval = liquidnoise.PerlinNoise2D(a / 10,b / 10,1,1)
				noiseval += liquidnoise.PerlinNoise2D(a,b,1,1) / 10
				maxnoise = max(maxnoise,noiseval)
				if(chosenBiome.validLiquids.len)
					if(noiseval > 0.6)
						//tile2LiquidCounter = tilesBetweenLiquid
						var/turf/T3 = pick(chosenBiome.validLiquids)
						var/turf/floor/outside/liquid/T4 = new T3(T)
						T4.depth = 0
						liqMade |= T4
			//world << "row [a] of liquids"
		erodeLiquids += liqMade
		liqMade.Cut()*/

	/*world << "<i>ERODING LIQUIDS ON Z[zLevel]..</i>"
	spawn(1)
		for(var/turf/floor/outside/liquid/EL in liqMade)
			if(prob(liquidErosion))
				for(var/T in circle(EL,1))
					if(istype(T,/turf/floor/outside/liquid))
						var/turf/T2 = pick(chosenBiome.validTurfs)
						EL = new T2(T)*/


	messageSystemAll("GENERATING DECORATIONS ON Z[zLevel]..")

	spawn(1)
		var/genstart = world.timeofday

		for(var/a = 1; a <= x; ++a)
			for(var/b = 1; b <= y; ++b)
				if(zLevel == 1)
					continue
				var/turf/T = locate(a,b,zLevel)
				if(a == x/2 && b == y/2)
					if(!T.light)
						var/obj/trigger/portal/P = new/obj/trigger/portal(T)
						for(var/turf/D in range(P,5))
							D = new chosenBiome.baseTurf(D)
						P.name = "[levelNames[zLevel]] the [chosenBiome.name]"
						P.safe = FALSE
						//P.set_light(9,9,"#66CCFF") //BAD SAWU BAAAD
				else
					if(prob(decoChance))
						if(!(T.type in chosenBiome.validLiquids))
							var/obj/o = pick(chosenBiome.validDebris)
							new o(T)

		messageSystemAll("FINISHED GENERATING DECORATIONS ON Z[zLevel].. TOOK [(world.timeofday - genstart) / 10]s")

	messageSystemAll("GENERATING NPCS ON Z[zLevel]..")

	spawn(1)
		var/genstart = world.timeofday

		if(zLevel == 1) return
		for(var/a = 0; a < maxColonists; ++a)
			var/m = pick(chosenBiome.validMobs)
			var/mob/b = new m()
			b.loc = locate(rand(1,world.maxx),rand(1,world.maxy),zLevel)
			while(istype(b.loc,/turf/floor/outside/liquid))
				b.loc = locate(rand(1,world.maxx),rand(1,world.maxy),zLevel)

		messageSystemAll("FINISHED GENERATING NPCS ON Z[zLevel].. TOOK [(world.timeofday - genstart) / 10]s")
#undef lowestChance
#undef maxColonists