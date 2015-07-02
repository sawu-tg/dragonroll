/obj/structure/cooking
	name = "campfire"
	desc = "keeps things warm."
	icon = 'sprite/obj/alchemy/structures.dmi'
	icon_state = "campfire"
	var/prefixState = "campfire"
	helpInfo = "Can be used to cook a variety of things, when lit with a tinderbox."
	var/burnTime = 50
	var/icon/cookOverlay // the overlay applied for cooking
	var/lit = FALSE // is the cooking structure providing fire to cook
	var/capacity = 2 // how many things can this pot use to cook?
	var/cookingLevel = 1 // what level of ingredients this can cook
	var/list/curCooking = list() // list of what is cooking and its times
	var/mob/player/lastUsr
	density = 0

/obj/structure/cooking/New()
	..()
	cookOverlay = icon('sprite/obj/alchemy/items.dmi',icon_state="cook_overlay")

/obj/structure/cooking/proc/doLight(var/fromWho)
	lit = TRUE
	messageInfo("You light the fire.",fromWho,src)
	icon_state = "[prefixState]_lit"
	set_light(4,4,"orange")
	addProcessingObject(src)

/obj/structure/cooking/proc/doExtinguish()
	lit = FALSE
	burnTime = initial(burnTime)
	icon_state = "[prefixState]"
	messageArea("The [src] extinguishes!","The [src] extinguishes!", src, src)
	set_light(0)
	remProcessingObject(src)

/obj/structure/cooking/objFunction(var/mob/player/user,var/obj/item/I)
	if(!lit)
		if(istype(I,/obj/item/weapon/tool/tinderbox))
			doLight(user)
			return
		return
	else
		if(istype(I,/obj/item/weapon/tool/tongs))
			showCookingMenu(user)
			return
		if(istype(I, /obj/item/loot/nature/log))
			var/obj/item/loot/nature/log/L = I
			if(L.required_level > user.playerData.firemaking.statCurr)
				messagePlayer("Your skill isn't high enough to burn \an [I] yet.",user,src)
				return
			messagePlayer("You throw [L] into [src].",user,src)
			user.playerData.firemaking.addxp(L.exp_granted, user)
			burnTime += L.light_length
			if(burnTime >= 200)
				prefixState = "bonfire"
				icon_state = prefixState
			sdel(L)
			return
		if(I && !istype(I,/obj/item/food))
			messageInfo("Only food items can be cooked.",user,src)
			return
		if(contents.len < capacity)
			user.DropItem()
			messageInfo("You insert the [I] into the [src]!",user,src)
			I.loc = src
		else
			messageInfo("[src] is full!",user,src)

/obj/structure/cooking/doProcess()
	if(lastUsr)
		if(Adjacent(lastUsr) && curCooking.len > 0)
			showCookingMenu(lastUsr)
	if(burnTime > 0)
		--burnTime
		if(burnTime <= 100)
			prefixState = "campfire"
			icon_state = prefixState
		if(contents.len)
			for(var/obj/item/food/A in curCooking)
				if(curCooking[A] <= 0)
					curCooking -= A
					A.name = "Cooked [A.cooked_name ? A.cooked_name : A:name]"
					A.color = "white"
					if(!A.cooked_icon_state)
						var/icon/cooked = icon(A.icon,icon_state=A.icon_state)
						cooked.Blend(rgb(204,102,0),ICON_MULTIPLY)
						cooked.Blend(cookOverlay,ICON_MULTIPLY)
						A.icon = cooked
					else
						A.icon = 'sprite/obj/food.dmi'
						A.icon_state = A.cooked_icon_state
					A.loc = get_turf(pick(orange(src,1)))
					var/reagent_bonus = lastUsr.playerData.cooking.statModified - A.level_required_cooking
					if(reagent_bonus > 0)
						for(var/reagent in A.containedReagents)
							var/datum/reagent/R = new reagent
							A.reagents.addliquid(R.id, reagent_bonus)
					lastUsr.playerData.cooking.addxp(A.exp_granted_cooking, lastUsr)
					showCookingMenu(lastUsr)
				else
					curCooking[A]--
	else
		doExtinguish()
		return

/obj/structure/cooking/proc/showCookingMenu(var/user)
	var/html = "<title>[src.name]</title><html><center><br><body style='background:grey'>"
	html += "<b>Contents:</b><br>"
	html += "<table>"
	html += "<tr>"
	for(var/obj/item/food/F in contents)
		if(!(F in curCooking))
			html += "<td style=\"text-align:center\"><a href=?src=\ref[src];function=cook;food=\ref[F]>[parseIcon(user,F)]</a></td>"
	html += "</tr></table>"
	html += "<br>"
	html += "<b>Cooking:</b><br>"
	html += "<table>"
	html += "<tr>"
	for(var/obj/item/food/F in curCooking)
		html += "</td style=\"text-align: center\">[parseIcon(user,F)]</td>"
	html += "<br>"
	for(var/obj/item/food/F in curCooking)
		html += "<td style=\"text-align:center\">"
		for(var/I = 0; I < ((curCooking[F]/100)*(F.foodLevel*10)); ++I)
			html += "<b>|</b>"
		html += "</td>"
	html += "</tr></table>"
	html += "</body></center></html>"
	user << browse(html,"window=cooking")

/obj/structure/cooking/Topic(href,href_list[])
	var/function = href_list["function"]
	if(function == "cook")
		var/fud = href_list["food"]
		if(fud)
			var/obj/item/food/A = locate(fud)
			if(A)
				curCooking[A] = A.foodLevel*10
				lastUsr = usr
				showCookingMenu(usr)

///
// GRINDR
///
/obj/item/food/chempile
	name = "Pile of Ground Dust"
	desc = "Full of gritty, disgusting things."
	reagentSize = 500
	icon = 'sprite/obj/alchemy/items.dmi'
	icon_state = "pile"
	helpInfo = "A powdered form of any amount of reagents; Can be combined with another pile to form one larger!"

/obj/item/food/chempile/objFunction(var/mob/player/P, var/obj/item/I)
	if(I)
		if(istype(I,/obj/item/food/chempile))
			I.reagents.trans_to(src.reagents,I.reagents.currentvolume)
			src.color = mix_color_from_reagents(src.reagents.liquidlist)
			P.DropItem()
			sdel(I)
			messageInfo("You mix the two piles together",P,src)

/obj/structure/grindr
	name = "Grinder"
	desc = "Grinds things into powdered form"
	icon_state = "grinder"
	icon = 'sprite/obj/alchemy/structures.dmi'
	helpInfo = "Grinds anything with contained reagents into a powdered form!"

/obj/structure/grindr/objFunction(var/mob/player/P, var/obj/item/I)
	if(I)
		if(I.reagents.liquidlist.len)
			var/obj/item/food/chempile/CP = new(get_turf(P))
			I.reagents.trans_to(CP.reagents,I.reagents.currentvolume)
			CP.color = mix_color_from_reagents(CP.reagents.liquidlist)
			P.DropItem()
			sdel(I)
			for(var/datum/reagent/R in CP.reagents.liquidlist)
				R.reagentState = REAGENT_STATE_POWDER
			messageInfo("You grind the [I] into it's base reagents",P,src)