/mob/player
	var/selectedCraftCategory

/mob/player/verb/craft()
	set name = "Craft Item"
	set desc = "Allows the player to craft an object"
	set category = "Skills"

	var/list/allCats = list()
	var/list/shownCats = list()
	for(var/datum/recipe/r in playerData.knownRecipes)
		allCats[r] = r.listCategory

	for(var/B in allCats)
		shownCats |= allCats[B]

	var/topic = "<title>Crafting</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"

	var/counter = 0
	for(var/A in shownCats)
		if(counter > 0)
			topic += " <b>|</b> "
		topic += "<a href=?src=\ref[src];category=[A]>[A]</a>"
		counter++

	topic += "<table style=\"width=100%; border: 1px solid black;\">"
	for(var/d in allCats)
		if(selectedCraftCategory == allCats[d])
			var/datum/recipe/r = d
			topic += "<tr>"
			topic += "<td>"
			var/ableTC = r.canCraft(contents)
			if(ableTC)
				if(r.requiredType)
					ableTC = FALSE
					for(var/A in orange(src,1))
						if(istype(A,r.requiredType))
							ableTC = TRUE
							break
			topic += "<a href=?src=\ref[src];recipe=\ref[r]><b><font color=[r.canCraft(contents) ? "green" : "red"]>[r.name]</font></b></a><br>"
			topic += "</td>"
			for(var/eb in r.getNeededNames())
				topic += "<td>"
				topic += eb
				topic += "</td>"
		topic += "</tr>"
	topic += "</table></body></center></html>"
	src << browse(topic,"window=craftwindow")


/mob/player/Topic(href,href_list[])
	..()
	if(href_list["category"])
		selectedCraftCategory = href_list["category"]
		src.craft()
	var/recipe = href_list["recipe"]
	if(recipe)
		var/datum/recipe/located = locate(recipe)
		if(located)
			if(located.canCraft(contents))
				located.getResult(contents,src)
		src.craft()