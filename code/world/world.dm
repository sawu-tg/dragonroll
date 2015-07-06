var/globalCacheIDs = 0

/world
	turf = /turf/floor/voidFloor
	mob = /mob/player
	view = 9
	fps = 20
	icon_size = 32
	loop_checks = 0
	hub = "Sawucalls.DragonRoll"
	hub_password = "4dlzubF0vugUpt9x"

/world/New()
	. = ..()
	world.log = file("drlog.txt")
	world.log << "Starting new game at [time2text(world.timeofday)]"
	spawn(1)
		//CONTROLLERS
		CS = new
		CS.addControl(new /datum/controller/machinery)
		CS.addControl(new /datum/controller/lighting)
		CS.addControl(new /datum/controller/hivemind)
		CS.addControl(new /datum/controller/chemicals)
		CS.addControl(new /datum/controller/sdel)
		CS.addControl(new /datum/controller/cooldowns)
		cartography = CS.addControl(new /datum/controller/cartography)
		diplomacy = CS.addControl(new /datum/controller/diplomacy)
		balance = CS.addControl(new /datum/controller/balance)
		CS.process()
	spawn(10)
		var/icon/face = icon('sprite/mob/human_face.dmi')
		for(var/i in face.IconStates())
			if(copytext(i,1,7) == "facial")
				playerValidFacial |= i
			else if(copytext(i,1,5) == "hair")
				playerValidHair |= i
		messageSystemAll("GENERATING FACTIONS..")
		setupFactions()
		messageSystemAll("GENERATING WORLD..")
		for(var/i = 1; i < world.maxz; i++)
			generate(i)
		spawn(10)
			messageSystemAll("FINISHED!")
		//spawn(1) processObjects()
		spawn(1) processRegions()
		spawn(1) processLiquids()
		spawn(30)
			world << sound('sound/misc/themesong.ogg',1,0)
	..()

/proc/addProcessingObject(var/atom/movable/a)
	a.preProc()
	procObjects |= a

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

/proc/processRegions()
	while(1)
		if(regions.len)
			for(var/datum/zregion/R in regions)
				R.doProcess()
		sleep(1)


/*/proc/processObjects()
	while(1)
		if(procObjects.len)
			for(var/atom/i in procObjects)
				i.doProcess()
		sleep(1)*/

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

	var/datum/zregion/R = new(zLevel,chosenBiome,levelNames[zLevel])
	var/datum/noise/liquidnoise = new()
	var/datum/noise/dirtnoise = new()

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

				if(liquidval >= 0.6)
					var/turf/T3 = pick(chosenBiome.validLiquids)
					T = new T3(T)
					liqMade |= T
				else if(dirtval >= 0.65 && chosenBiome.dirtTurf)
					var/turf/T3 = chosenBiome.dirtTurf
					T = new T3(T)
				else
					T = new chosenBiome.baseTurf(T)
		erodeLiquids += liqMade
		liqMade.Cut()

		messageSystemAll("FINISHED GENERATING TURFS ON Z[zLevel].. TOOK [(world.timeofday - genstart)]s")

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
				else
					if(prob(decoChance))
						if(!(T.type in chosenBiome.validLiquids))
							var/obj/o = pick(chosenBiome.validDebris)
							new o(T)

		messageSystemAll("FINISHED GENERATING DECORATIONS ON Z[zLevel].. TOOK [(world.timeofday - genstart)]s")

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

		messageSystemAll("FINISHED GENERATING NPCS ON Z[zLevel].. TOOK [(world.timeofday - genstart)]s")
#undef lowestChance
#undef maxColonists