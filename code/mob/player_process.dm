/mob/player/doProcess()
	//health management
	if(playerData.hp.statCur > 0)
		if(!canMove)
			canMove = TRUE
	if(playerData.hp.statCur <= 0)
		if(canMove)
			canMove = FALSE
	if(playerData.hp.statCur < 0 && playerData.hp.statCur > playerData.hp.statMin)
		takeDamage(1,DTYPE_DIRECT)
		displayInfo("You are bleeding out.","[src] is bleeding out.",src,src)