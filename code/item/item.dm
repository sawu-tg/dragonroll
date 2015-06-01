/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/showAsLoot = FALSE
	var/loot_icon = 'sprite/obj/items.dmi' //icon of the item ont he floor
	var/loot_icon_state = "loot" //state of the item on the floor
	var/list/stats = list()
	var/slot //eyes, head, chest, groin, l_hand, r_hand, l_foot, r_foot, l_arm, r_arm, l_leg, r_leg, l_shoulder, r_shoulder

/obj/item/New()
	..()
	if(showAsLoot)
		icon = loot_icon
		icon_state = loot_icon_state