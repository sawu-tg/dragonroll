/obj/item/food/prep
	name = "pre-prep food"
	desc = "needs makering"
	icon = 'sprite/obj/food_ingredients.dmi'

/obj/item/food/prep/objFunction(var/mob/user,var/obj/item/I)
	if(istype(I,/obj/item/food))
		user.DropItem()
		if(I.reagents)
			I.reagents.trans_to(src.reagents,I.reagents.currentvolume)
		name = "[I.name] [name]"
		sdel(I)

/obj/item/food/prep/dough
	name = "dough"
	desc = "makes all sorts of good food."
	cooked_name = "damper"
	icon_state = "dough"

/obj/item/food/prep/cakebatter
	name = "cake batter"
	desc = "Bakes into fluffy goodness."
	cooked_name = "cake"
	cooked_icon_state = "plaincake"
	icon_state = "cakebatter"

/obj/item/food/prep/tortilla
	name = "tortilla"
	desc = "flat, round bread-like dough."
	icon_state = "tortilla"

/obj/item/food/prep/piecrust
	name = "pie crust"
	desc = "holds everyone you'd ever want to eat."
	cooked_name = "pie"
	cooked_icon_state = "pie"
	icon_state = "piedough"

/obj/item/food/prep/pizzacrust
	name = "pizza crust"
	desc = "flat, round bread-like dough."
	cooked_name = "pizza"
	cooked_icon_state = "meatpizza"
	icon_state = "piedough"