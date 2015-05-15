///DEBUG VERBS
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


/mob/player/verb/viewInventory()
	set name = "Open Inventory"
	var/html = "<title>Inventory</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	for(var/obj/item/I in playerInventory)
		html += "<b>[I.name]</b>: [I.stackSize] ([!isWorn(I) ? "<a href=?src=\ref[src];function=dropitem;item=\ref[I]><i>Drop</i></a>" : ""][isWearable(I) && !isWorn(I) ? " | <a href=?src=\ref[src];function=wearitem;item=\ref[I]><i>Equip</i></a>" : (isWorn(I) ? "<a href=?src=\ref[src];function=removeitem;item=\ref[I]><i>Remove</i></a>" : "")] | <a href=?src=\ref[src];function=useitem;item=\ref[I]><i>Use</i></a>)<br>"
	html += "</body></center></html>"
	src << browse(html,"window=playersheet")

/mob/player/verb/playerSheet()
	set name = "View Player Sheet"
	var/html = "<title>Player Sheet</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	html += "<b>Name</b>: [playerData.playerName][hasReroll ? " - <a href=?src=\ref[src];function=name><i>Change</i></a>" : ""]<br>"
	html += "<b>Gender</b>: [playerData.returnGender()][hasReroll ? " - <a href=?src=\ref[src];function=gender><i>Change</i></a>" : ""]<br>"
	html += "<b>Race</b>: <font color=[playerData.playerColor]>[playerData.playerRace.raceName]</font>[hasReroll ? " - <a href=?src=\ref[src];function=race><i>Change</i></a>" : ""]<br>"
	html += "<b>Class</b>: <font color=[playerData.playerClass.classColor]>[playerData.playerClass.className]</font>[hasReroll ? " - <a href=?src=\ref[src];function=class><i>Change</i></a>" : ""]<br>"
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
	src << browse(html,"window=playersheet")

/mob/verb/forceRefreshInterface()
	set name = "Refresh Interface"
	set category = "Debug Verbs"
	for(var/o in screenObjs)
		usr << "Refreshing [o]"
	refreshInterface()


//interface cmds
//we're going to assume screenObjs 0 - 9 are the correct objs
///////////////////////////////////////////////////////////////
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

/mob/verb/NextHand()
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

/mob/verb/DropItem()
	if(selectedQuickSlot.contents.len > 0)
		world << selectedQuickSlot.contents.len
		var/obj/A = selectedQuickSlot.contents[1]
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

/mob/verb/changeIntent()
	set name = "Change Intent"
	if(intent < 3)
		intent++
	else
		intent = 1
	displayTo("Your intent is now [intent2string()]",src,src)