/mob/player
	var/lastBleed = 0
	var/layingDown = 0
	var/inWater = 0

	var/balanceWorth = 1 // how much this rewards when killed

	var/hasOtherDeath = FALSE // is death icons and stuf fhandled elsewhere?

	//liquid stuff
	var/inDPSLiquid = FALSE
	var/liquidVerb = ""
	var/liquidDamage = 0
	var/isSliding = FALSE
	var/datum/statuseffect/suffocating/drownEffect = new

/mob/player/proc/processOrgans()
	for(var/O in playerOrgans)
		if(O:processTime > 0)
			--O:processTime
		else
			O:organProc()
			O:processTime = initial(O:processTime)

/mob/player/proc/processEffects()
	if(playerData && playerData.hp.statModified > 0 && !isDisabled())
		if(!canMove)
			canMove = TRUE
	for(var/S in statuseffects)
		if(S)
			S:tickStatus()

/mob/player/proc/processStates()
	if(playerData && playerData.hp.statCurr <= 0)
		for(var/datum/organ/O in playerOrgans)
			O.health -= 5
		if(canMove)
			canMove = FALSE
	if(playerData && playerData.hp.statCurr <= playerData.hp.statMin)
		if(isMonster && !hasOtherDeath)
			icon_state = "[icon_state]_dead"
		if(balanceWorth > 0)
			--balanceWorth
			if(alignment == ALIGN_EVIL)
				balance.changeBalance(-1)
			else
				balance.changeBalance(1)
	if(!checkEffectStack("daze"))
		speed = actualSpeed
	var/shouldLay = checkEffectStack("laydown") > 0
	if(shouldLay != layingDown)
		var/matrix/newtransform = matrix()
		if(shouldLay)
			newtransform.Turn(90)
			newtransform.Translate(0,-8)
			newtransform.Scale(1)
		animate(src,transform = newtransform,time = 2,loop = 0)
		layingDown = shouldLay

/mob/player/proc/processOther()
	var/shouldDrown = checkStatusEffect(drownEffect) > 0

	var/turf/floor/outside/liquid/L = loc

	reagents.handle_procs()

	if(!mobFaction)
		mobFaction = findFaction("Colonist")

	if(istype(L,/turf/floor/outside/liquid))
		if(L.slippery && L.solid)
			isSliding = TRUE
			Move(get_step(src,src.dir))

	if(shouldDrown != inWater || (istype(L) && pixel_z != -L.depth))
		var/new_z = 0

		if(shouldDrown)
			if(L && istype(L))
				new_z = -L.depth
				layer = L.layer+0.1

		animate(src,pixel_z = new_z,time = 10)
		if(!shouldDrown)
			animate(src,layer = initial(layer),time = 0)

		inWater = shouldDrown

	if(shouldDrown)
		if(prob(5))
			messageArea("You are [liquidVerb]!","[src] screams!",src,src)
			takeDamage(liquidDamage,DTYPE_ENVIRONMENT)

	if(checkEffectStack("poison"))
		if(prob(5))
			messageArea("You are poisoned!","[src] shudders and wretches",src,src)
		takeDamage(checkEffectStack("poison"),DTYPE_MAGIC)
	if(playerData && playerData.hp.statCurr < 0 && playerData.hp.statCurr > playerData.hp.statMin)
		if(lastBleed <= 0)
			takeDamage(1,DTYPE_MAGIC)
			messageArea("You are bleeding out.","[src] is bleeding out.",src,src)
			lastBleed = BLEEDING_INTERVAL
		else
			lastBleed--

/mob/player/doProcess()
	..()
	if(src.client)
		refreshInterface()
	processOther()
	processEffects()
	processOrgans()
	processStates()
