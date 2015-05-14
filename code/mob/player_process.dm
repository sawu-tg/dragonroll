/mob/player
	var/lastBleed = 0

/mob/player/doProcess()
	..()
	if(src.light)
		light.loc = src.loc
		light.update()
	refreshInterface()
	//health management
	if(playerData.hp.statCur > 0)
		if(!canMove)
			canMove = TRUE
	if(playerData.hp.statCur <= 0)
		if(canMove)
			canMove = FALSE
	if(playerData.hp.statCur < 0 && playerData.hp.statCur > playerData.hp.statMin)
		if(lastBleed <= 0)
			takeDamage(1,DTYPE_DIRECT)
			displayInfo("You are bleeding out.","[src] is bleeding out.",src,src)
			lastBleed = BLEEDING_INTERVAL
		else
			lastBleed--
	updateLighting()