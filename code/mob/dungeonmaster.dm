/mob/verb/becomeDM()
	set name = "Toggle DM"
	set desc = "Ascend to the level of a DM"
	set src = usr
	if(client.isDM)
		var/mob/player/dm/NDM = src
		NDM.originalMob.ckey = src.ckey
		del(NDM)
	else
		var/mob/player/dm/NDM = new/mob/player/dm(src.loc)
		NDM.ckey = src.ckey
		NDM.originalMob = src

/mob/player/dm
	name = "Dungeon Master"
	desc = "Master of.. well more than just dungeons."
	invisibility = 3
	see_invisible  = 3
	var/mob/originalMob

/mob/player/dm/New()
	..(TRUE)
	spawn(10)
		raceChange(/datum/race/Genie,TRUE)

		client.isDM = TRUE
		defaultInterface()
		refreshInterface()
		addProcessingObject(src)

/mob/player/dm/doProcess()
	..()
	refreshInterface()

/mob/player/dm/verb/relocate()
	set name = "Teleport"
	set desc = "Teleports you to a new location"
	set category = "DM"
	var/x = input(src,"Choose X") as num
	var/y = input(src,"Choose Y") as num
	var/z = input(src,"Choose Z") as num

	loc = locate(x,y,z)

/mob/player/dm/verb/SpawnMonster()
	set name = "Spawn Monster"
	set desc = "Spawns a monster at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/mob)
	if(toSpawn)
		new toSpawn(src.loc)


/mob/player/dm/verb/SpawnItem()
	set name = "Spawn Item"
	set desc = "Spawns an Item at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/item)
	if(toSpawn)
		new toSpawn(src.loc)

/mob/player/dm/verb/SpawnEffect()
	set name = "Spawn Effect"
	set desc = "Spawns an Effect at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/effect)
	if(toSpawn)
		new toSpawn(src.loc)