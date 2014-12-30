/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/uuid = "item_default" //unique item identifier

/obj/item/New()
	uuid = name

/obj/item/DblClick()
	var/mob/player/p = usr
	p.addToInventory(src)