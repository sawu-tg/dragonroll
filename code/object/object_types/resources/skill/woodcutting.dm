/obj/item/loot/nature/log
	name = "log"
	desc = "Has a future in housing."
	icon_state = "tree_log"
	size = 3
	weight = 8
	itemMaterial = new/datum/material/wood

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
	itemMaterial = new/datum/material/snow_wood
/obj/item/loot/nature/log/oak
	itemMaterial = new/datum/material/oak
/obj/item/loot/nature/log/willow
	itemMaterial = new/datum/material/willow
/obj/item/loot/nature/log/teak
	itemMaterial = new/datum/material/teak
/obj/item/loot/nature/log/maple
	itemMaterial = new/datum/material/maple
/obj/item/loot/nature/log/mahogany
	itemMaterial = new/datum/material/mahogany
/obj/item/loot/nature/log/yew
	itemMaterial = new/datum/material/yew
/obj/item/loot/nature/log/magic
	itemMaterial = new/datum/material/magic
/obj/item/loot/nature/log/elder
	itemMaterial = new/datum/material/elder