/mob/player/npc/colonist
	name = "Colonist No-Name"
	npcNature = NPCTYPE_DEFENSIVE
	wanderFuzziness = 5
	var/maleNames = list("Steve","John","Rodger","Allen","William","Deepak","Fredrick","Joshua","Adam","Lee")
	var/femaleNames = list("Rebecca","Daisy","Eliza","Elizabeth","Haley","Lucy","Eda","Eve","Penny")

/mob/player/npc/colonist/New()
	..()
	name = playerData.playerGender == 0 ? pick(maleNames) : pick(femaleNames)
	//give it clothing or some shit