/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/uuid = "item_default" //unique item identifier
	var/list/stats = list()
	var/slot //head, chest, groin, l_hand, r_hand, l_foot, r_foot, l_arm, r_arm, l_leg, r_leg, l_shoulder, r_shoulder

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

/obj/item/corgisuit
	name = "corgi suit"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "corgi_suit"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/corgihat
	name = "corgi hood"
	slot = "chest"
	icon = 'sprite/clothing/head.dmi'
	icon_state = "corgi_hood"
	stats = list("Mana" = 10, "Wisdom" = 5)