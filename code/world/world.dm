var/list/procObjects = list()
var/list/cooldownHandler = list()
var/datum/controller_master/CS
var/list/globalSuns = list()
var/list/levelNames = list()

/world
	turf = /turf/floor/voidFloor
	mob = /mob/player
	view = 9
	fps = 15
	icon_size = 32
	loop_checks = 0


/world/New()
	. = ..()
	spawn(10)
		var/icon/face = icon('sprite/mob/human_face.dmi')
		for(var/i in face.IconStates())
			if(copytext(i,1,7) == "facial")
				playerValidFacial |= i
			else if(copytext(i,1,5) == "hair")
				playerValidHair |= i
		world << "<b>GENERATING WORLD..</b>"
		spawn(1)
			for(var/i = 1; i < world.maxz; i++)
				generate(i)
		spawn(10)
			world << "<b>FINISHED!</b>"
		processObjects()
		processCooldowns()
		//CONTROLLERS
		CS = new
		CS.addControl(new /datum/controller/machinery)
		CS.addControl(new /datum/controller/lighting)
		CS.process()
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
		for(var/atom/i in procObjects)
			i.doProcess()
	spawn(1)
		processObjects()

/proc/processFlags(var/mob/player/who)
	for(var/i in who.persistingEffects)
		if(i == ACTIVE_STATE_DYING)
			who.takeDamage(1,DTYPE_DIRECT)
		if(i == ACTIVE_STATE_DAZED)
			who.speed = who.actualSpeed/4
		//reduce time
		if(who.persistingEffects[i] == 0)
			mobRemFlag(who,i,1)
		else if(who.persistingEffects[i] % 2)
			if(who.persistingEffects[i] > 0)
				--who.persistingEffects[i]

/proc/mobAddFlag(var/mob/player/who, var/flag, var/length=-1, var/active=0)
	if(active)
		setFlag(who.active_states, flag)
		who.persistingEffects["[flag]"] = length
	else
		setFlag(who.passive_states,flag)

/proc/mobRemFlag(var/mob/player/who, var/flag, var/active=0)
	if(active)
		remFlag(who.active_states, flag)
		who.persistingEffects["[flag]"] = null
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
	var/visibleMessage = toWho == fromWhat ? "[fromWhat:name]" : "[fromWhat:name] > [toWho:name]"
	toWho << "<font color=[color]>[visibleMessage]: [personal]</font>"
	for(var/mob/m in oview(world.view,toWho))
		if(m == toWho)
			continue
		m << "<font color=[color]>[visibleMessage]: [others]</font>"

/proc/displayTo(var/personal as text, var/mob/toWho, var/fromWhat,var/color="blue")
	var/visibleMessage = toWho == fromWhat ? "[fromWhat:name]" : "[fromWhat:name] > [toWho:name]"
	toWho << "<font color=[color]>[visibleMessage]: [personal]</font>"

/proc/chatSay(var/msg as text)
	world << "<font color=black>[usr]: [msg]</font>"

/proc/circle(turf/source,radius=1,var/expensive = FALSE)
	var/list/l = list()
	var/rsq = radius * (radius+0.50)
	var/path = text2path("/[expensive ? "atom" : "turf"]")
	var/list/around = view(radius,source)
	var/count = 0
	for(count = 1; count < around.len; ++count)
		var/T = around[count]
		if(istype(T,path))
			var/dx = T:x - source.x
			var/dy = T:y - source.y
			if(dx*dx + dy*dy <= rsq)
				l |= T
	. = l

/proc/circleRange(turf/source,radius=1,var/expensive = FALSE)
	var/list/l = list()
	var/rsq = radius * (radius+0.50)
	var/path = text2path("/[expensive ? "atom" : "turf"]")
	var/list/around = range(radius,source)
	var/count = 0
	for(count = 1; count < around.len; ++count)
		var/T = around[count]
		if(istype(T,path))
			var/dx = T:x - source.x
			var/dy = T:y - source.y
			if(dx*dx + dy*dy <= rsq)
				l |= T
	. = l

/proc/generateName(var/forWhat)
	if(forWhat == 0)
		var/list/prefix = list("Kal'","Kom'","Bre'","Tor","Jan'","Min","Zer'","Na")
		var/list/suffix = list("toth","kim","herl","bof","rend","fren","roff","hert","pindreth","gallod")
		return "[pick(prefix)][pick(suffix)]"

//terrain generation

#define lowestChance 1
#define maxColonists 5

/proc/generate(var/zLevel)
	var/cB = pick(validBiomes)
	var/datum/biome/chosenBiome = new cB()

	var/decoChance = chosenBiome.debrisChance
	var/turfScale = chosenBiome.turfSize
	var/colonyChance = chosenBiome.mobChance
	var/liquidScale = chosenBiome.liquidSize

	var/x = world.maxx
	var/y = world.maxy
	var/colonists = 0

	if(zLevel == 1)
		levelNames.Add("Lobby")
	else
		levelNames.Add(generateName(0))

	var/tilesBetweenLiquid = 1024
	var/tile2LiquidCounter = 0

	world << "<i>GENERATING TURFS ON Z[zLevel]..</i>"
	for(var/a = 1; a <= x; ++a)
		for(var/b = 1; b <= y; ++b)
			if(zLevel == 1)
				continue
			var/turf/T = locate(a,b,zLevel)
			T = new chosenBiome.baseTurf(T)
			if(prob(lowestChance))
				for(var/turf/T2 in range(T,rand(0,turfScale)))
					var/turf/T3 = pick(chosenBiome.validTurfs)
					T2 = new T3(T2)

	world << "<i>GENERATING LIQUIDS ON Z[zLevel]..</i>"
	var/list/liqMade = list()
	for(var/a = 1; a <= x; ++a)
		for(var/b = 1; b <= y; ++b)
			if(zLevel == 1)
				continue
			var/turf/T = locate(a,b,zLevel)
			if(chosenBiome.validLiquids.len)
				if(prob(lowestChance) && tile2LiquidCounter <= 0)
					tile2LiquidCounter = tilesBetweenLiquid
					for(var/i = liquidScale; i > 0; --i)
						for(var/turf/T2 in circle(T,i))
							var/turf/T3 = pick(chosenBiome.validLiquids)
							var/turf/floor/outside/liquid/T4 = new T3(T2)
							T4.depth = 100 - (15*i)
							T4.updateDepth()
							liqMade |= T4
				if(tile2LiquidCounter > 0)
					tile2LiquidCounter--

	world << "<i>ERODING LIQUIDS ON Z[zLevel]..</i>"
	for(var/turf/floor/outside/liquid/EL in liqMade)
		if(prob(liquidScale))
			for(var/T in circle(EL,1))
				if(istype(T,/turf/floor/outside/liquid))
					var/turf/T2 = pick(chosenBiome.validTurfs)
					EL = new T2(T)


	world << "<i>GENERATING DECORATIONS ON Z[zLevel]..</i>"
	for(var/a = 1; a <= x; ++a)
		for(var/b = 1; b <= y; ++b)
			if(zLevel == 1)
				continue
			var/turf/T = locate(a,b,zLevel)
			if(a == x/2 && b == y/2)
				if(!T.light)
					var/obj/trigger/portal/P = new/obj/trigger/portal(T)
					for(var/turf/D in range(P,5))
						D = new chosenBiome.baseTurf(D)
					P.name = "[levelNames[zLevel]] the [chosenBiome.name]"
					P.safe = FALSE
					T.set_light(world.maxx,world.maxx) //This doesn't quite work.
					globalSuns += T
			else
				if(prob(decoChance))
					if(!(T.type in chosenBiome.validLiquids))
						var/obj/o = pick(chosenBiome.validDebris)
						new o(T)
				if(prob(colonyChance))
					if(colonists < maxColonists)
						var/mob/m = pick(chosenBiome.validMobs)
						new m(T)
						colonists++
#undef lowestChance
#undef maxColonists