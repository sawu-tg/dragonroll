/obj/item/armor
	name = "default armor"
	desc = "protects a man against his problems"
	showAsLoot = TRUE
	var/armorRating = 1

/obj/item/armor/New()
	..()
	stats["ar"] = armorRating

//armor

/obj/item/armor/corgisuit
	name = "corgi suit"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "corgi_suit"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/duster_glasses
	name = "duster glasses"
	slot = "eyes"
	icon = 'sprite/clothing/face.dmi'
	icon_state = "visor"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/dustercoat
	name = "tanned coat"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "coat"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/duster_pants
	name = "tanned pants"
	slot = "groin"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "coat_legs"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/duster_shoe_left
	name = "tanned shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "boots_l"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/duster_shoe_right
	name = "tanned shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "boots_r"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/punk_hat
	name = "punk hat"
	slot = "head"
	icon = 'sprite/clothing/head.dmi'
	icon_state = "technicolor"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/punk_coat
	name = "punk coat"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "punk"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/punk_pants
	name = "punk pants"
	slot = "groin"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "punk_legs"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/punk_shoe_left
	name = "punk shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "autolace_l"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/punk_shoe_right
	name = "punk shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "autolace_r"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/streetarmor
	name = "street armor"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "streetarmor"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/streetarmor_pants
	name = "street armor pants"
	slot = "groin"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "streetarmor_legs"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/streetarmor_glove_left
	name = "street armor glove left"
	slot = "l_hand"
	icon = 'sprite/clothing/hands.dmi'
	icon_state = "streetarmor_l"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/streetarmor_glove_right
	name = "street armor glove right"
	slot = "r_hand"
	icon = 'sprite/clothing/hands.dmi'
	icon_state = "streetarmor_r"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/streetarmor_shoe_left
	name = "streetarmor shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "streetarmor_l"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/streetarmor_shoe_right
	name = "streetarmor shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "streetarmor_r"
	stats = list("hp" = 10, "con" = 5)

/obj/item/armor/corgihat
	name = "corgi hood"
	slot = "head"
	icon = 'sprite/clothing/head.dmi'
	icon_state = "corgi_hood"
	stats = list("mp" = 10, "wis" = 5)

///
// ACTUAL FUCKING GAME ARMOR
///

/obj/item/armor/jerkin
	name = "leather jerkin"
	slot = "chest"
	icon = 'sprite/clothing/tg/uniform.dmi'
	icon_state = "brown_s"

/obj/item/armor/leather_boot_left
	name = "leather shoe left"
	slot = "l_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "winterboots_l"

/obj/item/armor/leather_boot_right
	name = "leather shoe right"
	slot = "r_foot"
	icon = 'sprite/clothing/feet.dmi'
	icon_state = "winterboots_r"