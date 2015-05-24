/mob/player
	var/lastBleed = 0

/mob/player/doProcess()
	..()
	refreshInterface()
	//health management
	if(playerData.hp.statCur > 0)
		if(!canMove)
			canMove = TRUE
	if(playerData.hp.statCur <= 0)
		if(canMove)
			canMove = FALSE
	if(canMove && !checkFlag(active_states,ACTIVE_STATE_DAZED))
		speed = actualSpeed
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