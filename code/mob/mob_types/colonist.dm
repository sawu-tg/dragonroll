/mob/player/npc/colonist
	name = "Colonist No-Name"
	npcNature = NPCTYPE_DEFENSIVE
	wanderFuzziness = 5
	var/list/nearbyObj = list()
	var/obj/AH
	var/obj/OH

/mob/player/npc/colonist/New()
	..()
	spawn(15)
		var/obj/item/AB = new/obj/item/weapon/projectile/bow()
		addToInventory(AB)
		takeToActiveHand(AB)

/mob/player/npc/colonist/updateLocation()
	spawn(1)
		if(lastPos != loc)
			nearbyObj = gmRange(src,7,globalObjList)
			lastPos = loc
	..()

/mob/player/npc/colonist/proc/updateHands()
	AH = activeHand()
	OH = offHand()

/mob/player/npc/colonist/proc/upgradeItems()
	for(var/A in nearbyObj)
		if(!A)
			return
		if(!istype(A,/obj/item/weapon) && !istype(A,/obj/item/armor))
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

/mob/player/npc/colonist/doProcess()
	upgradeItems()
	..()