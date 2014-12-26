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

/mob/player/proc/renamePlayer(var/toName)
	name = "[toName] the [playerData.playerRace.raceName]"
	playerData.playerName = toName

/mob/player/proc/raceChange(var/datum/race/toRace)
	playerData.playerRace = toRace
	playerData.assignRace(toRace)

/mob/player/verb/playerSheet()
	set name = "View Player Sheet"
	var/html = ""
	html += "<b>Name</b>: [playerData.playerName] - <a href=?src=\ref[src];function=name><i>Change</i></a><br>"
	html += "<b>Race</b>: [playerData.playerRace.raceName] - <a href=?src=\ref[src];function=race><i>Change</i></a><br>"
	html += "<b>Desc</b>: [playerData.playerDesc]<br><br>"
	for(var/datum/stat/S in playerData.playerStats)
		if(S.isLimited)
			html += "<b>[S.statName]</b>: [S.statCur]/[S.statMax]<br>"
		else
			html += "<b>[S.statName]</b>: [S.statCur]<br>"
	src << browse(html,"window=playersheet")

/mob/player/Topic(href,href_list[])
	var/function = href_list["function"]
	switch(function)
		if("name")
			renamePlayer(input("Choose your name") as text)
			src.playerSheet()
		if("race")
			raceChange(input("Choose your Race") as anything in playableRaces)
			src.playerSheet()