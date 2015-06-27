/datum/controller/diplomacy
	name = "Diplomacy"
	execTime = 60

	var/currType

/datum/controller/diplomacy/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Factions: [globalFactions.len])")

/datum/controller/diplomacy/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Factions: [globalFactions.len])"

/datum/controller/diplomacy/doProcess()
	scheck()

////
// VARIOUS UNSORTED DIPLOMACY GUBBINS
////

/obj/item/loot/gold
	name = "Gold Piece"
	desc = "It shines with an alluring luster."
	stackSize = 1 // The amount of objects held with it
	showAsLoot = FALSE // Whether the object is shown with a loot_icon

/obj/item/loot/gold/New()
	..()
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