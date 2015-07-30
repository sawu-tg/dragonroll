///
// Various UI objects.
///

/obj/interface
	name = "interface obj"
	desc = "interface object"
	icon = 'sprite/gui/guiObj.dmi'
	anchored = TRUE
	layer = LAYER_INTERFACE
	mouse_opacity = 0

/obj/interface/New(var/x,var/y,var/state="box",var/scale=32,var/customres)
	var/icon/temp = icon(icon=icon,icon_state=state)
	temp.Scale(scale,scale)
	icon = temp
	if(customres)
		screen_loc = customres
	else
		screen_loc = "[x],[y]"

/obj/interface/proc/showTo(var/mob/M)
	M.client.screen |= src

//interface shortcut (ie to an item)
/obj/interface/shortcut
	name = "shortcutContainer"
	desc = "For easy access"
	mouse_opacity = 1
	var/myIndex
	var/obj/shortcutTo

/obj/interface/shortcut/New(var/x,var/y,var/state="box",var/scale=32,var/obj/shown,var/index)
	myIndex = index
	shortcutTo = shown
	..(x,y,state,scale)

/obj/interface/shortcut/objFunction(var/mob/user)
	//user.ChooseHand(myIndex)
	user.refreshInterface()
	..()

/obj/interface/shortcut/proc/rebuild(var/obj/aswhat)
	overlays.Cut()
	shortcutTo = aswhat
	if(aswhat)
		if(istype(aswhat,/obj/item))
			overlays += getFlatIcon(aswhat)
		else
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
	name = "Pickup Object"
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
	name = "Drop Object"
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
	if(P.selectedSlot.contents.len > 0)
		var/obj/A = P.selectedSlot.contents[1]
		P.addToInventory(A)
	P.refreshInterface()

///
// Intent
///
/obj/interface/intentButton
	name = "Change Intent"
	desc = "Changes the player's intent"
	mouse_opacity = 1

/obj/interface/intentButton/proc/changeIcon(var/towhat)
	overlays.Cut()
	var/icon/I = icon(icon='sprite/gui/guiObj.dmi',icon_state="[towhat]")
	overlays.Add(I)

/obj/interface/intentButton/New(var/x,var/y,var/state="box",var/scale=32)
	changeIcon("Helping")
	..(x,y,state,scale)

/obj/interface/intentButton/Click()
	var/mob/player/P = usr
	P.changeIntent()
	changeIcon(P.intent2string())
	P.refreshInterface()

///
// Dual Wield
///
/obj/interface/dwButton
	name = "Dual Wield"
	desc = "Toggles Dual Wielding"
	mouse_opacity = 1

/obj/interface/dwButton/proc/changeIcon(var/towhat)
	overlays.Cut()
	var/icon/I = icon(icon='sprite/gui/guiObj.dmi',icon_state="dw-[towhat]")
	overlays.Add(I)

/obj/interface/dwButton/New(var/x,var/y,var/state="box",var/scale=32)
	changeIcon(0)
	..(x,y,state,scale)


/obj/interface/dwButton/Click()
	var/mob/player/P = usr
	var/wielded = 0
	var/total = 0
	if(P.isDualWielding)
		changeIcon(0)
		P.isDualWielding = FALSE
		messageInfo("You stop Dual Wielding!",P,P)
		return
	for(var/obj/interface/slot/S in P.handSlots)
		if(S.contents.len)
			wielded++
			var/obj/item/I = S.contents[1]
			total += (I.weight*4)+I.size
	if(wielded <= 1)
		messageInfo("You need two weapons to dual wield!",P,P)
	else
		P.wieldedWeight = total
		P.isDualWielding = TRUE
		changeIcon(1)
		if(P.playerData.dex.statModified/2 >= P.wieldedWeight)
			messageInfo("You start Dual Wielding!",P,P)
		else
			messageInfo("You are unbalanced! ([P.playerData.dex.statModified/2] vs [total])",P,P)
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
	if(P.selectedSlot.contents.len > 0)
		var/obj/A = P.selectedSlot.contents[1]
		A.objFunction(P)
	P.refreshInterface()


//throw
/obj/interface/throwButton
	name = "Throw/Kick Object"
	desc = "Uses the held item (or kicks something)"
	mouse_opacity = 1

/obj/interface/throwButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="throw"))
	..(x,y,state,scale)

/obj/interface/throwButton/Click()
	var/mob/player/P = usr
	P.throwObj()
	P.refreshInterface()

//leap
/obj/interface/leapButton
	name = "Leap At"
	desc = "Leaps at a target"
	mouse_opacity = 1

/obj/interface/leapButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="leap"))
	..(x,y,state,scale)

/obj/interface/leapButton/Click()
	var/mob/player/P = usr
	P.leap()
	P.refreshInterface()

//drop item
/obj/interface/dropIButton
	name = "Drop Item"
	desc = "Picks up stuff"
	mouse_opacity = 1

/obj/interface/dropIButton/New(var/x,var/y,var/state="box",var/scale=32)
	overlays.Cut()
	overlays.Add(icon(icon=icon,icon_state="dropitem"))
	..(x,y,state,scale)

/obj/interface/dropIButton/Click()
	var/mob/player/P = usr
	P.DropItem()

//compass

/obj/interface/compass
	name = "compass"
	icon = 'sprite/gui/guiObj64.dmi'
	var/atom/target
	var/atom/master
	var/image/arrow
	var/lastX
	var/lastY
	var/srcX
	var/srcY
	var/lastAngle = 0
	var/lastR = 0
	var/lastG = 0
	var/lastB = 0

/obj/interface/compass/New()
	..()
	addProcessingObject(src)
	arrow = image('sprite/gui/guiObj64.dmi',icon_state = "notarget", layer = LAYER_INTERFACE+11)
	overlays += arrow

/obj/interface/compass/Click()
	var/mob/player/P = usr
	P.viewObjectives()

/obj/interface/compass/doProcess()
	if(!target)
		arrow.icon_state = "notarget"
		return
	if(!master)
		return
	if(!istype(target,/atom))
		return
	var/inputX = target.x
	var/inputY = target.y
	var/newAngle = get_angle_nums(master.x,master.y,inputX,inputY)
	var/lastRGB = rgb(lastR,lastG,lastB)
	if(target.x != lastX || target.y != lastY || master.x != srcX || master.y != srcY || lastAngle != newAngle || arrow.color != lastRGB)
		lastX = target.x
		lastY = target.y
		srcX = master.x
		srcY = master.y
		overlays -= arrow
		var/toColor
		if(master.z != target.z)
			arrow.icon_state = "arrow_noz"
			toColor = list("R" = 255, "G" = 0, "B" = 0)
			inputX = rand(1,world.maxx)
			inputY = rand(1,world.maxy)
			newAngle = get_angle_nums(master.x,master.y,inputX,inputY)
		else
			arrow.icon_state = "arrow"
			toColor = list("R" = 0, "G" = 255, "B" = 255)
		if(get_dist(target,master) < 2)
			toColor = list("R" = 0, "G" = 255, "B" = 0)
		lastAngle = Lerp(lastAngle,newAngle,0.25)
		lastR = Lerp(lastR,toColor["R"])
		lastG = Lerp(lastG,toColor["G"])
		lastB = Lerp(lastB,toColor["B"])
		lastRGB = rgb(lastR,lastG,lastB)
		animate(arrow, transform = turn(matrix(), lastAngle),color=lastRGB, time = TICK_LAG*5, loop = 1,easing=SINE_EASING)
		overlays += arrow