/obj/item/food
	name = "edible numnums"
	desc = "tastey!"
	icon = 'sprite/obj/food.dmi'
	helpInfo = "Cook this over a heat source, or combine it with other foods for a tasty treat!"
	var/cooked_icon_state
	var/cooked_name
	var/foodLevel = 2
	reagentSize = 25
	var/list/containedReagents = list(/datum/reagent/nutrients = 1)
	var/exp_granted_cooking = 1
	var/level_required_cooking = 1
	var/cooked = 0

/obj/item/food/New(var/turf/atloc, var/mob/player/user)
	..(atloc)
	for(var/a in containedReagents)
		var/datum/reagent/R = new a
		if(user)
			reagents.addliquid(R.id, containedReagents[a] * user.playerData.fishing.statModified)
		else
			reagents.addliquid(R.id, containedReagents[a])

/obj/item/food/objFunction(var/mob/user)
	reagents.trans_to(user.reagents,reagents.maxvolume)
	spawn(5)
		user.refreshInterface()
	sdel(src)
