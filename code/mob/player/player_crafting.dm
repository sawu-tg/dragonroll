/mob/player/verb/craft()
	set name = "Craft"
	set desc = "Allows the player to craft an object"

	var/topic = "<title>Crafting</title><html><center>[parseIcon(src.client,src,FALSE)]<br><body style='background:grey'>"

	for(var/datum/recipe/r in playerData.knownRecipes)
		topic += "<a href=?src=\ref[src];recipe=\ref[r]><b><font color=[r.canCraft(contents) ? "green" : "red"]>[r.name]</font></b></a><br>"
	topic += "</body></center></html>"
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