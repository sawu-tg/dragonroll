/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/uuid = "item_default" //unique item identifier
	var/list/stats = list()
	var/slot //eyes, head, chest, groin, l_hand, r_hand, l_foot, r_foot, l_arm, r_arm, l_leg, r_leg, l_shoulder, r_shoulder

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

//items

/obj/item/corgisuit
	name = "corgi suit"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "corgi_suit"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/duster_glasses
	name = "duster glasses"
	slot = "eyes"
	icon = 'sprite/clothing/face.dmi'
	icon_state = "visor"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/dustercoat
	name = "duster coat"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "coat"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/duster_pants
	name = "duster pants"
	slot = "groin"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "coat_legs"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/duster_shoe_left
	name = "duster shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "boots_l"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/duster_shoe_right
	name = "duster shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "boots_r"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/punk_hat
	name = "punk hat"
	slot = "head"
	icon = 'sprite/clothing/head.dmi'
	icon_state = "technicolor"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/punk_coat
	name = "punk coat"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "punk"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/punk_pants
	name = "punk pants"
	slot = "groin"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "punk_legs"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/punk_shoe_left
	name = "punk shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "autolace_l"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/punk_shoe_right
	name = "punk shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "autolace_r"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/streetarmor
	name = "street armor"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "streetarmor"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/streetarmor_pants
	name = "street armor pants"
	slot = "groin"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "streetarmor_legs"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/streetarmor_glove_left
	name = "street armor glove left"
	slot = "l_hand"
	icon = 'sprite/clothing/hands.dmi'
	icon_state = "streetarmor_l"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/streetarmor_glove_right
	name = "street armor glove right"
	slot = "r_hand"
	icon = 'sprite/clothing/hands.dmi'
	icon_state = "streetarmor_r"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/streetarmor_shoe_left
	name = "streetarmor shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "streetarmor_l"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/streetarmor_shoe_right
	name = "streetarmor shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "streetarmor_r"
	stats = list("Health" = 10, "Constitution" = 5)

/obj/item/corgihat
	name = "corgi hood"
	slot = "head"
	icon = 'sprite/clothing/head.dmi'
	icon_state = "corgi_hood"
	stats = list("Mana" = 10, "Wisdom" = 5)