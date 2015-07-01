/datum/controller/diplomacy
	name = "Diplomacy"
	execTime = 60

	var/list/currTypes = list()
	var/list/currInflation = list()

/datum/controller/diplomacy/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Factions: [globalFactions.len])")

/datum/controller/diplomacy/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Factions: [globalFactions.len])"

/datum/controller/diplomacy/doProcess()
	scheck()

////
// VARIOUS UNSORTED DIPLOMACY GUBBINS
////

/obj/structure/vendomat
	name = "Vend-o-Mat"
	desc = "Sells all sorts of useful things"
	icon_state = "behemoth"
	icon = 'sprite/mob/mob.dmi'
	var/heldMoney
	helpInfo = "You can trade a factions currency to these machines, and recieve items!"

/obj/structure/vendomat/New()
	..()
	spawn(30)
		mobFaction = findFaction("Colonist")
		heldMoney = rand(100,1000)
		name = "[mobFaction.name] [initial(name)]"

/obj/structure/vendomat/proc/showBuyWindow(var/mob/player/P)
	var/inflation = diplomacy.currInflation[mobFaction.name]
	var/html = "<title>[src.name]</title><html><center><body style='background:grey'><br>"
	html += "$: [heldMoney]<br>"
	for(var/obj/item/B in contents)
		html += "<a href=?src=\ref[src];tosell=\ref[B]>[B]: [B.worth*inflation]$</a><br>"
	P << browse(html,"window=vendomatic")

/obj/structure/vendomat/objFunction(var/mob/player/P, var/obj/item/I)
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
				mobFaction.giveCurrency(P,0,I)
		else
			messageError("The [src] already has too many [I]s!",P,src)
	else
		showBuyWindow(P)

/obj/structure/vendomat/Topic(href,href_list[])
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

////

/obj/item/loot/gold
	name = "Gold Piece"
	desc = "It shines with an alluring luster."
	stackSize = 1 // The amount of objects held with it
	showAsLoot = FALSE // Whether the object is shown with a loot_icon

/obj/item/loot/gold/New(var/turf/T)
	..(T)
	if(T)
		stackSize = rand(1,25)
	update_icon()

/obj/item/loot/gold/objFunction(var/mob/player/P, var/obj/item/I)
	if(!I)
		var/count = input(P,"Take amount?") as num
		if(count)
			if(stackSize - count > 0)
				var/obj/item/loot/gold/G = new(get_turf(src))
				G.stackSize = count
				G.update_icon()
				return
			else
				messageInfo("You don't have enough to take [count]!")
				return
	else
		if(istype(I,src.type))
			stackSize += I:stackSize
			update_icon()
			sdel(I)


/obj/item/loot/gold/proc/changeAmt(var/amount)
	if(stackSize + amount < 0)
		return
	if(amount)
		stackSize += amount
		update_icon()

/obj/item/loot/gold/update_icon()
	..()
	overlays.Cut()
	var/count = max(1,round(stackSize/10))
	if(count > 1)
		name = "[stackSize] [initial(name)]s"
	else
		name = "[initial(name)]"
	for(var/i = 0; i < min(50,count); ++i)
		var/modifier = rand(-45,45)
		var/tint = rgb(((255+modifier)*(i+3))/4,((255+modifier)*(i+3))/4,0)
		var/image/II = image('sprite/obj/items.dmi',icon_state = "mat_sphere")
		II.color = tint
		II.pixel_y = rand(-5,5) + (i/8)
		II.pixel_x = rand(-5,5)
		overlays += II