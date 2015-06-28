//////////////////////////////////////////////////////////////////////////////////////
// If this doesn't happen soon I will lose my fucking sanity
//////////////////////////////////////////////////////////////////////////////////////

/obj/interface/slot
	mouse_opacity = 1

	//var/mob/player/mymob
	var/id

	var/slotsize //What fits into this
	var/slotoverlays = list()

	var/can_equip = 1 //Picking stuff up into hands, equipping corgisuits, etc.
	var/can_drop = 1  //Dropping and unequipping stuff.
	var/can_steal = 1 //Stripping other people
	var/can_see = 1
	var/can_see_self = 1
	var/can_select = 0

	var/blocked = FALSE // is the slot blocked (can not be used)?

	var/is_hand = 0

	var/hudx = 0 //Position relative to the centermost slot (0,0), so accepts negatives.
	var/hudy = 0

	var/list/slot_blacklist = list()
	var/list/slot_whitelist = list()

	New()
		..(0,0)

	Click()
		var/mob/player/P = usr

		if(!P || P != loc)
			return

		P.selectSlot(id)

	proc/rebuild()
		overlays.Cut()

		var/mob/M = loc

		if(!M)
			del(src)

		for(var/slotoverlay in slotoverlays)
			overlays += icon('sprite/gui/guiObj.dmi',slotoverlay)

		for(var/obj/item/I in loc)
			if(I.slot != id)
				continue
			var/image/img = image(I.icon,I,I.icon_state)
			img.color = I.color
			img.alpha = I.alpha
			img.blend_mode = I.blend_mode
			img.overlays = I.overlays
			img.underlays = I.underlays
			overlays += img

		for(var/atom/A in contents)
			var/image/img = image(A.icon,A,A.icon_state)
			img.color = A.color
			img.alpha = A.alpha
			img.blend_mode = A.blend_mode
			img.overlays = A.overlays
			img.underlays = A.underlays
			overlays += img

		if(blocked)
			overlays += icon('sprite/gui/guiObj.dmi',"disabled")

		if(M.isDualWielding)
			if(is_hand)
				overlays += icon('sprite/gui/guiObj.dmi',"active")
		else
			if(M.selectedSlot == src)
				overlays += icon('sprite/gui/guiObj.dmi',"active")

	proc/align(var/mob/M)
		if(!M || !M.client)
			return

		//var/view_width = M.client.view
		//var/view_height = M.client.view
		var/inv_size = M.slotDisplaySize()
		var/inv_width = inv_size[1]
		var/inv_height = inv_size[2]

		var/true_hudx = hudx + round(inv_width / 2)
		var/true_hudy = hudy + round(inv_height / 2)

		screen_loc = "EAST-[inv_width-true_hudx],SOUTH+[true_hudy]"

	proc/is_free()
		if(!contents.len)
			return TRUE

		return FALSE

/obj/interface/slot
	hand
		name = "Hand"
		id = "hand"
		can_select = 1
		is_hand = 1
		slotoverlays = list("hand_right_wood")

	hand/right
		name = "Right Hand"
		id = "r_hand"
		hudx = 1
		hudy = 0
		slotoverlays = list("hand_right_wood","R")

	hand/left
		name = "Left Hand"
		id = "l_hand"
		hudx = -1
		hudy = 0
		slotoverlays = list("hand_left_wood","L")

	foot
		name = "Foot"
		id = "foot"
		slotoverlays = list("foot_right_wood")

	foot/right
		name = "Right Foot"
		id = "r_foot"
		hudx = 1
		hudy = -2
		slotoverlays = list("foot_right_wood","R")

	foot/left
		name = "Left Foot"
		id = "l_foot"
		hudx = -1
		hudy = -2
		slotoverlays = list("foot_left_wood","L")

	pocket
		name = "Pocket"
		id = "pocket"
		slotoverlays = list("pocket_wood")

	pocket/right
		name = "Right Pocket"
		id = "r_pocket"
		hudx = 1
		hudy = -1
		slotoverlays = list("pocket_wood","R")

	pocket/left
		name = "Left Pocket"
		id = "l_pocket"
		hudx = -1
		hudy = -1
		slotoverlays = list("pocket_wood","L")

	head
		name = "Head"
		id = "head"
		hudx = 0
		hudy = 1
		slotoverlays = list("head_wood")

	chest
		name = "Chest"
		id = "chest"
		hudx = 0
		hudy = 0
		slotoverlays = list("torso_wood")

	groin
		name = "Groin"
		id = "groin"
		hudx = 0
		hudy = -1
		slotoverlays = list("groin_wood")

/mob
	var/list/interfaceSlots = list()
	var/obj/interface/slot/selectedSlot = null
	var/list/handSlots = list()
	var/list/slots = list()

/mob/verb/NextHand()
	set hidden = 1
	if(selectedSlot.id == "r_hand")
		selectedSlot = slots["l_hand"]
	else
		selectedSlot = slots["r_hand"]

/mob/proc/selectSlot(var/slotid)
	var/obj/interface/slot/S = slots[slotid]

	if(S && S.can_select)
		selectedSlot = S

/mob/proc/getFreeHand()
	for(var/obj/interface/slot/S in handSlots)
		//world << "Checking [S.id]"

		if(S.is_free() && !S.blocked)
			return S

	return null

/mob/proc/makeSlotsFromRace(var/datum/race/R)
	var/list/keepSlots = list()

	handSlots:Cut()

	//world << "generating slots for [src]"

	for(var/slottype in R.slots)
		var/obj/interface/slot/newS = new slottype(src)
		var/obj/interface/slot/oldS = slots[newS.id]

		if(oldS)
			newS.contents += oldS.contents
			del(oldS)

		if(newS.is_hand)
			handSlots |= newS

		keepSlots |= newS.id

		//world << "new slot [newS.id]"

		slots[newS.id] = newS

	for(var/slotid in slots)
		if(slotid in slots)
			continue
		slots.Remove(slotid)

	selectedSlot = getFreeHand()

/mob/proc/updateSlots()


/mob/proc/slotDisplaySize()
	var/minx = 0
	var/maxx = 0
	var/miny = 0
	var/maxy = 0

	for(var/slotid in slots)
		var/obj/interface/slot/S = slots[slotid]

		if(!S.can_see_self)
			return

		minx = min(minx,S.hudx)
		miny = min(miny,S.hudy)
		maxx = max(maxx,S.hudx)
		maxy = max(maxy,S.hudy)

	return list(maxx - minx + 1,maxy - miny + 1)
