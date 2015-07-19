/mob/player/npc/colonist
	name = "Colonist No-Name"
	npcNature = NPCTYPE_DEFENSIVE
	wanderFuzziness = 5
	var/list/nearbyObj = list()
	var/obj/AH
	var/obj/OH

	//build shit
	var/turf/myHome
	var/isBuilding = FALSE
	var/turf/startedAt
	var/datum/mapGenPattern/MGP
	//harvest shit
	var/obj/interact/foundHarvestable
	var/isHarvesting = FALSE

/mob/player/npc/colonist/New()
	..()
	spawn(15)
		var/obj/item/AB = new/obj/item/weapon/projectile/bow()
		addToInventory(AB)
		takeToActiveHand(AB)
		AB = new/obj/item/weapon/tool/hatchet/iron()
		addToInventory(AB)
		takeToActiveHand(AB)
		updateHands()
		playerData.woodcutting.change(99)
		playerData.fishing.change(99)
		playerData.cooking.change(99)

/mob/player/npc/colonist/updateLocation()
	spawn(1)
		if(lastPos != loc)
			nearbyObj = gmRange(src,7,globalObjList)
	..()

/mob/player/npc/colonist/proc/updateHands()
	AH = activeHand()
	OH = offHand()

/mob/player/npc/colonist/proc/upgradeItems()
	for(var/A in nearbyObj)
		if(!A)
			return
		if(!istype(A,/obj/item/weapon) && !istype(A,/obj/item/armor))
			if(istype(A,/obj/item))
				addToInventory(A)
			continue
		else
			if(istype(A,/obj/item/armor))
				var/DE = FALSE
				for(var/obj/interface/slot/B in slots)
					if(!B)
						return
					if(A:slot == B.id)
						var/obj/item/C = B.contents[1]
						if(C)
							if(A:armorRating || A:stats.len < C.stats.len)
								unEquipItem(C)
								addToInventory(C)
								MoveTo(A)
								equipItem(A)
								DE = TRUE
								break
				if(!DE)
					MoveTo(A)
					equipItem(A)
			if(istype(A,/obj/item/weapon))
				updateHands()
				var/TTL = FALSE
				var/TTR = FALSE
				if(!AH)
					TTL = TRUE
				else
					if(A:weight > AH.weight || A:force > AH.force)
						TTL = TRUE
				if(!TTL)
					if(!OH)
						TTR = TRUE
					else
						if(A:weight > OH.weight || A:force > OH.force)
							TTR = TRUE
				if(TTL | TTR)
					if(Adjacent(A))
						addToInventory(TTL ? AH : OH)
						if(TTL)
							takeToActiveHand(A)
						else
							takeToHand(A)
						nearbyObj -= A
						break
					else
						MoveTo(A)
				updateLocation()
	if(activeHand() && offHand())
		updateHands()
		wieldedWeight = 0
		wieldedWeight += (AH.weight*4)+AH.size
		wieldedWeight += (OH.weight*4)+OH.size
		if(playerData.dex.statModified/2 >= wieldedWeight)
			isDualWielding = TRUE

/mob/player/npc/colonist/proc/processBuild()
	if(!isBuilding)
		return
	if(!MGP)
		return
	if(!startedAt)
		startedAt = get_turf(src)
		MGP.lastTurf = startedAt
	if(!Adjacent(MGP.lastTurf))
		MoveTo(MGP.lastTurf)
		return
	var/A = MGP.buildFrom(startedAt)
	if(A)
		for(var/obj/interact/nature/N in MGP.lastTurf)
			sdel(N)
		if(ispath(A,/obj/item/buildable))
			var/obj/item/buildable/B = new A(MGP.lastTurf)
			B.onUsed(src,MGP.lastTurf)
		else
			new A(MGP.lastTurf)
	if(MGP.currentPos > lentext(MGP.tiles))
		isBuilding = FALSE
		startedAt = null
		MGP = null

/mob/player/npc/colonist/proc/processBuildStates()
	if(isBuilding)
		return
	if(!myHome)
		var/turf/T = get_turf(src)
		if(!locate(/turf/floor/outside/liquid) in circle(src,7))
			if(!istype(T.loc,/area/settled))
				myHome = T
				MGP = new/datum/mapGenPattern/box
				isBuilding = TRUE


/mob/player/npc/colonist/proc/processNodes()
	updateLocation()
	var/obj/interact/fnd
	if(!foundHarvestable)
		if(prob(25) || isBuilding)
			fnd = locate(/obj/interact) in nearbyObj
			foundHarvestable = fnd
	else
		fnd = foundHarvestable
	sleep(10)
	if(fnd)
		if(!isHarvesting)
			if(!Adjacent(fnd))
				MoveTo(fnd)
				sleep(10)
			if(get_dist(src,fnd) > 2)
				return
			if(istype(fnd,/obj/interact/nature/tree))
				sleep(30)
				if(equipType(/obj/item/weapon/tool/hatchet))
					sleep(10)
					if(!fnd:being_cut)
						isHarvesting = TRUE
						fnd.objFunction(src,AH)
			else
				fnd.objFunction(src)
				isHarvesting = TRUE
			sleep(fnd.harvest_delay)
			isHarvesting = FALSE
			foundHarvestable = null

/mob/player/npc/colonist/proc/equipType(var/oftype)
	if(istype(AH,oftype))
		return TRUE
	for(var/I in playerInventory)
		if(istype(I,oftype))
			addToInventory(AH)
			takeToActiveHand(I)
			updateHands()
			return TRUE
	return FALSE

/mob/player/npc/colonist/npcIdle()
	..()
	if(myHome)
		if(npcState == NPCSTATE_IDLE)
			MoveTo(myHome)

/mob/player/npc/colonist/doProcess()
	upgradeItems()
	if(!isBuilding)
		processBuildStates()
	processNodes()
	processBuild()
	if(!isHarvesting && !foundHarvestable && !isBuilding)
		..()

//colonist specific items and things

/obj/areaFlooder
	invisibility = 1

/obj/areaFlooder/New()
	..()
	spawn(10)
		for(var/turf/T in circle(src,5))
			spawn(1)
				new/area/settled(T)