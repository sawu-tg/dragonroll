/datum/mapGenPattern
	var/tiles = {""} // pattern of alphanumeric characters to draw the thing, see below. starts from top left
	var/tileDecos = {""}
	var/list/typeTiles = list() // associative list of alphanumeric chars and their types
	//VARS FOR NPC PROCESSING
	var/turf/startAt
	var/turf/lastTurf
	var/lastX
	var/lastY
	var/lastZ
	var/currentPos = 1 // the pos in the list the npc is at


/datum/mapGenPattern/proc/buildFrom(var/turf/start)
	if(!startAt)
		startAt = start
		lastTurf = startAt
		lastX = startAt.x
		lastY = startAt.y
		lastZ = startAt.z
	else
		var/A = copytext(tiles,currentPos,currentPos+1)
		var/B = copytext(tileDecos,currentPos,currentPos+1)
		if(A == "\n")
			lastY--
			lastX = startAt.x
			currentPos++
			return
		var/turf/T = locate(lastX,lastY,lastZ)
		lastX++
		currentPos++
		lastTurf = T
		if(T && typeTiles[A])
			if(typeTiles[B])
				if(B != A)
					var/ofDeco = typeTiles[B]
					new ofDeco(T)
			var/ofType = typeTiles[A]
			return ofType

/datum/mapGenPattern/proc/createAt(var/turf/start)
	var/originalStart = start.x
	var/x = start.x
	var/y = start.y
	var/z = start.z
	var/len = lentext(tiles)
	for(var/I = 1, I <= len, I++)
		var/A = copytext(tiles,I,I+1)
		var/B = copytext(tileDecos,I,I+1)
		if(A == "\n")
			y--
			x = originalStart
			continue
		var/turf/T = locate(x,y,z)
		if(T && typeTiles[A])
			if(typeTiles[B])
				if(B != A)
					var/ofDeco = typeTiles[B]
					new ofDeco(T)
			var/ofType = typeTiles[A]
			new ofType(T)
		x++

/datum/mapGenPattern/box
	tiles = {"xxxxxx
xoooox
xoooox
xoooox
xxoxxx"}
	tileDecos = {"xxxxxx
xoooox
xolotx
xoaocx
xxdxxx"}
	typeTiles = list("d" = /obj/structure/door,"l" = /obj/furniture/light,"a" = /obj/areaFlooder,"x" = /turf/wall/woodWall, "o" = /turf/floor/woodFloor,"c" = /obj/furniture/seat/stool,"t" = /obj/furniture/table/wooden)