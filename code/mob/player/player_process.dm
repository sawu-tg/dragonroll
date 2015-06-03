/mob/player
	var/lastBleed = 0

	//liquid stuff
	var/inDPSLiquid = FALSE
	var/liquidVerb = ""
	var/liquidDamage = 0

/mob/player/doProcess()
	..()
	refreshInterface()
	processFlags(src)
	//health management
	if(playerData.hp.statCur > 0 && !isDisabled())
		if(!canMove)
			canMove = TRUE

	for(var/datum/organ/O in playerOrgans)
		O.organProc()

	if(playerData.hp.statCur <= 0)
		if(canMove)
			canMove = FALSE
	if(!checkFlag(active_states,ACTIVE_STATE_DAZED))
		speed = actualSpeed
	if(inDPSLiquid)
		if(prob(5))
			displayInfo("You are [liquidVerb]!","[src] screams!",src,src)
			takeDamage(liquidDamage,DTYPE_DIRECT)
	if(checkFlag(active_states,ACTIVE_STATE_POISONED))
		if(prob(5))
			displayInfo("You are poisoned!","[src] shudders and wretches",src,src)
			takeDamage(1,DTYPE_DIRECT)
	if(playerData.hp.statCur < 0 && playerData.hp.statCur > playerData.hp.statMin)
		if(lastBleed <= 0)
			takeDamage(1,DTYPE_DIRECT)
			displayInfo("You are bleeding out.","[src] is bleeding out.",src,src)
			lastBleed = BLEEDING_INTERVAL
		else
			lastBleed--