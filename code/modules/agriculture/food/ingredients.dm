/obj/item/food/prep
	name = "pre-prep food"
	desc = "needs makering"
	icon = 'sprite/obj/food.dmi'
	helpInfo = "You can add all sorts of things to this, and create a much tastier morsel!"

/obj/item/food/prep/objFunction(var/mob/user,var/obj/item/I)
	if(istype(I,/obj/item/food))
		user.DropItem()
		if(I.reagents)
			I.reagents.trans_to(src.reagents,I.reagents.currentvolume)
		if(!istype(I,/obj/item/food/prep))
			var/matrix/newtransform = matrix()
			newtransform.Turn(rand(90,270))
			newtransform.Translate(rand(-16,16),rand(-16,16))
			newtransform.Scale(0.3)
			animate(I,transform = newtransform,time = 0.1,loop = 0)
			name = "[I.name] [name]"
		overlays += I
		sdel(I)

/obj/item/food/prep/dough
	name = "dough"
	desc = "makes all sorts of good food."
	cooked_name = "damper"
	icon_state = "dough"
	var/pieces = 4

/obj/item/food/prep/dough/objFunction(var/mob/user,var/obj/item/I)
	if(!I)
		if(pieces > 0)
			messageInfo("You tear off a piece of the [src]", user, src)
			new/obj/item/food/prep/doughpiece(get_turf(src), user)
			--pieces
			if(pieces <= 0)
				sdel(src)

/obj/item/food/prep/doughpiece
	name = "dough piece"
	desc = "a tiny piece of a whole."
	cooked_name = "toast"
	cooked_icon_state = "breadslice"
	icon_state = "doughslice"

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