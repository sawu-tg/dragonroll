/obj/structure/cooking
	name = "cooking thingamabob"
	desc = "cooks things, and mabobs"
	icon = 'sprite/obj/alchemy/structures.dmi'
	icon_state = "campfire"
	var/burnTime = 1200
	var/icon/cookOverlay // the overlay applied for cooking
	var/lit = FALSE // is the cooking structure providing fire to cook
	var/capacity = 2 // how many things can this pot use to cook?
	var/cookingLevel = 1 // what level of ingredients this can cook

/obj/structure/cooking/New()
	..()
	cookOverlay = icon('sprite/obj/alchemy/items.dmi',icon_state="cook_overlay")

/obj/structure/cooking/objFunction(var/mob/user,var/obj/item/I)
	if(!lit)
		if(istype(I,/obj/item/firelighter))
			lit = TRUE
			messageInfo("You light the fire.",user,src)
			icon_state = "[icon_state]_lit"
			set_light(4,4,"orange")
			addProcessingObject(src)
			return
		return
	else
		if(!istype(I,/obj/item/food))
			messageInfo("Only food items can be cooked.",user,src)
			return
		if(contents.len < capacity)
			user.DropItem()
			messageInfo("You insert the [I] into the [src]!",user,src)
			I.loc = src

/obj/structure/cooking/doProcess()
	if(burnTime > 0)
		--burnTime
		if(contents.len)
			for(var/obj/item/food/A in contents)
				A.name = "Cooked [A.cooked_name ? A.cooked_name : A:name]"
				A.color = "white"
				if(!A.cooked_icon_state)
					var/icon/cooked = icon(A.icon,icon_state=A.icon_state)
					cooked.Blend(rgb(204,102,0),ICON_MULTIPLY)
					cooked.Blend(cookOverlay,ICON_SUBTRACT)
					A.icon = cooked
				else
					A.icon = 'sprite/obj/food.dmi'
					A.icon_state = A.cooked_icon_state
				A.loc = get_turf(pick(orange(src,2)))
	else
		lit = FALSE
		burnTime = initial(burnTime)
		icon_state = "[initial(icon_state)]_lit"
		messageArea("The [src] extinguishes!","The [src] extinguishes!", src, src)
		set_light(0,0,"white")
		remProcessingObject(src)
		return