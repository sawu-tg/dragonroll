/obj/furniture
	name = "furniture"
	desc = "don't sit on me.. maybe"
	icon = 'sprite/furniture.dmi'

/obj/furniture/chest
	name = "Chest"
	desc = "Contains Loot, most of the time."
	icon_state = "chest_close"
	var/chestOpen = 0

/obj/furniture/chest/objFunction(var/mob/user)
	chestOpen = !chestOpen
	displayInfo("You [chestOpen ? "open" : "close"] the [src]","[user] [chestOpen ? "opens" : "closes"] the [src]",user,src)
	icon_state = "chest[chestOpen ? "_open" : "_close"]"