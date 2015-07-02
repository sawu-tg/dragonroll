/datum/recipe/dough
	name = "dough"
	desc = "The base for many food items."
	listCategory = "Dough"
	product = list(/obj/item/food/prep/dough = 1)

/datum/recipe/dough/New()
	..()
	requiredReagents = list("[REAGENT_STATE_LIQUID]" = 1,"[REAGENT_STATE_POWDER]" = 1)

/datum/recipe/cakebatter
	name = "cake batter"
	desc = "The base of many cakes."
	listCategory = "Dough"
	product = list(/obj/item/food/prep/cakebatter = 1)

/datum/recipe/dough/New()
	..()
	requiredReagents = list("[REAGENT_STATE_LIQUID]" = 1,"[REAGENT_STATE_POWDER]" = 1)


/datum/recipe/tortilla
	name = "tortilla"
	desc = "Used for making wraps, and other ethnic food."
	listCategory = "Dough"
	materials = list(/obj/item/food/prep/dough = 1)
	product = list(/obj/item/food/prep/tortilla = 1)

/datum/recipe/piecrust
	name = "pie crust"
	desc = "Holds a large amount of things."
	listCategory = "Dough"
	materials = list(/obj/item/food/prep/dough = 1)
	product = list(/obj/item/food/prep/piecrust = 1)

/datum/recipe/pizzacrust
	name = "pizza crust"
	desc = "Can be covered in toppings."
	listCategory = "Dough"
	materials = list(/obj/item/food/prep/dough = 1)
	product = list(/obj/item/food/prep/pizzacrust = 1)


///////////////////
///// CREATED FOOD
//////////////////

/datum/recipe/foodprep
	name = "food recipe"
	desc = "default desc"
	listCategory = "Food"
	usesGeneric = FALSE
	requiredType = /obj/furniture/table
	materials = list() // associative list of ingredients and count
	product = list() // associative list of produced objects and their count

/datum/recipe/foodprep/sashimi
	name = "sashimi"
	desc = "Thin slices of fish."
	materials = list(/obj/item/food/meat/fish = 1)
	product = list(/obj/item/food/sashimi = 1)

/datum/recipe/foodprep/sausage
	name = "sausage"
	desc = "Meat in tube form."
	materials = list(/obj/item/food/meat = 1)
	product = list(/obj/item/food/sausage = 1)

/datum/recipe/foodprep/meatball
	name = "meatball"
	desc = "Minced, rolled meat."
	materials = list(/obj/item/food/meat = 1)
	product = list(/obj/item/food/meatball = 1)

/datum/recipe/foodprep/kebob
	name = "kebob"
	desc = "Chunks of meat on a stick."
	materials = list(/obj/item/food/meat = 2, /obj/item/loot/nature/stick = 1 )
	product = list(/obj/item/food/kebob = 1)

/datum/recipe/foodprep/bacon
	name = "cured meat"
	desc = "Salted and preserved meat."
	materials = list(/obj/item/food/meat = 1)
	product = list(/obj/item/food/bacon = 1)

/datum/recipe/foodprep/burger
	name = "burger"
	desc = "Portable morsels."
	materials = list(/obj/item/food/meat = 1)
	product = list(/obj/item/food/burger = 1)