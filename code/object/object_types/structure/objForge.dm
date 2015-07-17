/obj/structure/forge
	name = "forge"
	desc = "Used to smelt objects into processed form."
	icon = 'sprite/obj/alchemy/forge.dmi'
	helpInfo = "You can use a large variety of processed materials with this to create usable ingots and bars."
	icon_state = "forge"
	var/burnTime = 1200
	var/icon/burnOverlay
	var/lit = FALSE
	var/capacity = 2
	var/smeltingLevel = 1
	var/list/curSmelting = list()
	var/list/createType = list()
	var/mob/lastUsr

/obj/structure/forge/New()
	..()
	burnOverlay = icon('sprite/obj/alchemy/forge.dmi',icon_state="fill_flow")

/obj/structure/forge/objFunction(var/mob/user,var/obj/item/I)
	if(!lit)
		if(istype(I,/obj/item/weapon/tool/tinderbox))
			lit = TRUE
			messageInfo("You light the fire.",user,src)
			set_light(4,4,"orange")
			addProcessingObject(src)
			overlays += burnOverlay
			return
		return
	else
		if(istype(I,/obj/item/weapon/tool/tongs))
			showSmeltingMenu(user)
			return
		if(I && !istype(I,/obj/item/loot/processed))
			messageInfo("Only processed items can be cooked.",user,src)
			return
		if(contents.len < capacity)
			user.DropItem()
			messageInfo("You insert the [I] into the [src]!",user,src)
			I.loc = src

/obj/structure/forge/doProcess()
	if(lastUsr)
		if(Adjacent(lastUsr) && curSmelting.len > 0)
			showSmeltingMenu(lastUsr)
	if(burnTime > 0)
		--burnTime
		if(contents.len)
			for(var/obj/item/loot/processed/A in curSmelting)
				if(curSmelting[A] <= 0)
					curSmelting -= A
					var/BT = createType[A]
					var/B = new BT
					B:reassignMaterial(A.itemMaterial)
					createType -= A
					B:loc = get_turf(pick(orange(src,1)))
					sdel(A)
					showSmeltingMenu(lastUsr)
				else
					curSmelting[A]--
	else
		lit = FALSE
		burnTime = initial(burnTime)
		messageArea("The [src] extinguishes!","The [src] extinguishes!", src, src)
		set_light(0)
		overlays.Cut()
		remProcessingObject(src)
		return

/obj/structure/forge/proc/showSmeltingMenu(var/user)
	var/html = "<title>[src.name]</title><html><center><br><body style='background:grey'>"
	html += "<b>Contents:</b><br>"
	html += "<table>"
	html += "<tr>"
	for(var/obj/item/loot/processed/F in contents)
		if(!(F in curSmelting))
			html += "<td style=\"text-align:center\"><a href=?src=\ref[src];function=cook;food=\ref[F]>[parseIcon(user,F)]</a></td>"
	html += "</tr></table>"
	html += "<br>"
	html += "<b>Smelting:</b><br>"
	html += "<table>"
	html += "<tr>"
	for(var/obj/item/loot/processed/F in curSmelting)
		html += "</td style=\"text-align: center\">[parseIcon(user,F)]</td>"
	html += "<br>"
	for(var/obj/item/loot/processed/F in curSmelting)
		html += "<td style=\"text-align:center\">"
		for(var/I = 0; I < ((curSmelting[F]/100)*10); ++I)
			html += "<b>|</b>"
		html += "</td>"
	html += "</tr></table>"
	html += "</body></center></html>"
	var/datum/browser/popup = new(user, "forgemenu", "Forging")
	popup.set_content(html)
	popup.open()

/obj/structure/forge/Topic(href,href_list[])
	var/function = href_list["function"]
	if(function == "cook")
		var/fud = href_list["food"]
		if(fud)
			var/obj/item/loot/processed/A = locate(fud)
			if(A)
				var/list/choices = list("Handle" = /obj/item/part/handle, "Blade" = /obj/item/part/blade, "Hilt" = /obj/item/part/hilt)
				var/B = input(usr,"Make what?") as null|anything in choices
				if(B)
					var/TP = choices[B]
					var/list/modifiers = list()
					for(var/P in typesof(TP) - TP)
						var/PP = new P
						modifiers[PP:nameCon] = P
						sdel(PP)
					var/C = input(usr,"What Modifier?") as null|anything in modifiers
					if(C)
						curSmelting[A] = 10
						createType[A] = modifiers[C]
						lastUsr = usr
						giveMedal("Ready to Fight!",usr)
						showSmeltingMenu(usr)