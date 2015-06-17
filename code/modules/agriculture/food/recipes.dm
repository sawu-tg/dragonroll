/datum/recipe/dough
	name = "dough"
	desc = "The base for many food items."
	product = list(/obj/item/food/prep/dough = 1)

/datum/recipe/dough/New()
	..()
	requiredReagents = list("[REAGENT_STATE_LIQUID]" = 1,"[REAGENT_STATE_POWDER]" = 1)

/datum/recipe/cakebatter
	name = "cake batter"
	desc = "The base of many cakes."
	product = list(/obj/item/food/prep/cakebatter = 1)

/datum/recipe/dough/New()
	..()
	requiredReagents = list("[REAGENT_STATE_LIQUID]" = 1,"[REAGENT_STATE_POWDER]" = 1)


/datum/recipe/tortilla
	name = "tortilla"
	desc = "Used for making wraps, and other ethnic food."
	materials = list(/obj/item/food/prep/dough = 1)
	product = list(/obj/item/food/prep/tortilla = 1)

/datum/recipe/piecrust
	name = "pie crust"
	desc = "Holds a large amount of things."
	materials = list(/obj/item/food/prep/dough = 1)
	product = list(/obj/item/food/prep/piecrust = 1)

/datum/recipe/pizzacrust
	name = "pizza crust"
	desc = "Can be covered in toppings."
	materials = list(/obj/item/food/prep/dough = 1)
	product = list(/obj/item/food/prep/pizzacrust = 1)