var/list/globalFactions = list()

/proc/findFaction(var/name)
	if(name)
		for(var/datum/faction/F in globalFactions)
			if(F.name == name)
				return F
	messageSystemAll("Cannot find Faction: [name] (findFaction check)")
	return null

/proc/findOwned(var/mob/player/P)
	for(var/datum/faction/F in globalFactions)
		var/FF = F.factionOwners.Find(P)
		if(FF)
			return F
	return null

/proc/setupFactions()
	for(var/A in typesof(/datum/faction) - /datum/faction)
		globalFactions += new A

/datum/faction
	var/name = "Neutral"
	var/list/friendlyTo = list() // who the faction is friendly to
	var/list/hostileTo = list() // who the faction is hostile to
	var/icon/factionImage // the image of the faction
	var/factionThreshold = 1000 // the extent of which a reputation can change
	var/angerThreshold = -250 // what the standing of a faction to another has to be to trigger a change
	var/happyThreshold = 250 // the same as above, but in reverse
	var/list/fStandings = list() // an associative list of the standings of other factions
	var/currencyType // the currency the faction uses
	var/mob/player/factionCreator
	var/list/factionMembers = list()
	var/list/factionOwners = list() // a list of people authorized to modify the faction

/datum/faction/New()
	..()
	factionImage = new('sprite/obj/flags.dmi',icon_state = pick(icon_states('sprite/obj/flags.dmi')))
	spawn(10)
		for(var/A in friendlyTo)
			fStandings[A] = happyThreshold + (happyThreshold/2)
		for(var/A in hostileTo)
			fStandings[A] = angerThreshold + (angerThreshold/2)
	setCurrencyType(/obj/item/loot/gold)

/datum/faction/garbageCleanup()
	..()
	friendlyTo = null
	hostileTo = null


//Use this to take money!
/datum/faction/proc/doTransaction(var/mob/player/P,var/cost)
	cost *= diplomacy.currInflation[name]
	cost = round(cost)
	if(!hasEnoughCurrency(P,cost))
		messageError("You don't have enough money for that!",P,P)
		return FALSE
	else
		giveMedal("It's worth something?",P)
		takeCurrency(P,cost)
		return TRUE

//use this to sell items!
/datum/faction/proc/giveCurrency(var/mob/player/P,var/extra,var/obj/item/sold)
	var/amount = extra
	if(sold)
		amount += sold.worth
		sdel(sold)
	amount *= diplomacy.currInflation[name]
	diplomacy.currInflation[name] += (amount/100)
	for(var/B in P.contents)
		if(B:type == currencyType)
			B:changeAmt(amount)
			B:update_icon()
			amount = 0
	if(amount != 0)
		var/A = new currencyType(get_turf(P))
		A:stackSize = amount
		A:update_icon()
		P.addToInventory(A)


/datum/faction/proc/hasEnoughCurrency(var/mob/player/P,var/cost)
	var/total = 0
	for(var/obj/item/A in P.contents)
		if(!istype(A,currencyType))
			continue
		if(A.stackSize > 1)
			total += A.stackSize
		else
			total++
	if(total >= cost)
		return TRUE
	return FALSE

/datum/faction/proc/takeCurrency(var/mob/player/P,var/cost)
	var/list/valid = list()
	diplomacy.currInflation[name] -= (cost/100)
	while(cost > 0)
		for(var/obj/item/A in P.contents)
			if(A.stackSize > 0)
				A.changeAmt(-1)
				--cost
				A.update_icon()
				if(A.stackSize <= 0)
					valid += A
			else
				valid += A
	for(var/obj/item/B in valid)
		sdel(B)

/datum/faction/proc/setCurrencyType(var/type)
	currencyType = type
	diplomacy.currTypes[name] = type
	if(!diplomacy.currInflation[name])
		diplomacy.currInflation[name] = 1

/datum/faction/proc/addStanding(var/datum/faction/F,var/amount)
	if(F.name == name) // NO BULLY
		return
	if(!fStandings[F.name])
		fStandings[F.name] = amount
	else
		if(fStandings[F.name] + amount > factionThreshold || fStandings[F.name] + amount < -factionThreshold)
			fStandings[F.name] = amount > 0 ? factionThreshold : -factionThreshold
		else
			fStandings[F.name] += amount
	if(fStandings[F.name] < angerThreshold)
		if(!isHostile(F))
			hostileTo += F.name
			messageWarningAll("[name] is now hostile to [F.name]!")
		if(isFriendly(F))
			friendlyTo -= F.name
	if(fStandings[F.name] > happyThreshold)
		if(!isFriendly(F))
			friendlyTo += F.name
			messageWarningAll("[name] is now friendly with [F.name]!")
		if(isHostile(F))
			hostileTo -= F.name


///
// Checks whether a faction is hostile to the given faction
///
/datum/faction/proc/isHostile(var/datum/faction/F)
	if(!F)
		messageSystemAll("Invalid faction [F] passed to isHostile check")
		return
	for(var/FA in hostileTo)
		if(FA == F.name)
			return TRUE
	return FALSE

///
// Checks whether a faction is friendly to the given faction
///
/datum/faction/proc/isFriendly(var/datum/faction/F)
	if(!F)
		messageSystemAll("Invalid faction [F] passed to isFriendly check")
		return
	if(F.name == name)
		return TRUE
	for(var/FA in friendlyTo)
		if(FA == F.name)
			return TRUE
	return FALSE

/proc/makeFlag(var/I)
	var/icon/work
	work = new(I)
	work.Scale(64,32)
	return work


///////////// FACTION VERBS ////////////////////

/mob/verb/createFaction()
	set name = "Create Faction"
	set category = "Factions"
	if(!findOwned(src))
		var/fName = input("Name your faction") as text
		var/fImage
		var/custFlag = input("Do you want to use a custom flag?") as null|anything in list("Yes", "No")
		if(custFlag)
			if(custFlag == "Yes")
				fImage = input("Choose an Icon") as icon
			else
				fImage = input("Pick your Image") as null|anything in icon_states('sprite/obj/flags.dmi')
		if(!fImage)
			messageError("You need to pick a flag icon!",src,src)
			return
		if(fName && fImage)
			var/datum/faction/F = new
			F.name = fName
			F.factionOwners += src
			F.factionCreator = src
			F.factionMembers |= src
			if(istext(fImage))
				F.factionImage = new('sprite/obj/flags.dmi',icon_state = fImage)
			else
				F.factionImage = makeFlag(fImage)
			globalFactions += F
			giveMedal("Ready to Rule!",src)
			messageInfo("[F.name] created!",src,src)
	else
		messageError("You already own a faction!", src, src)

/mob/proc/forceJoinFaction(var/factionName)
	if(factionName)
		mobFaction = findFaction(factionName)
		mobFaction.factionMembers |= src


/mob/verb/joinFaction()
	set name = "Join Faction"
	set category = "Factions"
	if(!findOwned(src))
		var/list/valid = list()
		if(src.mobFaction)
			src.mobFaction.factionMembers -= src
		for(var/datum/faction/F in globalFactions)
			valid += F.name
		var/fName = input("Choose a Faction") as null|anything in valid
		if(fName)
			forceJoinFaction(fName)
	else
		messageError("You own a faction!", src, src)

/mob/verb/adjustFaction()
	set name = "Modify Faction Standing"
	set category = "Factions"
	var/datum/faction/F = input("Who's standing?") as null|anything in globalFactions
	if(F)
		var/datum/faction/FF = input("With who?") as null|anything in globalFactions
		if(FF)
			var/amt = input("Shift amount?") as num
			if(amt)
				FF.addStanding(F,amt)

/mob/verb/debugFactions()
	set name = "View Factions"
	set category = "Factions"
	var/html = "<title>Factions</title><html><center><body style='background:grey'>"
	for(var/datum/faction/D in globalFactions)
		html += "<b>===============</b><br>"
		html += "[parseIcon(src,D.factionImage,FALSE)]<br>"
		html += "<b>[D.name]</b><br>"
		var/CC = new D.currencyType()
		html += "<b>Currency:</b> [CC]<br>"
		html += "<b>Members:</b> [D.factionMembers.len]<br>"
		html += "<b>Inflation: </b> [diplomacy.currInflation[D.name]]<br>"
		sdel(CC)
		if(D.hostileTo.len)
			html += "<i><b>~</b>Hostile To<b>~</b></i><br>"
			for(var/A in D.hostileTo)
				html += "[A]: [D.fStandings[A]]<br>"
		if(D.friendlyTo.len)
			html += "<i><b>~</b>Friendly To<b>~</b></i><br>"
			for(var/A in D.friendlyTo)
				html += "[A]: [D.fStandings[A]]<br>"
		if(D.factionOwners.len)
			html += "<i><b>~</b>Leaders<b>~</b></i><br>"
			for(var/A in D.factionOwners)
				html += "[A]<br>"
	html += "</body></center></html>"
	var/datum/browser/popup = new(usr, "factionsheet", "Factions")
	popup.set_content(html)
	popup.open()

///////////// FACTIONS /////////////////////////

/datum/faction/colonist
	name = "Colonist"
	hostileTo = list("Hostile")
	friendlyTo = list("Wildlife")

/datum/faction/wildlife
	name = "Wildlife"
	hostileTo = list("Hostile")
	friendlyTo = list("Colonist")

/datum/faction/generic_hostile
	name = "Hostile"
	hostileTo = list("Wildlife", "Colonist")

/datum/faction/grey
	name = "Mothership"
	hostileTo = list("Wildlife", "Colonist","Hostile")