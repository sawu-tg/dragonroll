/datum/controller/diplomacy
	name = "Diplomacy"
	execTime = 60

	var/currType

/datum/controller/diplomacy/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])")

/datum/controller/diplomacy/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])"

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
	update_icon()

/obj/item/loot/gold/verb/addMoney()
	set src in view()
	var/amount = input("Change by how?") as num
	if(amount)
		stackSize += amount
		update_icon()
		usr << "[src] now contains [stackSize] pieces!"

/obj/item/loot/gold/update_icon()
	..()
	overlays.Cut()
	var/count = max(1,round(stackSize/10))
	if(count > 1)
		name = "[initial(name)]s"
	else
		name = "[initial(name)]"
	for(var/i = 0; i < min(25,count); ++i)
		var/modifier = rand(-45,45)
		var/tint = i <= 3 ? rgb(255,255,0) : rgb((45+modifier)*(i+3),(45+modifier)*(i+3),0)
		var/image/II = image('sprite/obj/items.dmi',icon_state = "mat_sphere")
		II.color = tint
		II.pixel_y = rand(-5,5)
		II.pixel_x = rand(-5,5)
		overlays += II