var/list/zMaps = list() // associative list of zlevels and their maps
var/list/mappingPlayers = list() // associative list of player/zlevel

/datum/controller/cartography
	name = "Cartography"
	execTime = 1
	var/pixelBudget = 64
	var/maxBudget = 64

	var/lastX = 1
	var/lastY = 1
	var/lastZ = 1

	var/cooldown = 0

	var/zoom = 2

	var/list/cachedTurf

/mob/verb/changeChunkSize()
	set name = "Change Minimap Chunks"
	set category = "Debug Verbs"
	if(cartography)
		var/amount = input(src,"To what? (Def. 32)") as num
		if(amount)
			cartography.pixelBudget = amount
			cartography.maxBudget = amount

/mob/verb/saveMap()
	set name = "Save MiniMap"
	set category = "Debug Verbs"
	if(zMaps)
		for(var/A in zMaps)
			usr << ftp(zMaps[A],"minimap-[A].png")

/datum/controller/cartography/New()
	spawn(25)
		cachedTurf = new/list(world.maxx,world.maxy,world.maxz)
		for(var/B = 1; B <= world.maxz; ++B)
			var/icon/I = icon('sprite/obj/tg_effects/effects.dmi',icon_state="foam")
			I.Scale(round(world.maxx/zoom),round(world.maxy/zoom))
			zMaps["[B]"] = I

/datum/controller/cartography/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (CD: [cooldown] | BGT: [pixelBudget]/[maxBudget])")

/datum/controller/cartography/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (CD: [cooldown] | BGT: [pixelBudget]/[maxBudget])"

/datum/controller/cartography/doProcess()
	set background = TRUE
	if(zMaps.len)
		var/roundedX = round(world.maxx/zoom)
		var/roundedY = round(world.maxy/zoom)
		spawn(1)
			for(var/mob/A in playerList)
				if(!A.client)
					continue
				if(!mappingPlayers[A])
					mappingPlayers[A] = A.z
				else
					if(mappingPlayers[A] != A.z)
						mappingPlayers[A] = A.z
		spawn(1)
			for(var/mob/player/P in mappingPlayers)
				if(P)
					if(P.MM)
						P.MM.icon = zMaps["[P.z]"]

		spawn(1)
			///
			if(pixelBudget <= 0)
				if(cooldown > 0)
					--cooldown
				else
					cooldown = initial(cooldown)
					pixelBudget = maxBudget
					if(lastX >= roundedX)
						lastX = 1
					if(lastY >= roundedY)
						lastY = 1
					if(lastZ >= world.maxz)
						lastZ = 1
			else
			///
				for(var/Z = lastZ; Z <= world.maxz; Z++)
					for(var/X = lastX; X <= roundedX; X++)
						for(var/Y = lastY; Y <= roundedY; Y++)
							if(X > roundedX)
								X = roundedX
							if(Y > roundedY)
								Y = roundedY
							if(Z > world.maxz)
								Z = world.maxz
							if(pixelBudget <= 0)
								lastX = X
								lastY = Y
								lastZ = Z
								return
							var/pixColor
							var/icon/I = zMaps["[Z]"]
							if(!cachedTurf[X][Y][Z])
								var/turf/T = locate(X*zoom,Y*zoom,Z*zoom)
								var/icon/I2 = icon(T.icon,icon_state=T.icon_state)
								pixColor = T.color ? T.color : I2.GetPixel(1,1)
								cachedTurf[X][Y][Z] = pixColor
							else
								pixColor = cachedTurf[X][Y][Z]
							if(I)
								if(pixColor)
									I.DrawBox(pixColor,X,Y)
								else
									I.DrawBox("black",X,Y)
							else
								messageSystemAll("Missing zMap for [Z]")
							--pixelBudget
	scheck()

/obj/interface/minimap
	name = "minimap"
	desc = "your minimap"
	icon_state = ""
	anchored = TRUE
	layer = LAYER_INTERFACE
	mouse_opacity = 0

/obj/interface/minimap/New()
	..()
	screen_loc = "NORTH-4,EAST-4"