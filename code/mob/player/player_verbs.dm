///
// DEBUG VERBS
///

/mob/player/verb/teleportMob()
	set name = "Transport to Mob"
	set category = "Debug Verbs"
	var/mob/target = input("To what?") as mob in world
	if(target)
		loc = get_turf(target)

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

/mob/player/verb/damageOrgans()
	set name = "Damage Organs"
	set category = "Debug Verbs"
	var/damage = input("How much?") as num
	for(var/datum/organ/O in playerOrgans)
		O.health -= damage

/mob/player/verb/cleanseAll()
	set name = "Cleanse all Statuses"
	set category = "Debug Verbs"
	for(var/S in statuseffects)
		if(S)
			remStatusEffect(S)


///
// INVENTORY AND STAT VERBS
///
/mob/player/verb/viewInventory()
	set name = "Open Inventory"
	set hidden = 1
	var/html = "<title>Inventory</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	for(var/obj/I in playerInventory)
		html += "<b>[I.name]</b> ([!isWorn(I) ? "<a href=?src=\ref[src];function=dropitem;item=\ref[I]><i>Drop</i></a>" : ""][isWearable(I) && !isWorn(I) ? " | <a href=?src=\ref[src];function=wearitem;item=\ref[I]><i>Equip</i></a>" : (isWorn(I) ? "<a href=?src=\ref[src];function=removeitem;item=\ref[I]><i>Remove</i></a>" : "")] | <a href=?src=\ref[src];function=useitem;item=\ref[I]><i>Use</i></a>)<br>"
	html += "</body></center></html>"
	var/datum/browser/popup = new(usr, "inventory", "Inventory")
	popup.set_content(html)
	popup.open()

/mob/player/verb/viewObjectives()
	set name = "Show Objectives"
	set category = "Player"
	var/html = "<title>Objectives</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	html += "Click an Objective's name to track it!<br>"
	html += "<b>Completed</b>: [playerAntag.completedObjectives]<br>"
	html += "<b>Score</b>: [playerAntag.score]<br>"
	for(var/datum/objective/O in playerAntag.antag_objectives)
		html += "<a href=?src=\ref[src];objective=\ref[O]><b>[O.name]</b></a><br><i>[O.desc]</i><br>"
	html += "</body></center></html>"
	var/datum/browser/popup = new(usr, "objectives", "Objectives")
	popup.set_content(html)
	popup.open()

/mob/player/Topic(href,href_list[])
	if(href_list["objective"])
		var/datum/objective/O = locate(href_list["objective"])
		trackedObjective = O
		messageInfo("You are now tracking [O.name].",src,src)
	..()

/mob/player/verb/playerSheet()
	set name = "View Player Sheet"
	set category = "Player"
	showPlayerSheet(src)

/mob/player
	var/playerSheetPage = 0

/mob/player/proc/showPlayerSheet(var/mob/toWho)
	if(!toWho)
		toWho = src
	var/pageTitle
	switch(playerSheetPage)
		if(0)
			pageTitle = "Stats"
		if(1)
			pageTitle = "Abilities"
		if(2)
			pageTitle = "Skills"
	var/shouldShowChange = toWho == src && hasReroll ? TRUE : FALSE
	var/html = "<title>Player Sheet</title><html><center>[parseIcon(toWho,src,FALSE)]<br><body style='background:grey'>"
	html += "<b>Name</b>: [playerData.playerName][shouldShowChange ? " - <a href=?src=\ref[src];function=name><i>Change</i></a>" : ""]<br>"
	html += "<b>Gender</b>: [playerData.returnGender()][shouldShowChange ? " - <a href=?src=\ref[src];function=gender><i>Change</i></a>" : ""]<br>"
	html += "<b>Race</b>: <font color=[playerData.playerColor]>[playerData.playerRace.raceName]</font>[shouldShowChange ? " - <a href=?src=\ref[src];function=race><i>Change</i></a>" : ""]<br>"
	html += "<b>Class</b>: <font color=[playerData.playerClass.classColor]>[playerData.playerClass.className]</font>[shouldShowChange ? " - <a href=?src=\ref[src];function=class><i>Change</i></a>" : ""]<br>"
	html += "<b>Class Desc.</b>: [playerData.playerClass.classDesc]<br>"
	html += "<b>Race Desc.</b>: [playerData.playerRace.raceDesc]<br>"
	html += "<b>Hairstyle</b>: [playerData.playerHair][shouldShowChange ? " - <a href=?src=\ref[src];function=sethair><i>Change</i></a>" : ""]<br>"
	html += "<b>Facial hair</b>: [playerData.playerFacial][shouldShowChange ? " - <a href=?src=\ref[src];function=setfacial><i>Change</i></a>" : ""]<br>"
	html += "<b>Eye Color</b>: <font color=[playerData.eyeColor]>Preview</font>[shouldShowChange ? " - <a href=?src=\ref[src];function=eyes><i>Change</i></a>" : ""]<br>"
	html += "<b>Hair Color</b>: <font color=[playerData.hairColor]>Preview</font>[shouldShowChange ? " - <a href=?src=\ref[src];function=haircolor><i>Change</i></a>" : ""]<br>"
	html += "<b>Description</b>: [playerData.playerDesc] [shouldShowChange ? "- <a href=?src=\ref[src];function=desc><i>Add</i></a>/<a href=?src=\ref[src];function=descdelete><i>Remove</i></a>" : ""]<br><br>"
	html += "<b>Stat Points</b>: [playerData.playerStatPoints]<br>"
	html += "<a href=?src=\ref[src];function=togglestat>[pageTitle]</a>"
	if(playerSheetPage == 2)
		var/count = 2
		html += "<table width = 100% style=\"border: 1px solid black;\">"
		for(var/datum/stat/S in playerData.playerSkills)
			if(count == 0)
				html += "<tr>"
			html += "<td style=\"text-align:center\"><b>[S.statName]</b>: [S.statModified]<br> \["
			html += "[S.totalXP] / "
			html += "[S.xpToLevel]]</td>"
			count--
			if(count == 0)
				html += "</tr>"
				count = 2
		html += "</table>"
	if(playerSheetPage == 1)
		html += "<br><b>Skills Points</b>: [playerData.playerSkillPoints]<br>"
		var/count = 2
		html += "<table width = 100% style=\"border: 1px solid black;\">"
		for(var/datum/ability/S in playerData.playerAbilities)
			if(count == 0)
				html += "<tr>"
			html += "<td style=\"text-align:center\"><b><a href=?src=\ref[src];function=train;skill=\ref[S]>[parseIcon(toWho,image(S.abilityIcon,icon_state=S.abilityState))]</a></b><br> \["
			html += "[S.abilityLevel]/[S.abilityMaxLevel]]</td>"
			count--
			if(count == 0)
				html += "</tr>"
				count = 2
		html += "</table>"
	if(playerSheetPage == 0)
		var/count = 2
		html += "<table width = 100% style=\"border: 1px solid black;\">"
		for(var/datum/stat/S in playerData.playerStats)
			if(count == 0)
				html += "<tr>"
			if(S.isLimited)
				html += "<td style=\"text-align:center\"><b>[S.statName]</b>: [S.statCurr]/[S.statModified]<br> \["
			else
				html += "<td style=\"text-align:center\"><b>[S.statName]</b>: [S.statModified]<br> \["
			html += "<a href=?src=\ref[src];function=raise;stat=[S.statId]>+</a> / "
			html += "<a href=?src=\ref[src];function=lower;stat=[S.statId]>-</a>]</td>"
			count--
			if(count == 0)
				html += "</tr>"
				count = 2
		html += "</table>"
		html += "[shouldShowChange ? "<a href=?src=\ref[src];function=statroll><b>Reroll Stats</b></a> <a href=?src=\ref[src];function=statkeep><b>Keep Stats</b></a>" : ""]<br>"
	html += "</body></center></html>"
	var/datum/browser/popup = new(toWho, "plysheet", "Player Sheet")
	popup.set_content(html)
	popup.open()

/mob/verb/forceRefreshInterface()
	set name = "Refresh Interface"
	set category = "Debug Verbs"
	for(var/o in screenObjs)
		usr << "Refreshing [o]"
	refreshInterface()


///
// INTERFACE SHORTCUTS
///

/mob/proc/findInterfaceKey(var/asNum)
	for(var/obj/interface/spellContainer/O in screenObjs)
		if(O.hotKey == asNum && !isnull(O.heldSpell))
			return O
	return null

/mob/verb/KeyDown0()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(0)
	O.objFunction()

/mob/verb/KeyDown1()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(1)
	O.objFunction()

/mob/verb/KeyDown2()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(2)
	O.objFunction()

/mob/verb/KeyDown3()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(3)
	O.objFunction()

/mob/verb/KeyDown4()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(4)
	O.objFunction()

/mob/verb/KeyDown5()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(5)
	O.objFunction()

/mob/verb/KeyDown6()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(6)
	O.objFunction()

/mob/verb/KeyDown7()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(7)
	O.objFunction()

/mob/verb/KeyDown8()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(8)
	O.objFunction()

/mob/verb/KeyDown9()
	set hidden = TRUE
	var/obj/interface/O = findInterfaceKey(9)
	O.objFunction()

/mob/verb/NextHotkey()
	set hidden = TRUE
	if(selectedHotKey + 1 <= maxHotkeys)
		++selectedHotKey
	else
		selectedHotKey = 1
	refreshInterface()

///
// ITEM HANDLING SHORTCUTS
//

/mob/verb/DropItem()
	set name = "Drop Held Item"
	set hidden = 1
	if(selectedSlot.contents.len > 0)
		var/obj/A = selectedSlot.contents[1]
		A.loc = src.loc
	isDualWielding = FALSE
	if(istype(src,/mob/player))
		var/mob/player/P = src
		P.refreshIcon(P.playerData.playerRacePrefix)
	refreshInterface()

/mob/verb/UseHotkey()
	set hidden = 1
	call(usr,"KeyDown[selectedHotKey]")(usr)

/mob/verb/LastHotkey()
	set hidden = 1
	if(selectedHotKey - 1 >= 1)
		--selectedHotKey
	else
		selectedHotKey = 9
	refreshInterface()

/mob/player/verb/liftObj()
	set name = "Lift Object"
	set category = "Actions"
	set src = usr
	var/excluded = list(src,carrying)
	var/atom/movable/lifted = input("Pick up what?") as null|anything in filterList(/atom/movable/,oview(1),excluded)
	if(lifted)
		if(lifted.anchored || lifted == carrying || lifted.carriedBy == src)
			return
		if(!Adjacent(lifted))
			messagePlayer("[lifted] is too far away!",src,lifted)
			return
		if(do_roll(1,20,playerData.str.statCurr) >= lifted.weight + lifted.size)
			lifted.myOldLayer = lifted.layer
			lifted.myOldPixelY = lifted.pixel_y
			lifted.layer = LAYER_OVERLAY
			lifted.pixel_y = lifted.pixel_y + 10
			lifted.beingCarried = TRUE
			lifted.carriedBy = src
			carrying = lifted
			addProcessingObject(lifted)
		else
			messagePlayer("You can't quite seem to pick [lifted] up!",src,lifted)

/mob/player/verb/throwObj()
	set name = "Throw/Kick Object"
	set category = "Actions"
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
				kickWhat.Move(target)
	else
		if(do_roll(1,20,playerData.str.statCurr) >= carrying.weight + carrying.size)
			var/t = input("Throw at what") as null|anything in filterList(/atom/movable,oview(max(playerData.str.statCurr - (carrying.weight + carrying.size),1)))
			if(t)
				carrying.throw_at(t)
				dropObj(src)


/mob/player/verb/dropObj()
	set name = "Drop Lifted Object"
	set category = "Actions"
	set src = usr
	if(carrying)
		messageArea("You drop the [carrying]!","[src] drops the [carrying]!",src,carrying)
		carrying.beDropped()

///
// INTENT AND MOB CONTROL
///

/mob/verb/changeIntent()
	set hidden = 1
	set name = "Change Intent"
	if(intent < 4)
		intent++
	else
		intent = 1
	messagePlayer("Your intent is now [intent2string()]",src,src)

/mob/player/verb/leap()
	set hidden = 1
	set name = "Leap to"
	set desc = "Attempts to leap towards a target"
	var/t = input("Leap at what") as null|anything in filterList(/atom/movable,oview(max( (playerData.str.statCurr+playerData.dex.statCurr)/src.weight ,1)))
	if(t)
		src.throw_at(t)

/mob/player/verb/decoy()
	set hidden = 1
	var/turf/t = get_turf(src)

	var/image/I = image(src.icon,t,src.icon_state)
	I.overlays += overlays

	//animate(I, pixel_z = 50, alpha = 0, time = 90)
	t.overlays += I

/mob/player/verb/ToggleDebug()
	set name = "Toggle Debug"
	set category = "Debug Verbs"
	if(debugModeOn)
		rem_pane(/datum/windowpane/debug)
		usr << "<b>Debug OFF</b>"
		debugModeOn = FALSE
		return
	else
		add_pane(/datum/windowpane/debug)
		usr << "<b>Debug ON</b>"
		debugModeOn = TRUE
		return

/mob/player/verb/suicide()
	set name = "Suicide"
	set category = "Skills"

	var/choice = input("Are you sure you want to kill yourself?") in list("Yes","No")
	if(choice)
		if(choice == "Yes")
			src.takeDamage(9999,DTYPE_DIRECT)

/mob/player/verb/ViewEnc()
	set name = "Encyclopedia"
	set category = "Skills"
	var/html = "<title>Encyclopedia</title><html><center><body style='background:grey'><br>"
	var/list/index = list()
	if(playerEnc.len >= 5)
		giveMedal("Knowledge is Power",usr)
	for(var/A in playerEnc)
		index |= uppertext(copytext(A,1,2))
	var/counter = 0
	for(var/A in index)
		if(counter > 0)
			html += " <b>|</b> "
		html += "<a href=?src=\ref[src];enccategory=[A]>[A]</a>"
		counter++
	for(var/A in playerEnc)
		if(uppertext(copytext(A,1,2)) == chosenEncIndex)
			html += "<br><b>[A]</b><br>[playerEnc[A]]<br>"
	html += "</body></center></html>"
	var/datum/browser/popup = new(usr, "encyclopedia", "Encyclopedia")
	popup.set_content(html)
	popup.open()

/mob/player/Topic(href,href_list[])
	..()
	if(href_list["enccategory"])
		chosenEncIndex = href_list["enccategory"]
		src.ViewEnc()