/mob/verb/becomeDM()
	set name = "Be DM"
	set desc = "Ascend to the level of a DM"
	set src = usr
	var/mob/dm/NDM = new/mob/dm(src.loc)
	NDM.ckey = src.ckey
	del(src)

/mob/dm
	name = "Dungeon Master"
	desc = "Master of.. well more than just dungeons."
	icon = 'sprite/mob/mob.dmi'
	icon_state = "ghostking"
	invisibility = 3
	see_invisible  = 3

/mob/dm/New()
	spawn(10)
		client.isDM = TRUE

	addProcessingObject(src)

/mob/player/doProcess()
	..()
	refreshInterface()

/mob/dm/verb/relocate()
	set name = "Teleport"
	set desc = "Teleports you to a new location"
	set category = "DM"
	var/x = input(src,"Choose X") as num
	var/y = input(src,"Choose Y") as num
	var/z = input(src,"Choose Z") as num

	loc = locate(x,y,z)

/mob/dm/verb/SpawnMonster()
	set name = "Spawn Monster"
	set desc = "Spawns a monster at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/mob)
	if(toSpawn)
		new toSpawn(src.loc)


/mob/dm/verb/SpawnItem()
	set name = "Spawn Item"
	set desc = "Spawns an Item at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/item)
	if(toSpawn)
		new toSpawn(src.loc)

/mob/dm/verb/SpawnEffect()
	set name = "Spawn Effect"
	set desc = "Spawns an Effect at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/effect)
	if(toSpawn)
		new toSpawn(src.loc)