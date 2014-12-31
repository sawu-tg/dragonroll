/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/uuid = "item_default" //unique item identifier

/obj/item/New()
	uuid = name

/obj/item/verb/takeItem()
	set name = "Take Item"
	set src in oview(1)
	var/mob/player/p = usr
	layer = LAYER_DEFAULT
	p.addToInventory(src)

/obj/item/DblClick()
	takeItem()