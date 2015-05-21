/obj
	name = "default object"
	desc = "not very interesting"
	var/uuid = "item_default" //unique item identifier
	var/force = 1 // damage
	var/datum/material/itemMaterial = new/datum/material/default

/obj/New()
	..()
	uuid = name
	updateStats()

/obj/proc/updateStats()
	itemMaterial.inherit(src)
	uuid = name