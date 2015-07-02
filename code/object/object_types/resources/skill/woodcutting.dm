/obj/item/loot/nature/log
	name = "logs"
	desc = "Has a future in housing."
	icon_state = "tree_log"
	itemMaterial = new/datum/material/wood
	var/required_level = 1
	var/light_length = 50
	var/exp_granted = 40

/obj/item/loot/nature/log/update_icon()
	..()
	overlays += image(icon,src,"tree_logo")

	var/image/I = image(icon,src,"tree_logf")
	I.color = itemMaterial.color
	overlays += I

	color = null

/obj/item/loot/nature/log/objFunction(var/mob/player/user,var/obj/used)
	/* if(istype(used,/obj/item/weapon/tool/hatchet))
		messagePlayer("You harvest some logs from [src]",user,src)
		for(var/i = 0; i < 4; ++i)
			new/obj/item/loot/processed/wood(user.loc) // TODO: make this depend on log type
		sdel(src) */ // TODO:
	if(istype(used, /obj/item/weapon/tool/tinderbox))
		if(required_level > user.playerData.firemaking.statCurr)
			messagePlayer("You aren't good enough at firemaking to light a fire here.",user,src)
			return
		var/obj/structure/cooking/C = new/obj/structure/cooking(src.loc)
		messagePlayer("You light [src].",user,src)
		user.playerData.firemaking.addxp(exp_granted, user)
		C.burnTime += light_length
		C.lit = TRUE
		C.icon_state = "[C.icon_state]_lit"
		C.set_light(4,4,"orange")
		addProcessingObject(C)
		sdel(src)
	else
		..()

/obj/item/loot/nature/log/snowy
	itemMaterial = new/datum/material/snow_wood
	required_level = 42
	light_length = 180
	exp_granted = 125
/obj/item/loot/nature/log/oak
	itemMaterial = new/datum/material/oak
	required_level = 15
	light_length = 100
	exp_granted = 60
/obj/item/loot/nature/log/willow
	itemMaterial = new/datum/material/willow
	required_level = 30
	light_length = 150
	exp_granted = 90
/obj/item/loot/nature/log/teak
	itemMaterial = new/datum/material/teak
	required_level = 35
	light_length = 175
	exp_granted = 105
/obj/item/loot/nature/log/maple
	itemMaterial = new/datum/material/maple
	required_level = 45
	light_length = 200
	exp_granted = 142.5
/obj/item/loot/nature/log/mahogany
	itemMaterial = new/datum/material/mahogany
	required_level = 50
	light_length = 225
	exp_granted = 157.5
/obj/item/loot/nature/log/yew
	itemMaterial = new/datum/material/yew
	required_level = 60
	light_length = 250
	exp_granted = 202.5
/obj/item/loot/nature/log/magic
	itemMaterial = new/datum/material/magic
	required_level = 75
	light_length = 300
	exp_granted = 303.8
/obj/item/loot/nature/log/elder
	itemMaterial = new/datum/material/elder
	required_level = 90
	light_length = 350
	exp_granted = 450