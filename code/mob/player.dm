/mob
	icon = 'sprite/human.dmi'

/mob/Login()
	if(!client.mob || !(istype(client.mob,/mob/player)))
		var/mob/player/P = new
		client.mob = P
		spawn(5)
			P.playerSheet()
	..()

/mob/player
	name = "unnamed"
	icon = 'sprite/human.dmi'
	icon_state = "skeleton_s"
	var/datum/playerFile/playerData = new

/mob/player/verb/say(msg as text)
	chatSay(msg)

/mob/player/proc/nameChange(var/toName)
	if(toName)
		name = "[toName] the [playerData.returnGender()] [playerData.playerRace.raceName]"
		playerData.playerName = toName

/mob/player/proc/raceChange(var/datum/race/toRace,var/reselect = TRUE)
	if(toRace)
		playerData.playerRace = new toRace
		playerData.assignRace(playerData.playerRace)
		var/prefix = ""
		if(reselect)
			if(playerData.playerRace.icon_prefix.len > 1)
				prefix = input(src,"Choose a skin") as null|anything in playerData.playerRace.icon_prefix
			else
				prefix = playerData.playerRace.icon_prefix[1]

			playerData.playerRacePrefix = prefix

			if(playerData.playerRace.shouldColorRace)
				playerData.playerColor = input(src,"Choose a Color") as color|null
			else
				playerData.playerColor = "white"
		else
			prefix = playerData.playerRacePrefix
		overlays.Cut()

		var/state = "[prefix]_[playerData.playerGenderShort]_s"
		var/image/player = new/image(icon,state)
		player.color = playerData.playerColor
		overlays.Add(player)

		if(playerData.playerRace.race_overlays.len > 0)
			for(var/ov in playerData.playerRace.race_overlays)
				var/image/race_overlay = new/image(icon,ov)
				overlays.Add(race_overlay)

		var/image/eyes = new/image(icon,"eyes")
		eyes.color = playerData.eyeColor
		overlays.Add(eyes)

		descChange()

/mob/player/proc/genderChange(var/toGender)
	if(toGender)
		if(toGender == "Male")
			playerData.playerGender = 0
			playerData.playerGenderShort = "m"
		if(toGender == "Female")
			playerData.playerGender = 1
			playerData.playerGenderShort = "f"
		if(toGender == "Custom")
			playerData.playerGender = 2
			playerData.customGender = input(src,"Please input your gender") as text
			var/choice = input(src,"Please choose what gender appearence you would like") as anything in list("Male","Female")
			switch(choice)
				if("Male")
					playerData.playerGenderShort = "m"
				if("Female")
					playerData.playerGenderShort = "f"
		raceChange(text2path("[playerData.playerRace]"),FALSE)

/mob/player/proc/eyeChange(var/toColor)
	if(toColor)
		playerData.eyeColor = toColor
		raceChange(text2path("[playerData.playerRace]"),FALSE)

/mob/player/proc/descChange(var/extra)
	playerData.playerDesc = ""

	if(extra)
		playerData.playerExtraDesc += extra
	playerData.playerDesc += "<br>[playerData.playerName] is a [playerData.returnGender()] [playerData.playerRace.raceName].<br>"
	playerData.playerDesc += "[playerData.playerName] has both <font color=[playerData.eyeColor]>eyes</font>.<br>"
	for(var/s in playerData.playerExtraDesc)
		playerData.playerDesc += s
		playerData.playerDesc += "<br>"

/mob/player/proc/descRemove(var/what)
	playerData.playerExtraDesc -= what
	descChange()

/mob/player/verb/playerSheet()
	set name = "View Player Sheet"
	var/html = "<html><title>Player Sheet</title><body style='background:grey'>"
	html += "<b>Name</b>: [playerData.playerName] - <a href=?src=\ref[src];function=name><i>Change</i></a><br>"
	html += "<b>Gender</b>: [playerData.returnGender()] - <a href=?src=\ref[src];function=gender><i>Change</i></a><br>"
	html += "<b>Race</b>: <font color=[playerData.playerColor]>[playerData.playerRace.raceName]</font> - <a href=?src=\ref[src];function=race><i>Change</i></a><br>"
	html += "<b>Eye Color</b>: <font color=[playerData.eyeColor]>Preview</font> - <a href=?src=\ref[src];function=eyes><i>Change</i></a><br>"
	html += "<b>Description</b>: [playerData.playerDesc] - <a href=?src=\ref[src];function=desc><i>Add</i></a>/<a href=?src=\ref[src];function=descdelete><i>Remove</i></a><br><br>"
	for(var/datum/stat/S in playerData.playerStats)
		if(S.isLimited)
			html += "<b>[S.statName]</b>: [S.statModified]/[S.statMax]<br>"
		else
			html += "<b>[S.statName]</b>: [S.statModified]<br>"
	html += "</body></html>"
	src << browse(html,"window=playersheet")

/mob/player/Topic(href,href_list[])
	var/function = href_list["function"]
	switch(function)
		if("name")
			nameChange(input(src,"Choose your name") as text)
			src.playerSheet()
		if("race")
			var/choice = input(src,"Choose your Race") as anything in list("Human","Golem","Lizard","Slime","Pod","Fly","Jelly","Ape")
			var/chosen = text2path("/datum/race/[choice]")
			raceChange(chosen)
			nameChange(src.playerData.playerName)
			src.playerSheet()
		if("gender")
			genderChange(input(src,"Choose your Gender") as anything in list ("Male","Female","Custom"))
			nameChange(src.playerData.playerName)
			src.playerSheet()
		if("eyes")
			eyeChange(input(src,"Choose your Eye Color") as color)
			src.playerSheet()
		if("desc")
			descChange(input(src,"Describe anything extra about your character") as text)
			src.playerSheet()
		if("descdelete")
			descRemove(input(src,"Remove what character note?") as null|anything in playerData.playerExtraDesc)
			src.playerSheet()