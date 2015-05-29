///
// Construction Parts
///

/obj/item/buildable
	name = "buildable"
	icon = 'sprite/obj/items.dmi'
	desc = "makes things"
	anchored = 1
	var/ofType

/obj/item/buildable/objFunction(var/mob/user)
	new ofType(src.loc)
	del(src)

/obj/item/buildable/woodenWall
	name = "wooden wall parts"
	desc = "It would keep things out if you actually built it."
	icon_state = "wood_tableparts"
	ofType = /turf/wall/woodWall

/obj/item/buildable/woodenDoor
	name = "wooden door parts"
	desc = "It would keep things out if you actually built it."
	icon_state = "wood_tableparts"
	ofType = /obj/structure/door


///
// PROCESSED GOODS
///
/obj/item/loot/processed
	name = "processed good"
	desc = "processed from something."
	icon = 'sprite/obj/items.dmi'

/obj/item/loot/processed/wood
	name = "wood plank"
	desc = "May be woody"
	icon_state = "sheet-wood"



///
// HARVESTED GOODS
///

/obj/item/loot/nature
	name = "nature thing"
	desc = "vaguely leafy"
	icon = 'sprite/obj/items.dmi'

/obj/item/loot/nature/stick
	name = "stick"
	desc = "What's brown and sticky?"
	icon_state = "c_tube"
	itemMaterial = new/datum/material/wood1

/obj/item/loot/nature/leaf
	name = "leafy pile"
	desc = "Make like a tree and leaf."
	icon_state = "leafmatter"
	itemMaterial = new/datum/material/nature1

/obj/item/loot/nature/rock
	name = "rock chip"
	desc = "An alternative to heavy metal."
	icon_state = "rock"
	itemMaterial = new/datum/material/mineral1

/obj/item/loot/nature/log
	name = "log"
	desc = "Has a future in housing."
	icon_state = "tree_log"
	size = 3
	weight = 8
	itemMaterial = new/datum/material/wood1

/obj/item/loot/nature/log/objFunction(var/mob/user,var/obj/used)
	if(istype(used,/obj/item/weapon/tool/hatchet))
		displayTo("You harvest some logs from [src]",user,src)
		for(var/i = 0; i < 4; ++i)
			new/obj/item/loot/processed/wood(user.loc)
		del(src)