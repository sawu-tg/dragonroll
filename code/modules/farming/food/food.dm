/obj/item/food
	name = "edible numnums"
	desc = "tastey!"
	icon = 'sprite/obj/food.dmi'
	var/foodLevel = 2

/obj/item/food/objFunction(var/mob/user)
	for(var/i = 0; i < foodLevel; ++i)
		user:addStatusEffect(/datum/statuseffect/wellfed,15)
