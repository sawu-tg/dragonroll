/mob/player/npc/genie
	name = "Nameless"
	forceRace = /datum/race/Genie
	npcNature = NPCTYPE_DEFENSIVE
	wanderFuzziness = 5
	var/obj/item/mob_spawner/genie/myLamp
	var/returnTime = 100

/mob/player/npc/genie/New()
	..()
	genderChange("Male")
	name = pick("The Genie","Dreamed-of", "D'john", "Mrs. Pu Pu", "Wishmonger", "Jeanne", "Onya")
	myLamp = locate(/obj/item/mob_spawner/genie) in range(3)

/mob/player/npc/genie/doProcess()
	..()
	if(returnTime > 0)
		returnTime--
	else
		if(loc != myLamp && myLamp != null)
			step_to(src,myLamp)
			if(loc == myLamp.loc)
				loc = myLamp