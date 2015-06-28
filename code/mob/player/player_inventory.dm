///
// Inventory handling
///

/mob/player/proc/addToInventory(var/obj/item/what)
	if(what)
		what.toggleLoot(TRUE)
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
		what.toggleLoot(FALSE)
		playerInventory -= what
		what.loc = src.loc
		refreshIcon(playerData.playerRacePrefix)
		return what

/mob/player/proc/activeHandEmpty()
	if(!selectedSlot)
		return
	return selectedSlot.contents.len > 0 ? FALSE : TRUE

/mob/player/proc/activeHand()
	if(!selectedSlot)
		return
	if(selectedSlot.contents.len > 0)
		return selectedSlot.contents[1]
	return null

/mob/player/proc/offHand()
	var/obj/interface/slot/OF
	for(var/obj/interface/slot/S in handSlots)
		if(S != selectedSlot)
			OF = S
	if(OF)
		if(OF.contents.len > 0)
			return OF.contents[1]
	return null

/mob/player/proc/takeToActiveHand(var/obj/item/what)
	if(!selectedSlot)
		return
	if(selectedSlot.contents.len <= 0)
		if(selectedSlot.blocked)
			messagePlayer("Your active hand is unavailable!",src,what)
			return
		playerInventory -= what
		what.loc = selectedSlot
		isDualWielding = FALSE
		refreshIcon(playerData.playerRacePrefix)

/mob/player/proc/takeToHand(var/obj/item/what)
	var/obj/hand = getFreeHand()
	if(hand)
		playerInventory -= what
		what.loc = hand
		what.toggleLoot(FALSE)
		isDualWielding = FALSE
		refreshIcon(playerData.playerRacePrefix)
	else
		messagePlayer("You have no available hand to take [what]",src,what)

/mob/player/proc/equipItem(var/obj/item/what)
	var/space = TRUE
	if(!what)
		return
	for(var/obj/item/I in playerEquipped)
		if(I.slot == what.slot)
			space = FALSE
	if(space && istype(what,/obj/item/armor))
		src.playerEquipped |= what
		updateStats()
		refreshIcon(playerData.playerRacePrefix)
	else
		isDualWielding = FALSE
		takeToHand(what)
	what.toggleLoot(FALSE)

/mob/player/proc/unEquipItem(var/obj/item/what)
	if(what)
		what.toggleLoot(TRUE)
		src.playerEquipped.Remove(what)
		updateStats()
	refreshIcon(playerData.playerRacePrefix)

/mob/player/proc/isWorn(var/obj/item/what)
	if(playerEquipped.Find(what))
		return TRUE
	return FALSE

/mob/player/proc/isWearable(var/obj/item/what)
	if(istype(what,/obj/item))
		if(what.slot)
			return TRUE
	return FALSE