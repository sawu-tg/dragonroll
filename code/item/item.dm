/obj/item
	name = "default item"
	desc = "not very interesting"
	var/stackSize = 1
	var/uuid = "item_default" //unique item identifier
	var/list/stats = list()
	var/slot //eyes, head, chest, groin, l_hand, r_hand, l_foot, r_foot, l_arm, r_arm, l_leg, r_leg, l_shoulder, r_shoulder

/obj/item/New()
	uuid = name