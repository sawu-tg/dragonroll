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

/mob/player/proc/raceChange(var/datum/race/toRace)
	if(toRace)
		playerData.playerRace = new toRace
		playerData.assignRace(playerData.playerRace)
		var/prefix = ""
		if(playerData.playerRace.icon_prefix.len > 1)
			prefix = input(src,"Choose a skin") as null|anything in playerData.playerRace.icon_prefix
		else
			prefix = playerData.playerRace.icon_prefix[1]
		icon_state = "[prefix]_[playerData.playerGenderShort]_s"
		if(playerData.playerRace.shouldColorRace)
			playerData.playerColor = input(src,"Choose a Color") as color|null
		else
			playerData.playerColor = "white"
		src.color = playerData.playerColor

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
		raceChange(text2path("[playerData.playerRace]"))

/mob/player/verb/playerSheet()
	set name = "View Player Sheet"
	var/html = ""
	html += "<b>Name</b>: [playerData.playerName] - <a href=?src=\ref[src];function=name><i>Change</i></a><br>"
	html += "<b>Gender</b>: [playerData.returnGender()] - <a href=?src=\ref[src];function=gender><i>Change</i></a><br>"
	html += "<b>Race</b>: [playerData.playerRace.raceName] - <a href=?src=\ref[src];function=race><i>Change</i></a><br>"
	html += "<b>Desc</b>: [playerData.playerDesc]<br><br>"
	for(var/datum/stat/S in playerData.playerStats)
		if(S.isLimited)
			html += "<b>[S.statName]</b>: [S.statModified]/[S.statMax]<br>"
		else
			html += "<b>[S.statName]</b>: [S.statModified]<br>"
	src << browse(html,"window=playersheet")

/mob/player/Topic(href,href_list[])
	var/function = href_list["function"]
	switch(function)
		if("name")
			nameChange(input(src,"Choose your name") as text)
			src.playerSheet()
		if("race")
			var/choice = input(src,"Choose your Race") as anything in list("Human","Golem","Lizard","Slime","Pod","Fly","Jelly")
			var/chosen = text2path("/datum/race/[choice]")
			raceChange(chosen)
			nameChange(src.playerData.playerName)
			src.playerSheet()
		if("gender")
			genderChange(input(src,"Choose your Gender") as anything in list ("Male","Female","Custom"))
			nameChange(src.playerData.playerName)
			src.playerSheet()