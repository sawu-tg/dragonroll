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

/obj/item/food/New(var/turf/atloc, var/modifier)
	..(atloc)
	for(var/a in containedReagents)
		var/datum/reagent/R = new a
		if(modifier)
			reagents.addliquid(R.id, containedReagents[a] * modifier)
		else
			reagents.addliquid(R.id, containedReagents[a])

/obj/item/food/objFunction(var/mob/user)
	reagents.trans_to(user.reagents,reagents.maxvolume)
	spawn(5)
		user.refreshInterface()
	sdel(src)

///
// "Complete" food items (non-dynamic)
///

/obj/item/food/sashimi
	name = "sashimi"
	desc = "Thin slices of raw fish, with a dash of soy and ginger."
	icon_state = "sashimi"

/obj/item/food/sausage
	name = "sausage"
	desc = "Meat compacted into a handy, portable tube."
	icon_state = "sausage"

/obj/item/food/meatball
	name = "meatball"
	desc = "Minced meat rolled into a ball, possibly containing surprises."
	icon_state = "faggot"

/obj/item/food/kebob
	name = "kebob"
	desc = "Meat threaded onto a stick for easy eating."
	icon_state = "kebab"

/obj/item/food/bacon
	name = "cured meat"
	desc = "Meat, salted and preserved into a tasy treat."
	icon_state = "bacon"

/obj/item/food/burger
	name = "burger"
	desc = "A delicious morsel in it's own edible wrapper."
	icon_state = "hburger"

