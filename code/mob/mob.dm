/mob
	icon = 'sprite/mob/human.dmi'
	luminosity = 4
	var/list/screenObjs = list()
	var/intent = INTENT_HELP
	var/canMove = TRUE
	//spell vars
	var/casting = FALSE
	var/obj/spellHolder/castingSpell
	var/obj/interface/Cursor
	var/maxHotkeys = 9
	var/selectedHotKey = 1

/mob/New()
	spawn(1)
		defaultInterface()
		refreshInterface()

/mob/verb/forceRefreshInterface()
	set name = "Refresh Interface"
	set category = "Debug Verbs"
	for(var/o in screenObjs)
		usr << "Refreshing [o]"
	refreshInterface()

/mob/Login()
	if(!client.mob || !(istype(client.mob,/mob/player)))
		spawn(5)
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

//interface cmds
//we're going to assume screenObjs 0 - 9 are the correct objs
///////////////////////////////////////////////////////////////
/mob/verb/KeyDown0()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[0]
	O.objFunction()

/mob/verb/KeyDown1()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[1]
	O.objFunction()

/mob/verb/KeyDown2()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[2]
	O.objFunction()

/mob/verb/KeyDown3()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[3]
	O.objFunction()

/mob/verb/KeyDown4()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[4]
	O.objFunction()

/mob/verb/KeyDown5()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[5]
	O.objFunction()

/mob/verb/KeyDown6()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[6]
	O.objFunction()

/mob/verb/KeyDown7()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[7]
	O.objFunction()

/mob/verb/KeyDown8()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[8]
	O.objFunction()

/mob/verb/KeyDown9()
	set hidden = TRUE
	var/obj/interface/O = screenObjs[9]
	O.objFunction()

/mob/verb/NextHotkey()
	if(selectedHotKey + 1 <= maxHotkeys)
		++selectedHotKey
	else
		selectedHotKey = 1
	refreshInterface()

/mob/verb/UseHotkey()
	world << "[selectedHotKey] is [screenObjs[selectedHotKey]]"
	call(usr,"KeyDown[selectedHotKey]")(usr)

/mob/verb/LastHotkey()
	if(selectedHotKey - 1 >= 1)
		--selectedHotKey
	else
		selectedHotKey = 9
	refreshInterface()

/client/Click(var/clickedOn)
	if(mob)
		if(mob.casting == TRUE && istype(clickedOn,/atom/movable))
			mob.castingSpell.heldAbility.tryCast(mob,clickedOn)
			mob.casting = FALSE
			mob.castingSpell = null
			mob.client.mouse_pointer_icon = null
		else
			..()
//////////////////////////////////////////////////////

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

/mob/proc/defaultInterface()
	for(var/i = 1; i <= maxHotkeys; ++i)
		screenObjs += new/obj/interface/spellContainer("[i]",1,"sphere")
		var/obj/interface/spellContainer/scrnobj = screenObjs[screenObjs.len]
		scrnobj.name = "Slot [i]"
		scrnobj.hotKey = i
	for(var/i = 1; i <= maxHotkeys; ++i)
		screenObjs += new/obj/interface("[i]",1,"[i]")

/mob/proc/refreshInterface()
	if(client)
		screenObjs -= Cursor
		client.screen = newlist()
		Cursor = new/obj/interface(selectedHotKey,1,"select")
		Cursor.layer = LAYER_INTERFACE+0.1
		screenObjs |= Cursor
		for(var/obj/interface/I in screenObjs)
			I.showTo(src)