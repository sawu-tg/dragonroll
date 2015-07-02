/mob/vendomat
	name = "Vend-o-Mat"
	desc = "Sells all sorts of useful things"
	icon_state = "behemoth"
	icon = 'sprite/mob/mob.dmi'
	helpInfo = "You can trade a factions currency to these machines, and recieve items!"

/mob/vendomat/New()
	..()
	spawn(30)
		mobFaction = findFaction("Colonist")
		heldMoney = rand(100,1000)
		name = "[mobFaction.name] [initial(name)]"
		myChat = new/datum/chat/vendomat

/// TRADE AND DIALOG HANDLING

/mob
	var/heldMoney

/mob/New()
	..()
	heldMoney = rand(100,1000)

/mob/proc/showBuyWindow(var/mob/player/P)
	var/inflation = diplomacy.currInflation[mobFaction.name]
	var/html = "<title>[src.name]</title><html><center><body style='background:grey'><br>"
	html += "Vendor: [round(heldMoney)]<br>"
	for(var/obj/item/B in contents)
		html += "<a href=?src=\ref[src];tosell=\ref[B]>[B]: [round(B.worth*inflation)]$</a><br>"
	P << browse(html,"window=vendomatic")

/mob/proc/doTrade(var/mob/player/P, var/obj/item/I)
	if(!P)
		P = usr
	if(!I)
		return
	if(I)
		var/willbuy = TRUE
		var/modifier = 1
		for(var/C in contents)
			if(C:type == I.type)
				modifier -= 0.1
		if(modifier > 0)
			willbuy = TRUE
		if(willbuy)
			I.worth *= modifier
			I.worth = round(I.worth)
			if(I.worth > heldMoney)
				messageError("The [src] doesn't have enough currency for that!",P,src)
			else
				heldMoney -= I.worth
				P.DropItem()
				new I.type(src)
				messageInfo("You trade [src] the [I]",P,src)
				mobFaction.giveCurrency(P,0,I)
		else
			messageError("The [src] already has too many [I]s!",P,src)
	else
		showBuyWindow(P)

/mob/Topic(href,href_list[])
	..()
	if(href_list["opentrade"])
		lastChatted.showBuyWindow(usr)
	var/tosell = href_list["tosell"]
	if(tosell)
		var/obj/item/I = locate(tosell)
		var/inflation = diplomacy.currInflation[mobFaction.name]
		if(I)
			var/rounded = round(I.worth*inflation)
			if(mobFaction.doTransaction(usr,rounded))
				usr:addToInventory(I)
				heldMoney += rounded
				showBuyWindow(usr)