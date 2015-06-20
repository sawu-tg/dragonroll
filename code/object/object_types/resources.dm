/obj/item/loot/New()
	..()

	spawn(1)
		update_icon()

	pixel_x = rand(-12,12)
	pixel_y = rand(-12,12)

/obj/item/loot/proc/update_icon()
	color = itemMaterial.color

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
	icon_state = "sheet-woodf"
	itemMaterial = new/datum/material/wood1

/obj/item/loot/processed/random
	icon_state = "mat_sphere"

/obj/item/loot/processed/random/New()
	..()
	var/randmat = getRandomMaterial()
	itemMaterial = new randmat
	color = itemMaterial.color
	name = "[itemMaterial.name] chunk"

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
	icon_state = "branch"
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

/obj/item/loot/nature/log/update_icon()
	overlays += image(icon,src,"tree_logo")

	var/image/I = image(icon,src,"tree_logf")
	I.color = itemMaterial.color
	overlays += I

	color = null


/obj/item/loot/nature/log/objFunction(var/mob/user,var/obj/used)
	if(istype(used,/obj/item/weapon/tool/hatchet))
		messagePlayer("You harvest some logs from [src]",user,src)
		for(var/i = 0; i < 4; ++i)
			new/obj/item/loot/processed/wood(user.loc)
		sdel(src)
	else
		..()