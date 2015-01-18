var/list/procObjects = list()
var/list/cooldownHandler = list()
var/list/controllers = list()

/world
	turf = /turf/floor/voidFloor
	fps = 15
	icon_size = 32

/world/New()
	spawn(10)
		var/icon/face = icon('sprite/mob/human_face.dmi')
		for(var/i in face.IconStates())
			if(copytext(i,1,7) == "facial")
				playerValidFacial |= i
			else if(copytext(i,1,5) == "hair")
				playerValidHair |= i
		processObjects()
		processCooldowns()
		//CONTROLLERS
		controllers |= new /datum/controller/lighting
		processControllers()
	..()

/proc/addProcessingObject(var/atom/movable/a)
	a.preProc()
	procObjects += a

/proc/remProcessingObject(var/atom/movable/r)
	r.postProc()
	procObjects -= r


/proc/filterList(var/filter, var/list/inList, var/list/explicitExcluded)
	set background = 1
	var/list/newList = list()
	for(var/i = 1, i <= inList.len, i++)
		var/j = inList[i]
		if(explicitExcluded)
			if(j in explicitExcluded)
				continue
		if(!istype(j, filter))
			continue

		newList += j
	. = newList

/proc/processControllers()
	if(controllers.len)
		for(var/datum/controller/a in controllers)
			a.doProcess()
	spawn(1)
		processControllers()

/proc/processCooldowns()
	if(cooldownHandler.len)
		for(var/datum/ability/a in cooldownHandler)
			--a.abilityCooldownTimer
			if(a.abilityCooldownTimer <= 0)
				a.abilityCooldownTimer = 0 //just to be sure
				cooldownHandler.Remove(a)
			a.holder.refreshInterface()
	spawn(1)
		processCooldowns()

/proc/processObjects()
	if(procObjects.len)
		for(var/atom/movable/i in procObjects)
			i.doProcess()
	spawn(1)
		processObjects()

/proc/processFlags(var/mob/player/who)
	var/flagToCheck = who.persistingEffects[1]
	for(var/i in who.persistingEffects)
		if(i == ACTIVE_STATE_DYING)
			who.takeDamage(1,DTYPE_DIRECT)
		//reduce time
		if(i == 0)
			mobRemFlag(who,flagToCheck,1)
		else if (who.persistingEffects.Find(i) % 2)
			if(i > 0)
				--i
		flagToCheck = i

/proc/mobAddFlag(var/mob/player/who, var/flag, var/length=-1, var/active=0)
	if(active)
		setFlag(who.active_states, flag)
		who.persistingEffects |= flag
		who.persistingEffects |= length
	else
		setFlag(who.passive_states,flag)

/proc/mobRemFlag(var/mob/player/who, var/flag, var/active=0)
	if(active)
		remFlag(who.active_states, flag)
		var/indexOf = who.persistingEffects.Find(flag)
		if(indexOf)
			who.persistingEffects.Cut(indexOf,indexOf+1)
	else
		remFlag(who.passive_states, flag)

/proc/checkFlag(var/on, var/flag)
	return (on & flag)

/proc/setFlag(var/on, var/flag)
	if(!checkFlag(on,flag))
		on |= flag

/proc/remFlag(var/on, var/flag)
	if(checkFlag(on,flag))
		on &= ~flag

/proc/do_roll(var/times,var/dice,var/bonus)
	var/rolled = 0
	var/count = times
	while(count > 0)
		rolled += rand(1,dice)
		--count
	rolled += bonus
	return rolled

/proc/savingThrow(var/mob/player/try, var/bonus, var/stat=SAVING_REFLEX)
	if(!try.playerData)
		return pick(TRUE,FALSE) //no stats? screw you have some rnd

	var/datum/playerFile/data = try.playerData
	var/datum/stat/compare
	switch(stat)
		if(SAVING_REFLEX)
			compare = data.ref
			bonus += data.dex.statCur
		if(SAVING_WILL)
			compare = data.will
			bonus += data.wis.statCur
		if(SAVING_FORTITUDE)
			compare = data.fort
			bonus += data.con.statCur
	if(do_roll(1,20,bonus) >= data.save.statCur + compare.statCur)
		return TRUE

	return FALSE

/proc/parseIcon(var/toWhere, var/parse, var/chat = TRUE)
	var/icon/i
	if(istype(parse,/mob))
		var/mob/m = parse
		i = icon(m.icon)
		for(var/o in m.overlays)
			i.Blend(icon(icon=o:icon,icon_state=o:icon_state),ICON_OVERLAY)
			if(o:color)
				i.Blend(o:color,ICON_MULTIPLY)
		toWhere << browse_rsc(i,"[parse:icon_state].png")
		if(chat)
			return {"<img src="\ref[fcopy_rsc(i)]">"}
		else
			return {"<img src='[parse:icon_state].png'>"}
	if(istype(parse,/obj))
		var/obj/m = parse
		i = icon(m.icon,m.icon_state)
		for(var/o in m.overlays)
			i.Blend(icon(icon=o:icon,icon_state=o:icon_state),ICON_OVERLAY)
			if(o:color)
				i.Blend(o:color,ICON_MULTIPLY)
		toWhere << browse_rsc(i,"[parse:icon_state].png")
		if(chat)
			return {"<img src="\ref[fcopy_rsc(i)]">"}
		else
			return {"<img src='[parse:icon_state].png'>"}
	else
		return "\icon[parse]"

/proc/displayInfo(var/personal as text,var/others as text, var/mob/toWho, var/fromWhat,var/color="blue")
	toWho << "<font color=[color]>[parseIcon(toWho,fromWhat)] > [parseIcon(toWho,toWho)] | [personal]</font>"
	for(var/mob/m in oview(world.view,toWho))
		if(m == toWho)
			continue
		m << "<font color=[color]>[parseIcon(m,fromWhat)] > [parseIcon(m,toWho)] | [others]</font>"

/proc/displayTo(var/personal as text, var/mob/toWho, var/fromWhat,var/color="blue")
	toWho << "<font color=[color]>[parseIcon(toWho,fromWhat)] > [parseIcon(toWho,toWho)] | [personal]</font>"

/proc/chatSay(var/msg as text)
	world << "<font color=black>\icon[usr][usr]: [msg]</font>"

/atom/proc/examine(mob/user)
	var/f_name = "\a [src]"

	user << "[parseIcon(user,src)] That's [f_name]"

	if(desc)
		user << " > [desc]"