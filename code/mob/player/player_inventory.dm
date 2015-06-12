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

/mob/player/proc/activeHandEmpty()
	return selectedSlot.contents.len > 0 ? FALSE : TRUE

/mob/player/proc/activeHand()
	if(selectedSlot.contents.len > 0)
		return selectedSlot.contents[1]
	return null

/mob/player/proc/takeToActiveHand(var/obj/item/what)
	if(selectedSlot.contents.len <= 0)
		if(selectedSlot.blocked)
			messagePlayer("Your active hand is unavailable!",src,what)
			return
		what.loc = selectedSlot

/mob/player/proc/takeToHand(var/obj/item/what)
	var/obj/hand = getFreeHand()
	if(hand)
		what.loc = hand
	else
		messagePlayer("You have no available hand to take [what]",src,what)