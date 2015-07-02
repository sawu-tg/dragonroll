/mob/player
	name = "unnamed"
	icon = 'sprite/mob/human.dmi'
	icon_state = "skeleton_s"
	var/datum/playerFile/playerData = new

	var/list/playerInventory = list()
	var/list/playerEquipped = list()
	var/list/playerOrgans = list()

	var/list/persistingEffects = list()

	var/datum/statuseffect/deadeffect //The effect applied when you're at or below 0 hp

	var/isMonster = FALSE // is the player a monster race?
	var/actualIconState = "blank"

	var/list/playerSpellHolders = list()
	var/list/defaultItems = list(/obj/item/armor/jerkin,/obj/item/armor/leather_boot_left,/obj/item/armor/leather_boot_right)

	var/lastClick

	var/doesProcessing = TRUE // does the player get added to processing
	var/hasReroll = TRUE
	size = 3
	reagentSize = 100
	weight = 5
	var/actualSpeed = 1 //the actual speed
	var/speed = 1 // the speed they move at

	var/debugModeOn = FALSE

	var/list/playerEnc = list() // a list of all remembered encyclopedia entries
	var/chosenEncIndex

	var/beingRezzed = FALSE


/mob/player/garbageCleanup()
	..()

	if(playerData)
		sdel(playerData)
		playerData = null

	for(var/datum/D in playerInventory)
		sdel(D)
	playerInventory = null

	for(var/datum/D in playerEquipped)
		sdel(D)
	playerEquipped = null

	for(var/datum/organ/O in playerOrgans)
		sdel(O)
	playerOrgans = null

	for(var/datum/statuseffect/SE in statuseffects)
		sdel(SE)

	statuseffects = null

	persistingEffects = null //I don't think this does anything yet, but null it anyways

	if(deadeffect)
		sdel(deadeffect)
		deadeffect = null

	playerList -= src

	for(var/obj/spellHolder/SH in playerSpellHolders)
		sdel(SH)
	playerSpellHolders = null

/mob/player/proc/defaultOrgans()
	playerOrgans |= new/datum/organ/l_arm(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/r_arm(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/l_leg(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/r_leg(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/chest(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/head(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/brain(playerData.playerRace,src)
	playerOrgans |= new/datum/organ/heart(playerData.playerRace,src)

/mob/player/New()
	..()
	if(doesProcessing)
		addProcessingObject(src)
	//selectedQuickSlot = leftHand
	randomise()
	set_light(6)
	for(var/A in defaultItems)
		var/obj/item/AB = new A()
		addToInventory(AB)
		equipItem(AB)

	add_pane(/datum/windowpane/stats)
	add_pane(/datum/windowpane/abilities)
	add_pane(/datum/windowpane/inventory)

	///
	defaultOrgans()
	///
	spawn(20)
		refreshIcon(playerData.playerRacePrefix)
		playerList += src
	..()

/mob/player/Cross(atom/movable/O)
	if(layingDown)
		return 1

	return ..()

/mob/player/proc/harvest()
	var/turf/srcLoc = get_turf(src)
	for(var/obj/item/I in src)
		unEquipItem(I)
		if(!isMonster)
			I.loc = srcLoc
		else
			if(!I.lootForm)
				I.lootForm = I.type
			var/type = I.lootForm
			new type(srcLoc)
			sdel(I)

/mob/player/proc/revive()
	gibSelf()
	playerOrgans.Cut()
	defaultOrgans()

	healDamage(99999)
	healMana(99999)

	for(var/datum/statuseffect/S in statuseffects)
		remStatusEffect(S)

/mob/player/objFunction(var/mob/user,var/obj/inHand)
	if(checkEffectStack("dead"))
		messagePlayer("You remove some items from [src]",user,src)
		harvest()
		return
	..()

/mob/player/verb/setview()
	set name = "Change View Range"
	set category = "Debug Verbs"
	client.view = input(src,"Set View Range") as num

//Saycode, brutally mashed together by MrSnapwalk.

/proc/get_hear(range, source)
	var/list/heard = view(range, source)
	return heard

/mob/proc/hear(msg, var/source)
	messageChat(src,"[msg]")

/mob/player/verb/say(msg as text)
	set name = "Say"
	set category = "Actions"
	var/message_range = 7
	var/list/listening = get_hear(message_range, usr)
	popup(msg)//we wanted unformatted speech
	msg = formatspeech(msg)
	for (var/mob/M in listening)
		M.hear(msg, usr)

/mob/player/proc/healDamage(var/amount)
	if(playerData.hp.statCurr < playerData.hp.statModified)
		popup("HP+: [amount]",COL_FRIENDLY)
	playerData.hp.change(amount)

/mob/player/proc/healMana(var/amount)
	if(playerData.hp.statCurr < playerData.hp.statModified)
		popup("MP+: [amount]",COL_FRIENDLY)
	playerData.mp.change(amount)

/mob/player/proc/takeDamage(var/amount,var/type=DTYPE_MELEE)
	var/damage = max(0,type == DTYPE_DIRECT ? amount : amount - playerData.def.statCurr)
	var/doDamage = FALSE

	var/soundToPlay = "punch"

	if(damage == 0)
		return 0

	if(damage > playerData.con.statCurr)
		if(type == DTYPE_NONLETHAL)
			if(!savingThrow(src,0,SAVING_FORTITUDE))
				addStatusEffect(/datum/statuseffect/disabled,15)
			else
				addStatusEffect(/datum/statuseffect/dazed,15)
		else
			type = DTYPE_MASSIVE

	if(type == DTYPE_ENVIRONMENT)
		doDamage = TRUE
		soundToPlay = "rustle"

	if(type == DTYPE_MAGIC)
		doDamage = TRUE
		//something something magical armor oven
		soundToPlay = "sear"

	if(type == DTYPE_MELEE || type == DTYPE_DIRECT)
		doDamage = TRUE

	if(type == DTYPE_MASSIVE)
		soundToPlay = "swing_hit"
		if(!savingThrow(src,0,SAVING_FORTITUDE))
			playerData.hp.change(-(playerData.hp.statCurr + 1))
			src.popup("Massive hit! [damage]",COL_INFOTICK)
			doDamage = FALSE
		else
			doDamage = TRUE

	if(doDamage)
		spawn(rand(1,30))
			src.popup("Hit for [damage]",COL_HOSTILE)
		playerData.hp.change(-damage)
		for(var/datum/organ/O in playerOrgans)
			if(do_roll(1,playerData.con.statModified,playerData.str.statCurr) < damage)
				O.health -= damage
				var/heldName = O.name
				spawn(rand(1,30))
					src.popup("[heldName] takes [damage] damage!",COL_HOSTILE)
		playsound(get_turf(src), soundToPlay, 50, 1)
		var/dyingtype
		if(playerData.hp.statCurr == 0)
			dyingtype = /datum/statuseffect/disabled
		else if(playerData.hp.statCurr <= -1 && playerData.hp.statCurr >= -9)
			dyingtype = /datum/statuseffect/dying
		else if(playerData.hp.statCurr <= -10)
			dyingtype = /datum/statuseffect/dead
		if(!istype(deadeffect,dyingtype))
			src.remStatusEffect(deadeffect)
			deadeffect = src.addStatusEffect(dyingtype)
		return damage
	return 0

///
// BASIC FLAG STATES
///
/mob/player/proc/stun(var/amount)
	src.addStatusEffect(/datum/statuseffect/stun,amount)

/mob/player/proc/isDisabled()
	if(beingCarried)
		return TRUE
	if(thrown || thrownTarget || countedTimeout > 0)
		return TRUE
	if(checkEffectStack("no_move"))
		return TRUE
	if(checkEffectStack("no_act"))
		return TRUE
	if(checkEffectStack("dying"))
		return TRUE
	if(checkEffectStack("dead"))
		return TRUE
	return FALSE


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
	classChange(pick(text2path("/datum/class/[pick("assassin","manaweaver","whitepriest","hunter","herbalist","defender","knightcommander","blackpriest")]")))
	rerollStats(FALSE)

/mob/player/proc/nameChange(var/toName)
	if(toName)
		name = "[toName] the [playerData.returnGender()] [playerData.playerRace.raceName]"
		playerData.playerName = toName

/mob/player/proc/refreshIcon(var/prefix)
	icon_state = "blank"
	overlays.Cut()

	var/list/addedOverlays = list()
	var/state = icon_state
	if(isMonster)
		state = actualIconState
	else
		state = "[prefix]_[playerData.playerGenderShort]_s"
	var/image/player = image(icon,state)
	player.color = playerData.playerColor
	overlays |= player

	var/image/eyes = image(icon,playerData.playerRace.raceEyes)
	eyes.color = playerData.eyeColor

	addedOverlays |= playerData.playerRace.race_overlays
	addedOverlays |= eyes //fuck the what byond
	addedOverlays |= playerData.playerOverlays

	for(var/obj/item/I in playerEquipped)
		var/image/IMG = image(icon=initial(I.icon),icon_state = initial(I.icon_state))
		IMG.color = I.color
		IMG.alpha = I.alpha
		IMG.blend_mode = I.blend_mode
		addedOverlays |= IMG

	for(var/obj/interface/slot/S in handSlots)
		if(S.contents.len)
			var/sloticon
			if(S.id == "r_hand")
				sloticon = 'sprite/obj/items_righthand.dmi'
			else
				sloticon = 'sprite/obj/items_lefthand.dmi'
			var/obj/item/I = S.contents[1]
			var/image/IMG = image(icon=sloticon,icon_state = initial(I.icon_state))
			IMG.color = I.color
			IMG.alpha = I.alpha
			IMG.blend_mode = I.blend_mode
			addedOverlays |= IMG

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
		if(playerData.playerRace.icon)
			icon = playerData.playerRace.icon
		playerData.assignRace(playerData.playerRace)
		recalculateBaseStats()
		recalculateStats()
		for(var/datum/organ/O in playerOrgans)
			O.race = playerData.playerRace
			var/icon/I = getfile("sprite/mob/dismemberment/r_def_[lowertext(O.race.raceName)].dmi")
			if(I)
				O.icon = I
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
			playerData.customGenderA = input(src,"Please input your gender's pronoun (i.e He, She)") as text
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
	recalculateStats()

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
	var/max = 10
	//min/max are minus 1 for 1 starting score
	playerData.def.setBaseTo(rand(min,max))
	playerData.str.setBaseTo(rand(min,max))
	playerData.dex.setBaseTo(rand(min,max))
	playerData.con.setBaseTo(rand(min,max))
	playerData.wis.setBaseTo(rand(min,max))
	playerData.int.setBaseTo(rand(min,max))
	playerData.cha.setBaseTo(rand(min,max))
	playerData.save.setBaseTo(rand(min,max))
	playerData.fort.setBaseTo(rand(min,max))
	playerData.ref.setBaseTo(rand(min,max))
	playerData.will.setBaseTo(rand(min,max))

	recalculateBaseStats()
	recalculateStats()

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

	abilLoop: //Who wrote this and where does he live
		for(var/A in playerData.playerAbilities)
			//prevent duplicates
			for(var/obj/spellHolder/SH in playerSpellHolders)
				if(SH.heldAbility.type == A)
					continue abilLoop

			if(ispath(A))
				addPlayerAbility(new A)


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////- END OF CUSTOM PROCS- /////////////////////////////////

/mob/player/Topic(href,href_list[])
	..()
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
			var/choice = input(src,"Choose your Class") as anything in list("assassin","manaweaver","whitepriest","hunter","herbalist","defender","knightcommander","blackpriest")
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
		if("raise")
			var/stat = href_list["stat"]
			if(stat)
				if(src.playerData.playerStatPoints > 0)
					var/datum/stat/S = src.findStat(stat)
					S.setBaseTo(S.statBase + 1)
					src.playerData.playerStatPoints--
					recalculateBaseStats()
					recalculateStats()
			src.playerSheet()
		if("lower")
			var/stat = href_list["stat"]
			if(stat)
				var/datum/stat/S = src.findStat(stat)
				if(S.statBase > 1)
					S.setBaseTo(S.statBase - 1)
					src.playerData.playerStatPoints++
					recalculateBaseStats()
					recalculateStats()
			src.playerSheet()
		if("dropitem")
			src.remFromInventory(locate(href_list["item"]))
		if("wearitem")
			equipItem(locate(href_list["item"]))
		if("removeitem")
			unEquipItem(locate(href_list["item"]))
		if("useitem")
			var/obj/item/I = locate(href_list["item"])
			I.objFunction(src)
			playerInventory -= I
		if("statroll")
			rerollStats()
			src.playerSheet()
		if("statkeep")
			hasReroll = FALSE
			src.playerSheet()
		if("examine")
			var/mob/player/P = locate(href_list["what"])
			P.showPlayerSheet(src)
		if("togglestat")
			if(playerSheetPage < 2)
				playerSheetPage++
			else
				playerSheetPage = 0
			src.playerSheet()
		if("train")
			if(playerData.playerSkillPoints > 0)
				var/datum/ability/A = locate(href_list["skill"])
				if(A)
					if(A.abilityLevel+1 <= A.abilityMaxLevel)
						A.abilityLevel++
						playerData.playerSkillPoints--
			src.playerSheet()