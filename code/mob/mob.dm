/mob
	icon = 'sprite/mob/human.dmi'
	luminosity = 4
	var/list/screenObjs = list()
	var/intent = INTENT_HELP
	var/canMove = TRUE
	//spell vars
	var/casting = FALSE

	var/obj/selectedQuickSlot
	var/obj/interface/quickSlotCursor
	var/list/interfaceHands = list()
	var/obj/leftHand
	var/obj/rightHand
	var/obj/leftPocket
	var/obj/rightPocket

	var/list/handOrder = list()

	var/obj/spellHolder/castingSpell
	var/obj/interface/Cursor
	var/maxHotkeys = 9
	var/selectedHotKey = 1
	var/datum/faction/mobFaction

	prevent_pickup = TRUE

/mob/New()
	spawn(1)
		leftHand = new
		rightHand = new
		rightPocket = new
		leftPocket = new
		handOrder = list(leftPocket,leftHand,rightHand,rightPocket)
		selectedQuickSlot = leftPocket
		spawn(1)
			defaultInterface()
			refreshInterface()

/mob/Login()
	if(!client.mob || !(istype(client.mob,/mob/player)))
		spawn(5)
			var/mob/player/P = new
			client.mob = P
			spawn(5)
				P.playerSheet()
	..()

/mob/Move(var/atom/newLoc)
	if(canMove && !newLoc.anchored)
		..()
		if(src.light)
			light.loc = src.loc
			light.update()
	else
		return

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

/mob/objFunction(var/mob/user)
	if(user.intent == INTENT_HELP)
		if(user == src)
			displayTo("You brush yourself off",src,src)
		else
			displayInfo("You hug [src]","[user] hugs [src]",user,src)
	if(user.intent == INTENT_HARM)
		processAttack(user,src)

/mob/proc/defaultInterface()
	var/total = 0
	for(var/i = 1; i <= maxHotkeys; ++i)
		screenObjs += new/obj/interface/spellContainer("[i]",1,"sphere")
		var/obj/interface/spellContainer/scrnobj = screenObjs[screenObjs.len]
		scrnobj.name = "Slot [i]"
		scrnobj.hotKey = i
		total++
	for(var/i = 1; i <= maxHotkeys; ++i)
		screenObjs += new/obj/interface("[i]",1,"[i]")
	for(var/a = 1; a < handOrder.len+1; ++a)
		var/obj/interface/shortcut/hand = new/obj/interface/shortcut("[total + a]",1,"box")
		hand.rebuild(handOrder[a])
		screenObjs += hand
		interfaceHands += hand
		screenObjs += new/obj/interface("[total + a]",1,"[a >= 3 ? "R" : "L"]")

	screenObjs += new/obj/interface/pickupButton(10,2,"box",32)
	screenObjs += new/obj/interface/dropButton(13,2,"box",32)
	screenObjs += new/obj/interface/storeButton(11,2,"box",32)
	screenObjs += new/obj/interface/useButton(12,2,"box",32)

/mob/proc/refreshInterface()
	if(client)
		screenObjs -= Cursor
		client.screen = newlist()
		Cursor = new/obj/interface(selectedHotKey,1,"select")
		Cursor.layer = LAYER_INTERFACE+0.1
		screenObjs |= Cursor
		for(var/obj/interface/I in screenObjs)
			if(istype(I,/obj/interface/spellContainer))
				var/obj/interface/spellContainer/SC = I
				if(SC.heldSpell)
					if(SC.heldSpell.heldAbility.abilityCooldownTimer)
						I.overlays.Cut()
						var/cd = round(min(10,SC.heldSpell.heldAbility.abilityCooldownTimer/60),1)
						SC.overlays |= image(icon=SC.heldSpell.heldAbility.abilityIcon,icon_state=SC.heldSpell.heldAbility.abilityState)
						SC.overlays |= image(icon='sprite/obj/ability.dmi',icon_state="cd_[cd]")
						//hacky, sue me
						spawn(15)
							I.overlays.Cut()
							SC.overlays |= image(icon=SC.heldSpell.heldAbility.abilityIcon,icon_state=SC.heldSpell.heldAbility.abilityState)
			I.showTo(src)

		var/activeHand
		if(selectedQuickSlot == leftPocket)
			activeHand = 1
		if(selectedQuickSlot == leftHand)
			activeHand = 2
		if(selectedQuickSlot == rightHand)
			activeHand = 3
		if(selectedQuickSlot == rightPocket)
			activeHand = 4

		screenObjs -= quickSlotCursor
		quickSlotCursor = new/obj/interface("[maxHotkeys+activeHand]",1,"active")
		quickSlotCursor.layer = LAYER_INTERFACE+0.1
		screenObjs |= quickSlotCursor

		for(var/obj/interface/shortcut/S in interfaceHands)
			var/obj/O = handOrder[interfaceHands.Find(S)]
			if(O.contents.len > 0)
				S.rebuild(O.contents[1])
			else
				S.rebuild(null)