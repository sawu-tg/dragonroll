/obj/item/armor/material
	name = "armor"
	desc = "protects a man against his problems"
	slot = "chest"
	icon = 'sprite/clothing/body.dmi'
	icon_state = "armor"
	showAsLoot = TRUE

/obj/item/armor/material/New()
	var/randmat = getRandomMaterial()

	reassignMaterial(new randmat())

	..()

/obj/item/armor/material/proc/reassignMaterial(var/datum/material/M)
	if(!M) return

	itemMaterial = M
	color = itemMaterial.color
	stats["ar"] = armorRating * itemMaterial.addedForce