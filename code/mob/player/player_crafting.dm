/mob/player/verb/craft()
	set name = "Craft"
	set desc = "Allows the player to craft an object"
	set category = "Skills"

	var/topic = "<title>Crafting</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"
	topic += "<table style=\"width=100%; border: 1px solid black;\">"
	for(var/datum/recipe/r in playerData.knownRecipes)
		topic += "<tr>"
		topic += "<td>"
		var/ableTC = r.canCraft(contents)
		if(ableTC)
			if(r.requiredType)
				ableTC = FALSE
				for(var/A in orange(src,1))
					if(A:type == r.requiredType)
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
	var/recipe = href_list["recipe"]
	if(recipe)
		var/datum/recipe/located = locate(recipe)
		if(located)
			if(located.canCraft(contents))
				located.getResult(contents,src)
		src.craft()