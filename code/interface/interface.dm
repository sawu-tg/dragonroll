/obj/interface
	name = "interface obj"
	desc = "interface object"
	icon = 'sprite/gui/guiObj.dmi'
	anchored = TRUE
	layer = LAYER_INTERFACE
	mouse_opacity = 0

/obj/interface/New(var/x,var/y,var/state="box",var/scale=32)
	var/icon/temp = icon(icon=icon,icon_state=state)
	temp.Scale(scale,scale)
	icon = temp
	screen_loc = "[x],[y]"

/obj/interface/proc/showTo(var/mob/M)
	M.client.screen |= src

/obj/interface/objFunction(var/mob/user)
	return

//interface shortcut (ie to an item)
/obj/interface/shortcut
	name = "shortcutContainer"
	desc = "For easy access"
	var/obj/shortcutTo

/obj/interface/shortcut/New(var/x,var/y,var/state="box",var/scale=32,var/obj/shown)
	shortcutTo = shown
	..(x,y,state,scale)

/obj/interface/shortcut/proc/rebuild(var/obj/aswhat)
	overlays.Cut()
	shortcutTo = aswhat
	if(aswhat)
		overlays.Add(icon(icon=aswhat.icon,icon_state=aswhat.icon_state))


//spell container
//holds clickable abilties
/obj/interface/spellContainer
	name = "spellContainer"
	desc = "Holds a spell"
	var/obj/spellHolder/heldSpell
	var/hotKey = 0
	mouse_opacity = 1

/obj/interface/spellContainer/proc/setTo(var/obj/spellHolder/toWhat)
	heldSpell = toWhat
	name = toWhat.name
	desc = toWhat.desc
	overlays.Cut()
	overlays.Add(icon(icon=toWhat.heldAbility.abilityIcon,icon_state=toWhat.heldAbility.abilityState))


/obj/interface/spellContainer/objFunction(var/mob/user)
	if(heldSpell)
		heldSpell.Cast(user)

///
//buttons that are hardcoded
///

//pickup
/obj/interface/pickupButton
	name = "Pickup Item"
	desc = "Picks up stuff"
	mouse_opacity = 1

/obj/interface/pickupButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="pickup"))
	..(x,y,state,scale)

/obj/interface/pickupButton/Click()
	var/mob/player/P = usr
	P.liftObj(usr)

//drop
/obj/interface/dropButton
	name = "Drop Item"
	desc = "Drops stuff"
	mouse_opacity = 1

/obj/interface/dropButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="drop"))
	..(x,y,state,scale)

/obj/interface/dropButton/Click()
	var/mob/player/P = usr
	if(P.carrying)
		P.carrying.beDropped()

//store
/obj/interface/storeButton
	name = "Store Item"
	desc = "Puts an item in the player's inventory"
	mouse_opacity = 1

/obj/interface/storeButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="store"))
	..(x,y,state,scale)

/obj/interface/storeButton/Click()
	var/mob/player/P = usr
	if(P.selectedQuickSlot.contents.len > 0)
		var/obj/A = P.selectedQuickSlot.contents[1]
		P.addToInventory(A)
	P.refreshInterface()

//use
/obj/interface/useButton
	name = "Use Item"
	desc = "Uses the current item"
	mouse_opacity = 1

/obj/interface/useButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="use"))
	..(x,y,state,scale)

/obj/interface/useButton/Click()
	var/mob/player/P = usr
	if(P.selectedQuickSlot.contents.len > 0)
		var/obj/A = P.selectedQuickSlot.contents[1]
		A.objFunction(P)
	P.refreshInterface()