///
// Inventory handling
///

/mob/player/proc/addToInventory(var/obj/item/what)
	if(what)
		playerInventory += what
		what.loc = src
		return what

/mob/player/proc/inventoryContains(var/obj/item/what)
	if(what)
		for(var/obj/item/a in playerInventory)
			if(a.uuid == what.uuid)
				return TRUE
	return FALSE

/mob/player/proc/remFromInventory(var/obj/item/what)
	if(what)
		playerInventory -= what
		what.loc = src.loc
		return what

///
// Hand management
///

/*
/mob/player/proc/getFreeHand()
	if(leftHand.contents.len <= 0)
		return leftHand
	else if(rightHand.contents.len <= 0)
		return rightHand
	else if(leftPocket.contents.len <= 0)
		return leftPocket
	else if(rightPocket.contents.len <= 0)
		return rightPocket
	return null

/mob/player/proc/getHandByName(var/where="leftHand")
	switch(where)
		if("leftHand")
			return leftHand
		if("rightHand")
			return rightHand
		if("leftPocket")
			return leftPocket
		if("rightPocket")
			return rightPocket

/mob/player/proc/getHandIsFree(var/where="leftHand")
	switch(where)
		if("leftHand")
			return leftHand.contents.len > 0 ? FALSE : TRUE
		if("rightHand")
			return rightHand.contents.len > 0 ? FALSE : TRUE
		if("leftPocket")
			return leftPocket.contents.len > 0 ? FALSE : TRUE
		if("rightPocket")
			return rightPocket.contents.len > 0 ? FALSE : TRUE
*/

/mob/player/proc/activeHandEmpty()
	return selectedSlot.contents.len > 0 ? FALSE : TRUE

/mob/player/proc/activeHand()
	if(selectedSlot.contents.len > 0)
		return selectedSlot.contents[1]
	return null

/*/mob/player/proc/insertInHand(var/obj/item/what,var/where="leftHand")
	if(getHandIsFree(where))
		var/obj/hand = getHandByName(where)
		what.loc = hand*/

/mob/player/proc/takeToActiveHand(var/obj/item/what)
	if(selectedSlot.contents.len <= 0)
		what.loc = selectedSlot

/mob/player/proc/takeToHand(var/obj/item/what)
	var/obj/hand = getFreeHand()
	if(hand)
		what.loc = hand