/mob/player
	name = "unnamed"
	icon = 'sprite/mob/human.dmi'
	icon_state = "skeleton_s"
	var/datum/playerFile/playerData = new

	var/list/playerInventory = list()
	var/list/playerEquipped = list()

	var/list/persistingEffects = list()
	var/active_states = 0
	var/passive_states = 0

	var/list/playerSpellHolders = list()

	var/hasReroll = TRUE
	size = 3
	weight = 5

/mob/player/New()
	addProcessingObject(src)
	randomise()
	..()

/mob/player/Stat()
	statpanel("Character")
	for(var/datum/stat/S in playerData.playerStats)
		if(S.isLimited)
			stat("[S.statName]: [S.statModified]/[S.statMax] (Base: [S.statCur])")
		else
			stat("[S.statName]: [S.statModified] (Base: [S.statCur])")
	stat("Your intent is: [intent2string()]")
	statpanel("Abilities")
	for(var/obj/spellHolder/A in playerSpellHolders)
		A.updateName()
		stat(A)
	statpanel("Debug")
	var/turf/T = loc
	stat("CPU: [world.cpu]")
	stat("FPS: [world.fps]")
	stat("Loc. Lights: [T.beingLit.len]")
	stat("Proc. Lightspots: [globalLightingUpdates.len]")
	stat("Total Count: [world.contents.len]")
	stat("Realtime: [world.realtime]")

///DEBUG VERBS
/mob/player/verb/switchController()
	set name = "Toggle Controllers"
	set category = "Debug Verbs"
	var/datum/controller/c = input("Toggle What?") as null|anything in controllers
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

//Saycode, brutally mashed together by MrSnapwalk.

/proc/get_hear(range, source)
	var/list/heard = view(range, source)
	return heard

/proc/formatspeech(msg)
	if(!msg)
		return "says, \"...\"";

	var/ending = copytext(msg, length(msg))

	if (ending == "?")
		return "asks, \"[msg]\"";

	if (ending == "!")
		return "exclaims, \"[msg]\"";

	return "says, \"[msg]\"";

mob/proc/hear(msg, var/source)
	var/name = source:name
	src << "[parseIcon(src,source)] > [name] [msg]"

/mob/player/verb/say(msg as text)
	set name = "Say"
	var/message_range = 7
	var/list/listening = get_hear(message_range, usr)
	msg = formatspeech(msg)
	for (var/mob/M in listening)
		M.hear(msg, usr)

/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	A.examine(src)

/mob/player/proc/takeDamage(var/amount,var/type=DTYPE_BASIC)
	var/damage = max(0,type == DTYPE_DIRECT ? amount : amount - playerData.def.statCur)
	var/doDamage = FALSE
	if(damage > playerData.con.statCur)
		if(type == DTYPE_NONLETHAL)
			if(!savingThrow(src,0,SAVING_FORTITUDE))
				//set unconcious 1d4 rounds
			else
				//set dazed 1 round
		type = DTYPE_MASSIVE
	if(type == DTYPE_BASIC || type == DTYPE_DIRECT)
		doDamage = TRUE
	if(type == DTYPE_MASSIVE)
		if(!savingThrow(src,0,SAVING_FORTITUDE))
			playerData.hp.setTo(-1)
			doDamage = FALSE
		else
			doDamage = TRUE
	if(doDamage)
		playerData.hp.setTo(playerData.hp.statCur-damage)
		if(playerData.hp.statCur == 0)
			mobAddFlag(src,PASSIVE_STATE_DISABLED,active=0)
		else if(playerData.hp.statCur <= -1 && playerData.hp.statCur >= -9)
			mobRemFlag(src,PASSIVE_STATE_DISABLED,active=0)
			mobAddFlag(src,ACTIVE_STATE_DYING,active=1)
		else if(playerData.hp.statCur <= -10)
			mobRemFlag(src,PASSIVE_STATE_DISABLED,active=0)
			mobRemFlag(src,ACTIVE_STATE_DYING,active=1)
			mobAddFlag(src,PASSIVE_STATE_DEAD,active=0)

/////////////////////////////////////////////////////////////////////////
//-Player Creation and Setup functions:
//	*randomise(): randomises a character
//	*nameChange(name): changes the player's name to the given string, as well as it's mob's name
//	*refreshIcon(prefix): rebuilds the player's mob icon, with the given racial prefix. This proc must be called last in most cases.
//	*raceChange(race,reselect): changes the player's racial data to the given race, if reselect is TRUE, offers an input for color/skin.
//	calls hairChange()
//	*genderChange(gender): changes the player's gender to the given regular or custom gender. calls hairChange()
//	*eyeChange(color): changes the player's eye color to the given color. calls hairChange()
//	*hairChange(head,face,color): changes the player's head and/or facial hair to the given strings, and sets it to color.
//-Call hierachy
//	body update > hairChange(old-data) > refreshIcon()
//	incorrect calls or updates will result in missing icon parts.
/////////////////////////////////////////////////////////////////////////

/mob/player/proc/randomise()
	raceChange(text2path("/datum/race/[pick("Human","Golem","Lizard","Slime","Pod","Fly","Jelly","Ape","Spider","Spidertaur","Robot","Hologram")]"),FALSE)
	playerData.playerRacePrefix = playerData.playerRace.icon_prefix[1]
	genderChange(pick("Male","Female"))
	eyeChange(pick("red","blue","green","yellow","orange","purple"))
	classChange(pick(text2path("/datum/class/[pick("Assistant","Engineer","Doctor","Chef","Botanist","Scientist","Captain","Officer")]")))
	rerollStats(FALSE)

/mob/player/proc/nameChange(var/toName)
	if(toName)
		name = "[toName] the [playerData.returnGender()] [playerData.playerRace.raceName]"
		playerData.playerName = toName

/mob/player/proc/refreshIcon(var/prefix)
	icon_state = "blank"
	overlays.Cut()

	var/state = "[prefix]_[playerData.playerGenderShort]_s"
	var/image/player = image(icon,state)
	player.color = playerData.playerColor
	overlays |= player

	var/image/eyes = image(icon,playerData.playerRace.raceEyes)
	eyes.color = playerData.eyeColor

	var/list/addedOverlays = list()
	addedOverlays |= playerData.playerRace.race_overlays
	addedOverlays |= eyes //fuck the what byond
	addedOverlays |= playerData.playerOverlays
	for(var/obj/item/I in playerEquipped)
		addedOverlays |= image(icon=I.icon,icon_state = I.icon_state)

	for(var/ov in addedOverlays)
		if(isicon(ov) || istype(ov,/image))
			overlays |= ov
		else
			var/image/overlay = image(icon,ov)
			overlays |= overlay
	playerData.playerOverlays = list()

/mob/player/proc/raceChange(var/datum/race/toRace,var/reselect = TRUE)
	if(toRace)
		playerData.playerRace = new toRace
		playerData.assignRace(playerData.playerRace)
		var/prefix = ""
		if(reselect)
			if(playerData.playerRace.icon_prefix.len > 1)
				var/chosenSkin = input(src,"Choose a skin") as null|anything in playerData.playerRace.icon_prefix
				if(chosenSkin)
					prefix = chosenSkin
				else
					prefix = playerData.playerRace.icon_prefix[1]
			else
				prefix = playerData.playerRace.icon_prefix[1]

			playerData.playerRacePrefix = prefix

			if(playerData.playerRace.shouldColorRace)
				var/chosenColor = input(src,"Choose a Color") as color|null
				if(chosenColor)
					playerData.playerColor = chosenColor
				else
					playerData.playerColor = "white"
			else
				playerData.playerColor = "white"
		else
			prefix = playerData.playerRacePrefix
		hairChange(playerData.playerHair,playerData.playerFacial,playerData.hairColor)
		descChange()

/mob/player/proc/genderChange(var/toGender)
	if(toGender)
		if(toGender == "Male")
			playerData.playerGender = 0
			playerData.playerGenderShort = "m"
		if(toGender == "Female")
			playerData.playerGender = 1
			playerData.playerGenderShort = "f"
		if(toGender == "Custom")
			playerData.playerGender = 2
			playerData.customGender = input(src,"Please input your gender") as text
			var/choice = input(src,"Please choose what gender appearence you would like") as anything in list("Male","Female")
			switch(choice)
				if("Male")
					playerData.playerGenderShort = "m"
				if("Female")
					playerData.playerGenderShort = "f"
		hairChange(playerData.playerHair,playerData.playerFacial,playerData.hairColor)

/mob/player/proc/eyeChange(var/toColor)
	if(toColor)
		playerData.eyeColor = toColor
		hairChange(playerData.playerHair,playerData.playerFacial,playerData.hairColor)

/mob/player/proc/hairChange(var/hair, var/facial, var/color)
	playerData.playerHair = hair
	playerData.playerFacial = facial
	playerData.hairColor = color
	var/icon/hairNew = new/icon('sprite/mob/human_face.dmi',icon_state=playerData.playerHair)
	hairNew.Blend(playerData.hairColor,ICON_MULTIPLY)
	playerData.playerOverlays |= hairNew
	var/icon/facialNew = new/icon('sprite/mob/human_face.dmi',icon_state=playerData.playerFacial)
	facialNew.Blend(playerData.hairColor,ICON_MULTIPLY)
	playerData.playerOverlays |= facialNew
	refreshIcon(playerData.playerRacePrefix)

/mob/player/proc/updateStats()
	for(var/obj/item/I in playerEquipped)
		for(var/datum/stat/S in playerData.playerStats)
			for(var/A in I.stats)
				if(A == S.statName)
					if(!S.affecting.Find(I))
						S.addTo(I.stats[A])
						S.affecting |= I


///////////////////////////////////////////////////////////////////////////////////////////////
//-Extraneous player functions
//	*addPlayerAbility(ability): adds ability to player, if player already has it, levels it up
//	*remPlayerAbility(ability): removes ability from player, if ability level > 1, levels it down
//	*descChange(add): adds the given string to the player's custom description list.
//	*descRemove(rem): removes the selected string from the player's custom description list.
//	*rerollStats(ask): rerolls the player's stats, and if prompt=true, it will ask the player if they want to keep them
//	*playerSheet(): displays the player's character sheet.
///////////////////////////////////////////////////////////////////////////////////////////////

/mob/player/proc/addPlayerAbility(var/datum/ability/toAdd,var/doUpgrade = FALSE)
	if(playerData.playerAbilities.Find(toAdd) && doUpgrade)
		var/datum/ability/a = playerData.playerAbilities.Find(toAdd)
		if(a.abilityLevel < a.abilityMaxLevel)
			a.abilityLevel++
	else
		if(!playerData.playerAbilities.Find(toAdd))
			playerData.playerAbilities |= toAdd
			var/obj/spellHolder/SH = new /obj/spellHolder(toAdd)
			SH.heldAbility.holder = src
			SH.mobHolding = src
			playerSpellHolders |= SH

/mob/player/proc/remPlayerAbility(var/datum/ability/toRem)
	if(playerData.playerAbilities.Find(toRem))
		var/datum/ability/a = playerData.playerAbilities.Find(toRem)
		if(a.abilityLevel > 1)
			a.abilityLevel--
		else
			playerData.playerAbilities.Remove(toRem)
			for(var/obj/spellHolder/s in playerSpellHolders)
				if(s.heldAbility == toRem)
					playerSpellHolders.Remove(s)

/mob/player/proc/descChange(var/extra)
	playerData.playerDesc = ""

	if(extra)
		playerData.playerExtraDesc += extra
	playerData.playerDesc += "<br>[playerData.playerName] is a [playerData.returnGender()] [playerData.playerRace.raceName].<br>"
	playerData.playerDesc += "[playerData.playerName] has both <font color=[playerData.eyeColor]>eyes</font>.<br>"
	for(var/s in playerData.playerExtraDesc)
		playerData.playerDesc += s
		playerData.playerDesc += "<br>"

/mob/player/proc/descRemove(var/what)
	playerData.playerExtraDesc -= what
	descChange()

/mob/player/proc/rerollStats(var/prompt=TRUE)
	var/min = 2
	var/max = 17
	//min/max are minus 1 for 1 starting score
	playerData.def.setTo(rand(min,max))
	playerData.str.setTo(rand(min,max))
	playerData.dex.setTo(rand(min,max))
	playerData.con.setTo(rand(min,max))
	playerData.wis.setTo(rand(min,max))
	playerData.int.setTo(rand(min,max))
	playerData.cha.setTo(rand(min,max))
	playerData.save.setTo(rand(min,max))
	playerData.fort.setTo(rand(min,max))
	playerData.ref.setTo(rand(min,max))
	playerData.will.setTo(rand(min,max))
	if(prompt)
		var/statAsString = ""
		for(var/datum/stat/S in playerData.playerStats)
			if(!S.isLimited)
				statAsString += "[S.statName]: [S.statModified]\n"
		statAsString += "\nKeeping the stats will confirm your character, locking you from changing it further."
		var/answer = alert(src,statAsString,"Keep these stats?","Keep","Back","Reroll")
		if(answer == "Reroll")
			if(hasReroll)
				rerollStats()
		if(answer == "Back")
			for(var/datum/stat/S in playerData.playerStats)
				S.revert(TRUE)
			src.playerSheet()
		else
			hasReroll = FALSE

/mob/player/verb/viewInventory()
	set name = "Open Inventory"
	var/html = "<title>Inventory</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	for(var/obj/item/I in playerInventory)
		html += "<b>[I.name]</b>: [I.stackSize] ([!isWorn(I) ? "<a href=?src=\ref[src];function=dropitem;item=\ref[I]><i>Drop</i></a>" : ""][isWearable(I) && !isWorn(I) ? " | <a href=?src=\ref[src];function=wearitem;item=\ref[I]><i>Equip</i></a>" : "<a href=?src=\ref[src];function=removeitem;item=\ref[I]><i>Remove</i></a>"])<br>"
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

/mob/player/proc/classChange(var/datum/class/toWhat)
	playerData.playerClass = new toWhat
	for(var/datum/class/R in typesof(/datum/class))
		var/datum/class/testOn = new R
		for(var/datum/ability/A in testOn.classAbilities)
			playerData.playerAbilities.Remove(A)
			for(var/obj/spellHolder/s in playerSpellHolders)
				if(s.heldAbility == A)
					playerSpellHolders.Remove(s)
	playerData.assignClass(toWhat)
	updateSpellHolders()

/mob/player/proc/updateSpellHolders()
	for(var/s in playerSpellHolders)
		if(!playerData.playerAbilities.Find(s))
			playerSpellHolders.Remove(s)

	for(var/A in playerData.playerAbilities)
		addPlayerAbility(new A)

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

/mob/player/proc/addToInventory(var/obj/item/what)
	for(var/obj/item/a in playerInventory)
		if(a.uuid == what.uuid)
			a.stackSize++
			del(what)
			return
	playerInventory += what
	what.loc = src

/mob/player/proc/inventoryContains(var/obj/item/what)
	for(var/obj/item/a in playerInventory)
		if(a.uuid == what.uuid)
			return TRUE
	return FALSE

/mob/player/proc/remFromInventory(var/obj/item/what)
	for(var/obj/item/a in playerInventory)
		if(a.uuid == what.uuid)
			if(a.stackSize > 1)
				a.stackSize--
				new a.type(src.loc)
				return
	playerInventory -= what
	what.loc = src.loc

/mob/player/proc/equipItem(var/obj/item/what)
	var/space = TRUE
	for(var/obj/item/I in playerEquipped)
		if(I.slot == what.slot)
			space = FALSE
	if(space)
		src.playerEquipped |= what
		updateStats()
		refreshIcon(playerData.playerRacePrefix)

/mob/player/proc/unEquipItem(var/obj/item/what)
	src.playerEquipped.Remove(what)
	for(var/datum/stat/S in playerData.playerStats)
		for(var/A in what.stats)
			if(A == S.statName)
				if(S.affecting.Find(what))
					S.remFrom(what.stats[A])
					S.affecting.Remove(what)
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

/////////////////////////////- END OF CUSTOM PROCS- /////////////////////////////////

/mob/player/Topic(href,href_list[])
	var/function = href_list["function"]
	switch(function)
		if("name")
			nameChange(input(src,"Choose your name") as text)
			src.playerSheet()
		if("race")
			var/choice = input(src,"Choose your Race") as anything in list("Human","Golem","Lizard","Slime","Pod","Fly","Jelly","Ape","Spider","Spidertaur","Robot","Hologram")
			var/chosen = text2path("/datum/race/[choice]")
			raceChange(chosen)
			nameChange(src.playerData.playerName)
			src.playerSheet()
		if("class")
			var/choice = input(src,"Choose your Class") as anything in list("Assistant","Engineer","Doctor","Chef","Botanist","Scientist","Captain","Officer")
			var/chosen = text2path("/datum/class/[choice]")
			classChange(chosen)
			src.playerSheet()
		if("gender")
			genderChange(input(src,"Choose your Gender") as null|anything in list ("Male","Female","Custom"))
			nameChange(src.playerData.playerName)
			src.playerSheet()
		if("eyes")
			eyeChange(input(src,"Choose your Eye Color") as color)
			src.playerSheet()
		if("haircolor")
			var/colored = input(src,"Choose your Hair Color") as color
			if(colored)
				hairChange(playerData.playerHair,playerData.playerFacial,colored)
			src.playerSheet()
		if("sethair")
			var/hairstyle = input(src,"Choose your Hairstyle") as null|anything in playerValidHair
			if(hairstyle)
				hairChange(hairstyle,playerData.playerFacial,playerData.hairColor)
			src.playerSheet()
		if("setfacial")
			var/facial = input(src,"Choose your Facial Style") as null|anything in playerValidFacial
			if(facial)
				hairChange(playerData.playerHair,facial,playerData.hairColor)
			src.playerSheet()
		if("desc")
			descChange(input(src,"Describe anything extra about your character") as text)
			src.playerSheet()
		if("descdelete")
			descRemove(input(src,"Remove what character note?") as null|anything in playerData.playerExtraDesc)
			src.playerSheet()
		if("dropitem")
			src.remFromInventory(locate(href_list["item"]))
			src.viewInventory()
		if("wearitem")
			equipItem(locate(href_list["item"]))
			src.viewInventory()
		if("removeitem")
			unEquipItem(locate(href_list["item"]))
			src.viewInventory()
		if("statroll")
			rerollStats()
			src.playerSheet()
		if("statkeep")
			hasReroll = FALSE
			src.playerSheet()