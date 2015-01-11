/mob
	icon = 'sprite/mob/human.dmi'
	luminosity = 4
	var/intent = INTENT_HELP
	var/canMove = TRUE

/mob/Login()
	if(!client.mob || !(istype(client.mob,/mob/player)))
		var/mob/player/P = new
		client.mob = P
		spawn(5)
			P.playerSheet()
	..()

/mob/Move()
	if(canMove)
		..()
	else
		return
	updateLighting()

/mob/proc/processAttack(var/mob/player/attacker,var/mob/player/victim)
	var/damage = attacker.playerData.str.statCur
	var/def = victim.playerData.def.statCur //only here for calculations in output
	victim.takeDamage(damage)
	displayInfo("You hit [victim] for [max(0,damage-def)]HP (1d[damage]-[def])","[attacker] hits [victim] for [max(0,damage-def)]HP (1d[damage]-[def])",attacker,victim,"red")

/mob/proc/intent2string()
	if(intent == 1)
		return "Helping"
	if(intent == 2)
		return "Harming"
	if(intent == 3)
		return "Sneaking"

/mob/verb/changeIntent()
	set name = "Change Intent"
	if(intent < 3)
		intent++
	else
		intent = 1
	displayTo("Your intent is now [intent2string()]",src,src)

/mob/objFunction(var/mob/user)
	if(user.intent == INTENT_HELP)
		if(user == src)
			displayTo("You brush yourself off",src,src)
		else
			displayInfo("You hug [src]","[user] hugs [src]",user,src)
	if(user.intent == INTENT_HARM)
		processAttack(user,src)