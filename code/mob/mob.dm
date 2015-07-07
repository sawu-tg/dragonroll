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

	///vehicle shit, sue me
	var/obj/vehicle/mounted

	prevent_pickup = TRUE

	var/isDualWielding = FALSE
	var/wieldedWeight = 0


/mob/garbageCleanup()
	..()
	globalMobList -= src
	if(castingSpell)
		sdel(castingSpell)
		castingSpell = null
	if(Cursor)
		sdel(Cursor)
		Cursor = null
	if(mobFaction)
		sdel(mobFaction)
		mobFaction = null
	if(mounted)
		sdel(mounted)
		mounted = null


/mob/New()
	..()
	remAdminVerbs(src)
	spawn(1)
		makeSlotsFromRace(new/datum/race)
		spawn(1)
			defaultInterface()
			refreshInterface()
	mobFaction = findFaction("Colonist")
	add_pane(/datum/windowpane/verbs)
	spawn(15)
		if(client)
			if(client.key in globalAdmins)
				addAdminVerbs(src)

/mob/Login()
	if(!client.mob)
		spawn(5)
			var/mob/player/P = new
			client.mob = P
			spawn(5)
				P.playerSheet()
	..()

/mob/Move(var/atom/newLoc)
	if(mounted)
		if(mounted.CanPass(newLoc))
			mounted.Move(newLoc)
			return ..()
	if(!newLoc)
		return
	if(client)
		if(client.isDM)
			..()
	if(canMove && !checkEffectStack("no_move") && !newLoc.density && !anchored)
		..()

/client/Click(var/clickedOn)
	if(mob)
		if(mob.casting == TRUE && istype(clickedOn,/atom/movable))
			mob.castingSpell.heldAbility.tryCast(mob,clickedOn)
			mob.casting = FALSE
			mob.castingSpell = null
			mob.client.mouse_pointer_icon = null
		else
			..()

/mob/proc/bloodSpray(var/dir,var/number,var/intensity)
	for(var/i = 0; i < number; ++i)
		new/obj/effectBot(get_turf(src),/obj/effect/blood/trail,/obj/effect/blood,dir,intensity)
//////////////////////////////////////////////////////

/mob/proc/processAttack(var/mob/player/attacker,var/mob/player/victim)
	var/damage = attacker.playerData.str.statModified
	var/adex = attacker.playerData.dex.statModified
	damage += adex/2
	var/def = victim.playerData.def.statModified //only here for calculations in output
	var/dex = victim.playerData.dex.statModified
	var/obj/item/mainHand = attacker.activeHand()
	var/obj/item/offHand = attacker.offHand()
	var/attackString = "punch [victim]"
	if(mainHand)
		attackString = "hit [victim] with [mainHand.name]"
		damage += (mainHand.force+mainHand.weight)*mainHand.size
		if(attacker.isDualWielding)
			attackString += " and [offHand.name]"
			if(attacker.playerData.dex.statModified/2 >= attacker.wieldedWeight)
				damage += ((offHand.force+offHand.weight)*offHand.size)/2
			else
				damage += ((offHand.force+offHand.weight)*offHand.size)/8
				if(prob(100-attacker.playerData.dex.statModified))
					attacker.addStatusEffect(/datum/statuseffect/stun,15)
		if(mainHand.force > mainHand.weight) // higher force than weight, probably a sword or cutting thing
			bloodSpray(turn(src.dir,90),max(mainHand.force/4,1),max(mainHand.weight/2,1))
			bloodSpray(turn(src.dir,-90),max(mainHand.force/4,1),max(mainHand.weight/2,1))
		else // its a smashy weapon
			for(var/cdir in alldirs)
				bloodSpray(cdir,max(mainHand.force/4,1),max(mainHand.weight/4,1))
	if(do_roll(1,def/2,dex) > damage)
		playsound(get_turf(src), 'sound/weapons/punchmiss.ogg', 50, 1)
		var/tod = !victim.isMonster ? "parry" : "feint"
		src.popup("[tod]",rgb(255,255,0))
		var/newDamage = victim.isMonster ? damage/2 : damage/2
		newDamage = round(newDamage)
		attacker.takeDamage(newDamage)
	else
		var/realDamage = victim.takeDamage(damage)
		if(realDamage > 0)
			messageArea("You [attackString] for [realDamage]HP (1d[damage]-[def])","[attacker] hits [victim] for [realDamage]HP (1d[damage]-[def])",attacker,victim,"red")
		else
			messageArea("Your blow only glances! (1d[damage]-[def])","[attacker] hits [victim] with a glancing blow! (1d[damage]-[def])",attacker,victim,"green")
			playsound(get_turf(src), 'sound/weapons/punchmiss.ogg', 50, 1)
			attacker.takeDamage(1,DTYPE_DIRECT)

/mob/proc/intent2string()
	if(intent == 1)
		return "Helping"
	if(intent == 2)
		return "Harming"
	if(intent == 3)
		return "Sneaking"
	if(intent == 4)
		return "Diplomatic"

/mob/objFunction(var/mob/user,var/obj/inHand)
	if(user.intent == INTENT_DIPLOMACY)
		if(inHand)
			doTrade(user,inHand)
		else
			if(!client)
				user.lastChatted = src
				myChat.chatTo(user)
	if(user.intent == INTENT_HELP)
		if(user == src)
			messagePlayer("You brush yourself off",src,src)
		else
			messageArea("You hug [src]","[user] hugs [src]",user,src)
		playsound(get_turf(src), 'sound/weapons/thudswoosh.ogg', 50, 1)
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
	for(var/slotid in slots)
		var/obj/interface/slot/S = slots[slotid]
		screenObjs += S
		interfaceSlots += S

	screenObjs += new/obj/interface/pickupButton(10,1,"box",32)
	screenObjs += new/obj/interface/dropButton(11,1,"box",32)
	screenObjs += new/obj/interface/storeButton(11,2,"box",32)
	screenObjs += new/obj/interface/useButton(12,1,"box",32)
	screenObjs += new/obj/interface/dropIButton(12,2,"box",32)
	screenObjs += new/obj/interface/throwButton(10,2,"box",32)
	screenObjs += new/obj/interface/intentButton(13,1,"box",32)
	screenObjs += new/obj/interface/leapButton(13,2,"box",32)
	screenObjs += new/obj/interface/dwButton(14,1,"box",32)

/mob/proc/refreshInterface()
	if(client)
		var/plyRef = istype(src,/mob/player)
		screenObjs -= Cursor
		if(plyRef)
			screenObjs -= src:MM
		client.screen = newlist()
		if(plyRef)
			screenObjs |= src:MM
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
						var/image/sa = image(icon=SC.heldSpell.heldAbility.abilityIcon,icon_state=SC.heldSpell.heldAbility.abilityState)
						var/image/scd = image(icon='sprite/obj/ability.dmi',icon_state="cd_[cd]")
						SC.overlays |= sa
						SC.overlays |= scd
						//hacky, sue me
						spawn(15)
							I.overlays.Cut()
							SC.overlays |= image(icon=SC.heldSpell.heldAbility.abilityIcon,icon_state=SC.heldSpell.heldAbility.abilityState)
			I.showTo(src)

		for(var/slotid in slots)
			var/obj/interface/slot/S = slots[slotid]

			S.align(src)
			S.rebuild()

		update_panes()
