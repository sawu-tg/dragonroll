/mob/player
	var/lastBleed = 0
	var/layingDown = 0
	var/inWater = 0

	//liquid stuff
	var/inDPSLiquid = FALSE
	var/liquidVerb = ""
	var/liquidDamage = 0

/mob/player/doProcess()
	..()
	refreshInterface()
	//processFlags(src)
	//health management
	if(playerData.hp.statModified > 0 && !isDisabled())
		if(!canMove)
			canMove = TRUE

	for(var/datum/organ/O in playerOrgans)
		O.organProc()

	for(var/datum/statuseffect/S in statuseffects)
		S.tickStatus()

	if(playerData.hp.statCurr <= 0)
		if(canMove)
			canMove = FALSE
		if(playerData.hp.statCurr <= playerData.hp.statMin)
			addEffectStack(/datum/statuseffect/dead)
			if(isMonster)
				icon_state = "[icon_state]_dead"
			else
				//do some shit with rotation //or don't do it here holy shit nigga

	if(!checkEffectStack("daze"))
		speed = actualSpeed

	var/shouldLay = checkEffectStack("laydown") > 0

	if(shouldLay != layingDown)
		var/matrix/newtransform = matrix()

		if(shouldLay)
			newtransform.Turn(90)
			newtransform.Translate(0,-8)

		animate(src,transform = newtransform,time = 2,loop = 0)
		layingDown = shouldLay

	var/shouldDrown = checkEffectStack("drown") > 0

	if(shouldDrown)
		if(prob(5))
			displayInfo("You are [liquidVerb]!","[src] screams!",src,src)
			takeDamage(liquidDamage,DTYPE_DIRECT)

	if(shouldDrown != inWater)
		var/new_z = 0

		if(shouldDrown)
			var/turf/floor/outside/liquid/L = loc

			if(L && istype(L))
				new_z = -L.depth
				layer = L.layer

		animate(src,pixel_z = new_z,time = 10)
		if(!shouldDrown)
			animate(src,layer = initial(layer),time = 0)

		inWater = shouldDrown

	if(checkEffectStack("poison"))
		if(prob(5))
			displayInfo("You are poisoned!","[src] shudders and wretches",src,src)
			takeDamage(1,DTYPE_DIRECT)
	if(playerData.hp.statCurr < 0 && playerData.hp.statCurr > playerData.hp.statMin)
		if(lastBleed <= 0)
			takeDamage(1,DTYPE_DIRECT)
			displayInfo("You are bleeding out.","[src] is bleeding out.",src,src)
			lastBleed = BLEEDING_INTERVAL
		else
			lastBleed--