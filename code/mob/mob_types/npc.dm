/mob/player/npc
	name = "NPC player"

	var/forceRace

	var/timeSinceLast = 0

	var/wander = TRUE
	var/wanderFuzziness = 15 // how high "timeSinceLast" should reach before wandering again
	var/wanderRange = 2

	var/attackFuzziness = 25
	var/nextAttack = 0

	var/npcAbilityProb = 25 // the chance an NPC will select an ability to use

	var/npcMaxWait = 5 //maximum time to wait in certain actions, before reverting to idle

	var/npcState = NPCSTATE_IDLE
	var/npcNature = NPCTYPE_PASSIVE

	var/list/npcSpells // a list of spells given to the NPC on spawn

	speed = 4
	doesProcessing = FALSE

	var/target
	var/turf/walkTarget
	var/list/path = list()
	var/pathflunks = 0
	var/pathLast = 0
	var/pathCooldown = 10

	var/turf/lastPos
	var/list/nearbyPlayers = list()

	var/list/firstName = list("Steve","John","Reggie","Oswald",
	"Daniel","Delilah","Rudy","Christine",
	"Chad","Roma","Jessy","Mike",
	"Gabe","Robert","James","Dandy",
	"Callam","Dillon","Benjamin","George",
	"Randy","Kendal","Kyle","Keith")
	var/list/secondName  = list("Smith","Rivers","Bombastic","Donalds",
	"Stevens","Black","McRand","Compton",
	"Chadswick","Hunt","Horn","Wright",
	"White","Mars","Nahasapeemapetilon",
	"Bush","Clinton","Abbot","Duff")

/mob/player/npc/New()
	if(isMonster)
		defaultItems = list(/obj/item/weapon/monster,/obj/item/armor/monster)
	..()
	if(!isMonster)
		name = "[pick(firstName)] [pick(secondName)]"
		if(forceRace)
			spawn(1)
				raceChange(forceRace,TRUE)
		nameChange(name)
	else
		if(!forceRace)
			raceChange(/datum/race/Beast,TRUE)
			nameChange(initial(name))
		else
			raceChange(forceRace,TRUE)
	globalNPCs |= src

	///
	// NPCs are totes omnipotent
	///
	playerData.playerAbilities.Cut()
	for(var/A in npcSpells)
		playerData.playerAbilities += A

/mob/player/npc/Del()
	globalNPCs -= src
	..()

/*/mob/player/npc/proc/calcStepTowards(var/atom/start,var/atom/end)
	var/turf/T = get_step_towards(start,end)
	if(!T.density && !T.anchored)
		return T
	else
		var/list/validDirs = list()
		for(var/D in alldirs)
			T = get_step(start,D)
			if(!T.density && !T.anchored)
				validDirs += T
		if(validDirs.len)
			var/actShort = pick(validDirs)
			return actShort
	return T*/

/mob/player/npc/proc/MoveTo(var/newtarget)
	target = newtarget

	var/turf/walkTargetNew = get_turf(target)

	if(!walkTargetNew)
		return

	var/isDense = walkTargetNew.density
	for(var/atom/A in walkTarget)
		if(A.density)
			isDense = TRUE
	if(isDense)
		walkTargetNew = FindValid(walkTargetNew)

	if(!walkTargetNew)
		walkTargetNew = walkTarget

	if(pathLast + pathCooldown < world.time && (walkTarget != walkTargetNew || pathflunks > 5))
		walkTarget = walkTargetNew
		spawn(1)
			RecalculatePath(walkTarget)
			//world << "Recalculated path"
		pathflunks = 0

	if(path.len)
		changeState(NPCSTATE_MOVE)
		var/turf/stepT = path[1]
		src.Move(stepT)
		stepT.color = "#00FF00"
		var/moved = (src.loc == stepT)
		if(!moved)
			pathflunks++
		else
			path.Cut(1,2)
			lastPos = get_turf(src)
			if(Adjacent(walkTarget))
				changeState(NPCSTATE_IDLE)

/mob/player/npc/proc/FindValid(var/turf/target)
	var/validPoint = FALSE
	var/rtarget
	for(var/d in alldirs)
		var/turf/T = get_step(target,d)
		if(T)
			if(!T.density)
				rtarget = T
				validPoint = TRUE
				break
	if(!validPoint)
		checkTimeout()
		return

	return rtarget

/mob/player/npc/proc/RecalculatePath(var/turf/target)
	for(var/turf/T in path)
		if(T)
			T.color = null

	path = AStar(get_turf(src), target, /turf/proc/CoolCardinalTurfs, /turf/proc/Distance_cardinal, 0)

	if(!path)
		path = list()

	for(var/turf/T in path)
		if(T)
			T.color = "#FF0000"

	pathLast = world.time

/turf/proc/Distance_cardinal(turf/t)
	if(t != null && src != null)
		//world << abs(src.x - t.x) + abs(src.y - t.y)
		return abs(src.x - t.x) + abs(src.y - t.y)

	else
		//world << 99999
		return 99999

/turf/proc/CoolCardinalTurfs()
	var/list/L = new()
	var/turf/T
	for(var/dir in cardinal)
		T = get_step(src, dir)
		if(istype(T) && !T.density)
			var/free = 1

			for(var/obj/D in T)
				if(D.density)
					free = 0
				break

			if(free)
				L.Add(T)
	return L

/mob/player/npc/proc/checkTimeout()
	if(timeSinceLast >= npcMaxWait)
		changeState(NPCSTATE_IDLE)
		target = null
		timeSinceLast = 0

/mob/player/npc/proc/changeState(var/state)
	npcState = state

/mob/player/npc/proc/updateLocation()
	set background = 1
	spawn(1)
		if(lastPos != loc)
			nearbyPlayers = gmRange(src,7,globalMobList)
			lastPos = loc

/mob/player/npc/proc/processTargets()
	for(var/a in nearbyPlayers)
		if(istype(a,/mob/player))
			if(!mobFaction.isHostile(a:mobFaction))
				if(prob(75))
					continue
			return a
	return null

/mob/player/npc/proc/npcIdle()
	if(npcState == NPCSTATE_IDLE)
		if(wander && timeSinceLast >= wanderFuzziness)
			target = get_step(src,pick(alldirs))
			changeState(NPCSTATE_MOVE)
			timeSinceLast = 0
		if(npcNature == NPCTYPE_AGGRESSIVE)
			var/t = processTargets()
			if(t)
				target = t
				changeState(NPCSTATE_FIGHTING)
				timeSinceLast = 0

/mob/player/npc/proc/npcMove()
	if(npcState == NPCSTATE_MOVE)
		if(prob(5))
			emote("[src] [pick("looks","gazes","stares")] [pick("towards","at","around")] [src]")
		MoveTo(target)
		checkTimeout()

/mob/player/npc/proc/getCastableSpell(var/range)
	shuffle(playerData.playerAbilities)
	for(var/A in playerData.playerAbilities)
		if(prob(npcAbilityProb))
			return A
	return null

/mob/player/npc/proc/npcReset()
	timeSinceLast = 0
	nextAttack = 0
	target = null
	changeState(NPCSTATE_IDLE)

/mob/player/npc/proc/npcCombat()
	var/obj/item/AH = activeHand()
	if(AH)
		wanderRange = AH:range
	else
		wanderRange = initial(wanderRange)
	var/distTo = get_dist(src,target)
	if(npcState == NPCSTATE_FIGHTING)
		if(target)
			var/isFT = FALSE
			if(target:mobFaction)
				isFT = target:mobFaction.isFriendly(mobFaction)
			if(target:checkEffectStack("dead") || target:checkEffectStack("dying"))
				if(!isFT)
					npcReset()
			if(world.time >= nextAttack)
				if(prob(5))
					emote("[src] [pick("growls","glares","roars")] [pick("towards","at","around")] [src]")
				var/A = getCastableSpell(distTo)
				var/datum/ability/C
				if(!ispath(A))
					C = A
				else
					C = new A
				spawn(1)
					if(!target)
						npcReset()
						return
					if(C)
						if(C.abilityRange <= distTo)
							changeState(NPCSTATE_MOVE)
						else if(!isFT && C.abilityModifier >= 0)
							C.tryCast(src,src)
						else if(isFT && C.abilityModifier >= 0)
							C.tryCast(src,target)
						else if(!isFT && C.abilityModifier <= 0)
							C.tryCast(src,target)
				if(!isFT)
					spawn(1)
						if(!target)
							npcReset()
							return
						if(distTo < wanderRange)
							intent = INTENT_HARM
							if(AH)
								if(AH.range <= 1)
									target:objFunction(src,AH)
								else
									AH.onUsed(src,target)
							else
								target:objFunction(src)
						else
							changeState(NPCSTATE_MOVE)
				else
					changeState(NPCSTATE_MOVE)
				timeSinceLast = 0
				nextAttack = world.time + attackFuzziness

/mob/player/npc/processAttack(var/mob/player/a,var/mob/player/v)
	..(a,v)
	if(v == src)
		target = a
		changeState(NPCSTATE_FIGHTING)

/mob/player/npc/doProcess()
	..()
	if(isDisabled())
		npcState = NPCSTATE_IDLE
		return
	else
		updateLocation()
		npcIdle()
		npcMove()
		npcCombat()
	timeSinceLast++