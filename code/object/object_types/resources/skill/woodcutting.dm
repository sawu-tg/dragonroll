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
			new/obj/item/loot/processed/wood(user.loc) // TODO: make this depend on log type
		sdel(src)
	else
		..()

/obj/item/loot/nature/log/snowy
	name = "snowy log"

/obj/item/loot/nature/log/oak
	name = "oak log"

/obj/item/loot/nature/log/willow
	name = "willow log"

/obj/item/loot/nature/log/teak
	name = "teak log"

/obj/item/loot/nature/log/maple
	name = "maple log"

/obj/item/loot/nature/log/mahogany
	name = "mahogany log"

/obj/item/loot/nature/log/yew
	name = "yew log"

/obj/item/loot/nature/log/magic
	name = "magic log"

/obj/item/loot/nature/log/elder
	name = "elder log"
