#define AMBIENCE_SEGMENT 16

/datum/zregion
	var/regionName = ""

	var/datum/biome/chosenBiome
	var/zLevel = 0

	var/ambientLight = "#000000"
	var/ambientLight_Last = "#000000"
	var/startTime = 0

	var/list/timeSegmentName = list("Day","Dusk","Night","Dawn")
	var/list/timeSegmentLength = list(2400,1200,2400,1200)
	var/list/timeSegmentLight = list("#FFFFFF","#FF5511","#001188","#AAFFFF")

	var/timeTotalLength = 7200

	New(zlev,biome,name="")
		zLevel = zlev
		regionName = name
		chosenBiome = biome

		updateTime()

		startTime = rand(0,timeTotalLength)

	proc/doProcess()
		ambientLight_Last = ambientLight

		var/currTime = (world.timeofday - startTime) % timeTotalLength

		//world << "current time [currTime] -- [world.timeofday]"

		if(currTime < 0)
			currTime = timeTotalLength + (currTime % timeTotalLength)

		for(var/i = 1, i <= timeSegmentLength.len,i++)
			currTime -= timeSegmentLength[i]

			if(currTime <= 0) //This is the time we're on.
				ambientLight = timeSegmentLight[i]
				break

		if(ambientLight != ambientLight_Last)
			spawn(1) ambientLightUpdate()

	proc/updateTime()
		timeTotalLength = 0

		for(var/i = 1, i <= timeSegmentName.len, i++)
			timeTotalLength += timeSegmentLength[i]

	proc/ambientLightUpdate()
		//set background = 1

		var/lum_r = GetRedPart(ambientLight) / 255
		var/lum_g = GetGreenPart(ambientLight) / 255
		var/lum_b = GetBluePart(ambientLight) / 255

		for(var/xseg = 0, xseg < world.maxx / AMBIENCE_SEGMENT, xseg++)
			for(var/yseg = 0, yseg < world.maxy / AMBIENCE_SEGMENT, yseg++)
				//world << "updating from [xseg * AMBIENCE_SEGMENT + 1],[yseg * AMBIENCE_SEGMENT + 1] with size [AMBIENCE_SEGMENT*32] on z[zLevel]"
				//var/i = 0

				for(var/atom/movable/lighting_overlay/O in bounds(xseg * AMBIENCE_SEGMENT * 32,yseg * AMBIENCE_SEGMENT * 32,AMBIENCE_SEGMENT*32,AMBIENCE_SEGMENT*32,zLevel))
					//lighting_update_overlays |= O
					//if(i == 0)
						//world << "[O.x],[O.y] segment: [xseg],[yseg]"

					O.update_ambience(lum_r,lum_g,lum_b)
					//i++

				//world << "updating [i] overlays"

			sleep(10)

		//if(lighting_update_overlays.len)
			//world << "updating [lighting_update_overlays.len]/[i] overlays"