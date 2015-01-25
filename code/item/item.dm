/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/uuid = "item_default" //unique item identifier
	var/list/stats = list()
	var/slot //eyes, head, chest, groin, l_hand, r_hand, l_foot, r_foot, l_arm, r_arm, l_leg, r_leg, l_shoulder, r_shoulder
	var/prevent_pickup = 0

/obj/item/New()
	uuid = name

/obj/item/verb/takeItem()
	set name = "Take Item"
	set src in oview(1)
	var/mob/player/p = usr
	layer = LAYER_DEFAULT
	p.addToInventory(src)

/obj/item/DblClick()
	..()
	if(!prevent_pickup)
		takeItem()