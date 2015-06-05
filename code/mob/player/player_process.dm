/mob/player
	var/lastBleed = 0
	var/layingDown = 0

	//liquid stuff
	var/inDPSLiquid = FALSE
	var/liquidVerb = ""
	var/liquidDamage = 0

/mob/player/proc/processOrgans()
	for(var/O in playerOrgans)
		O:organProc()

/mob/player/proc/processEffects()
	if(playerData.hp.statModified > 0 && !isDisabled())
		if(!canMove)
			canMove = TRUE
	for(var/datum/statuseffect/S in statuseffects)
		S.tickStatus()

/mob/player/proc/processStates()
	if(playerData.hp.statCurr <= 0)
		if(canMove)
			canMove = FALSE
	if(playerData.hp.statCurr <= playerData.hp.statMin)
		addEffectStack(/datum/statuseffect/dead)
		if(isMonster)
			icon_state = "[icon_state]_dead"
	if(!checkEffectStack("daze"))
		speed = actualSpeed
	var/shouldLay = checkEffectStack("laydown") > 0
	if(shouldLay != layingDown)
		var/matrix/newtransform = matrix()
		if(shouldLay)
			newtransform.Turn(90)
			newtransform.Translate(0,-12)
		animate(src,transform = newtransform,time = 2,loop = 0)
		layingDown = shouldLay

/mob/player/proc/processOther()
	if(inDPSLiquid)
		if(prob(5))
			displayInfo("You are [liquidVerb]!","[src] screams!",src,src)
			takeDamage(liquidDamage,DTYPE_DIRECT)
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

/mob/player/doProcess()
	..()
	if(src.client)
		refreshInterface()
	processEffects()
	processOrgans()
	processStates()
	processOther()