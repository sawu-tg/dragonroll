///
// DEBUG VERBS
///
/mob/player/verb/switchController()
	set name = "Toggle Controllers"
	set category = "Debug Verbs"
	var/datum/controller/c = input("Toggle What?") as null|anything in CS.controllers
	if(c)
		c.isRunning = !c.isRunning
		usr << "Selected controller toggled to [c.isRunning]"

/mob/player/verb/addAbility()
	set name = "Give Ability"
	set category = "Debug Verbs"
	var/d = input("Learn what?") as null|anything in typesof(/datum/ability)
	if(d)
		addPlayerAbility(new d)

/mob/player/verb/remAbility()
	set name = "Remove Ability"
	set category = "Debug Verbs"
	var/d = input("Forget what?") as null|anything in playerData.playerAbilities
	if(d)
		remPlayerAbility(d)

/mob/player/verb/bridge()
	set name = "Bridge Land"
	set category = "Debug Verbs"
	for(var/turf/t in range(7))
		t = new/turf/floor/outside/grass(t)


///
// INVENTORY AND STAT VERBS
///
/mob/player/verb/viewInventory()
	set name = "Open Inventory"
	var/html = "<title>Inventory</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	for(var/obj/I in playerInventory)
		html += "<b>[I.name]</b> ([!isWorn(I) ? "<a href=?src=\ref[src];function=dropitem;item=\ref[I]><i>Drop</i></a>" : ""][isWearable(I) && !isWorn(I) ? " | <a href=?src=\ref[src];function=wearitem;item=\ref[I]><i>Equip</i></a>" : (isWorn(I) ? "<a href=?src=\ref[src];function=removeitem;item=\ref[I]><i>Remove</i></a>" : "")] | <a href=?src=\ref[src];function=useitem;item=\ref[I]><i>Use</i></a>)<br>"
	html += "</body></center></html>"
	src << browse(html,"window=playersheet")

/mob/player/verb/playerSheet()
	set name = "View Player Sheet"
	showPlayerSheet(src)

/mob/player/proc/showPlayerSheet(var/mob/toWho)
	if(!toWho)
		toWho = src
	var/html = "<title>Player Sheet</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	html += "<b>Name</b>: [playerData.playerName][hasReroll ? " - <a href=?src=\ref[src];function=name><i>Change</i></a>" : ""]<br>"
	html += "<b>Gender</b>: [playerData.returnGender()][hasReroll ? " - <a href=?src=\ref[src];function=gender><i>Change</i></a>" : ""]<br>"
	html += "<b>Race</b>: <font color=[playerData.playerColor]>[playerData.playerRace.raceName]</font>[hasReroll ? " - <a href=?src=\ref[src];function=race><i>Change</i></a>" : ""]<br>"
	html += "<b>Class</b>: <font color=[playerData.playerClass.classColor]>[playerData.playerClass.className]</font>[hasReroll ? " - <a href=?src=\ref[src];function=class><i>Change</i></a>" : ""]<br>"
	html += "<b>Class Desc.</b>: [playerData.playerClass.classDesc]<br>"
	html += "<b>Race Desc.</b>: [playerData.playerRace.raceDesc]<br>"
	html += "<b>Hairstyle</b>: [playerData.playerHair][hasReroll ? " - <a href=?src=\ref[src];function=sethair><i>Change</i></a>" : ""]<br>"
	html += "<b>Facial hair</b>: [playerData.playerFacial][hasReroll ? " - <a href=?src=\ref[src];function=setfacial><i>Change</i></a>" : ""]<br>"
	html += "<b>Eye Color</b>: <font color=[playerData.eyeColor]>Preview</font>[hasReroll ? " - <a href=?src=\ref[src];function=eyes><i>Change</i></a>" : ""]<br>"
	html += "<b>Hair Color</b>: <font color=[playerData.hairColor]>Preview</font>[hasReroll ? " - <a href=?src=\ref[src];function=haircolor><i>Change</i></a>" : ""]<br>"
	html += "<b>Description</b>: [playerData.playerDesc] - <a href=?src=\ref[src];function=desc><i>Add</i></a>/<a href=?src=\ref[src];function=descdelete><i>Remove</i></a><br><br>"
	for(var/datum/stat/S in playerData.playerStats)
		if(S.isLimited)
			html += "<b>[S.statName]</b>: [S.statModified]/[S.statMax]<br>"
		else
			html += "<b>[S.statName]</b>: [S.statModified]<br>"
	html += "[hasReroll ? "<a href=?src=\ref[src];function=statroll><b>Reroll Stats</b></a> <a href=?src=\ref[src];function=statkeep><b>Keep Stats</b></a>" : ""]<br>"
	html += "</body></center></html>"
	toWho << browse(html,"window=playersheet")

/mob/verb/forceRefreshInterface()
	set name = "Refresh Interface"
	set category = "Debug Verbs"
	for(var/o in screenObjs)
		usr << "Refreshing [o]"
	refreshInterface()


///
// INTERFACE SHORTCUTS
///
/mob/verb/KeyDown0()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[0]
	O.objFunction()

/mob/verb/KeyDown1()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[1]
	O.objFunction()

/mob/verb/KeyDown2()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[2]
	O.objFunction()

/mob/verb/KeyDown3()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[3]
	O.objFunction()

/mob/verb/KeyDown4()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[4]
	O.objFunction()

/mob/verb/KeyDown5()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[5]
	O.objFunction()

/mob/verb/KeyDown6()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[6]
	O.objFunction()

/mob/verb/KeyDown7()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[7]
	O.objFunction()

/mob/verb/KeyDown8()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[8]
	O.objFunction()

/mob/verb/KeyDown9()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[9]
	O.objFunction()

/mob/verb/NextHotkey()
	set hidden = TRUE
	if(selectedHotKey + 1 <= maxHotkeys)
		++selectedHotKey
	else
		selectedHotKey = 1
	refreshInterface()

/*/mob/verb/NextHand()
	set hidden = TRUE
	if(selectedQuickSlot == leftPocket)
		selectedQuickSlot = leftHand
	else if(selectedQuickSlot == leftHand)
		selectedQuickSlot = rightHand
	else if(selectedQuickSlot == rightHand)
		selectedQuickSlot = rightPocket
	else if(selectedQuickSlot == rightPocket)
		selectedQuickSlot = leftPocket
	refreshInterface()

/mob/proc/ChooseHand(var/i)
	set hidden = TRUE
	if(i == 1)
		selectedQuickSlot = leftPocket
	else if(i == 2)
		selectedQuickSlot = leftHand
	else if(i == 3)
		selectedQuickSlot = rightHand
	else if(i == 4)
		selectedQuickSlot = rightPocket
	refreshInterface()*/

///
// ITEM HANDLING SHORTCUTS
//

/mob/verb/DropItem()
	set name = "Drop Held Item"
	if(selectedSlot.contents.len > 0)
		var/obj/A = selectedSlot.contents[1]
		A.loc = src.loc
	refreshInterface()

/mob/verb/UseHotkey()
	call(usr,"KeyDown[selectedHotKey]")(usr)

/mob/verb/LastHotkey()
	if(selectedHotKey - 1 >= 1)
		--selectedHotKey
	else
		selectedHotKey = 9
	refreshInterface()

/mob/player/verb/liftObj()
	set name = "Lift Object"
	set src = usr
	var/excluded = list(src,carrying)
	var/atom/movable/lifted = input("Pick up what?") as null|anything in filterList(/atom/movable/,oview(1),excluded)
	if(lifted)
		if(lifted.anchored || lifted == carrying || lifted.carriedBy == src)
			return
		if(!Adjacent(lifted))
			displayTo("[lifted] is too far away!",src,lifted)
			return
		if(do_roll(1,20,playerData.str.statCur) >= lifted.weight + lifted.size)
			lifted.myOldLayer = lifted.layer
			lifted.myOldPixelY = lifted.pixel_y
			lifted.layer = LAYER_OVERLAY
			lifted.pixel_y = lifted.pixel_y + 10
			lifted.beingCarried = TRUE
			lifted.carriedBy = src
			carrying = lifted
			addProcessingObject(lifted)
		else
			displayTo("You can't quite seem to pick [lifted] up!",src,lifted)

/mob/player/verb/throwObj()
	set name = "Throw/Kick Object"
	set src = usr
	if(!carrying)
		var/list/excluded = list(src)
		excluded |= src.contents
		var/atom/movable/kickWhat = input("What do you want to kick?") as null|anything in filterList(/atom/movable/,view(1),excluded)
		if(kickWhat)
			if(kickWhat.anchored)
				return
			var/turf/target = get_step(kickWhat,usr.dir)
			if(src in target)
				return
			if(target && !target.density)
				walk_to(kickWhat,target)
	else
		if(do_roll(1,20,playerData.str.statCur) >= carrying.weight + carrying.size)
			var/t = input("Throw at what") as null|anything in filterList(/atom/movable,oview(max(playerData.str.statCur - (carrying.weight + carrying.size),1)))
			if(t)
				carrying.throw_at(t)
				dropObj(src)


/mob/player/verb/dropObj()
	set name = "Drop Held Object"
	set src = usr
	if(carrying)
		displayInfo("You drop the [carrying]!","[src] drops the [carrying]!",src,carrying)
		carrying.beDropped()

///
// INTENT AND MOB CONTROL
///

/mob/verb/changeIntent()
	set name = "Change Intent"
	if(intent < 3)
		intent++
	else
		intent = 1
	displayTo("Your intent is now [intent2string()]",src,src)

/mob/player/verb/leap()
	set name = "Leap to"
	set desc = "Attempts to leap towards a target"
	var/t = input("Leap at what") as null|anything in filterList(/atom/movable,oview(max( (playerData.str.statCur+playerData.dex.statCur)/src.weight ,1)))
	if(t)
		src.throw_at(t)