/mob/verb/becomeDM()
	set name = "Be DM"
	set desc = "Ascend to the level of a DM"
	set src = usr
	var/mob/dm/NDM = new/mob/dm(src.loc)
	NDM.ckey = src.ckey
	sdel(src)

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

	add_pane(/datum/windowpane/verbs)
	add_pane(/datum/windowpane/debug)

/mob/dm/doProcess()
	..()
	refreshInterface()

/mob/verb/relocate()
	set name = "Teleport"
	set desc = "Teleports you to a new location"
	set category = "DM"
	var/x = input(src,"Choose X") as num
	var/y = input(src,"Choose Y") as num
	var/z = input(src,"Choose Z") as num

	loc = locate(x,y,z)

/mob/verb/SpawnMonster()
	set name = "Spawn Monster"
	set desc = "Spawns a monster at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/mob)
	var/amount = input(src,"How many?") as num
	if(toSpawn && amount)
		while(amount)
			new toSpawn(get_turf(src))
			--amount


/mob/verb/SpawnItem()
	set name = "Spawn Item"
	set desc = "Spawns an Item at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/item)
	var/amount = input(src,"How many?") as num
	if(toSpawn && amount)
		while(amount)
			new toSpawn(get_turf(src))
			--amount

/mob/verb/SpawnEffect()
	set name = "Spawn Effect"
	set desc = "Spawns an Effect at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/effect)
	var/amount = input(src,"How many?") as num
	if(toSpawn && amount)
		while(amount)
			new toSpawn(get_turf(src))
			--amount

/mob/verb/SpawnTurf()
	set name = "Spawn Turf"
	set desc = "Spawns a turf at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/turf)
	if(toSpawn)
		new toSpawn(get_turf(src))

/mob/verb/SpawnStruct()
	set name = "Spawn Structure"
	set desc = "Spawns a structure at your location"
	set category = "DM"
	var/toSpawn = input(src,"Spawn what?") as null|anything in typesof(/obj/structure)
	if(toSpawn)
		new toSpawn(get_turf(src))
