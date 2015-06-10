/mob/player/npc
	name = "NPC player"

	var/forceRace

	var/timeSinceLast = 0

	var/wander = TRUE
	var/wanderFuzziness = 15 // how high "timeSinceLast" should reach before wandering again
	var/attackFuzziness = 25
	var/wanderRange = 2

	var/npcMaxWait = 5 //maximum time to wait in certain actions, before reverting to idle

	var/npcState = NPCSTATE_IDLE
	var/npcNature = NPCTYPE_PASSIVE

	speed = 4
	doesProcessing = FALSE
	var/target
	var/turf/lastPos
	var/list/actualView = list()
	var/list/inView = list()
	var/list/inRange = list()

	var/list/firstName = list("Steve","John","Reggie","Oswald","Daniel","Delilah","Rudy","Christine","Chad","Roma","Jessy","Mike","Gabe")
	var/list/secondName  = list("Smith","Rivers","Bombastic","Donalds","Stevens","Black","McRand","Compton","Chadswick","Hunt","Horn")

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
		raceChange(/datum/race/Beast,TRUE)
	globalNPCs |= src


/mob/player/npc/verb/debug()
	set src in range(7)
	usr << "<b>=============================</b>"
	usr << "Name: [name]"
	usr << "TSL: [timeSinceLast]"
	usr << "wander: [wander]"
	usr << "fuzziness: [wanderFuzziness]"
	usr << "range: [wanderRange]"
	usr << "maxWait: [npcMaxWait]"
	usr << "state: [npcState]"
	usr << "nature: [npcNature]"
	usr << "speed: [speed]"
	usr << "target: [target]"
	usr << "disabled: [isDisabled()]"
	usr << "lastpos: [lastPos]"
	usr << "inView: [inView.len]"
	usr << "inRange: [inRange.len]"
	usr << "isMonster: [isMonster]"
	usr << "<b>=============================</b>"

/mob/player/npc/proc/MoveTo(var/target)
	if(npcState != NPCSTATE_MOVE)
		npcState = NPCSTATE_MOVE
	var/turf/walkTarget = get_turf(target)
	if(walkTarget)
		if(walkTarget.density)
			var/validPoint = FALSE
			for(var/turf/T in range(walkTarget,2))
				if(!T.density)
					walkTarget = T
					validPoint = TRUE
			if(!validPoint)
				checkTimeout()
				return
		lastPos = loc
		Move(get_step_towards(src,walkTarget))

/mob/player/npc/proc/checkTimeout()
	if(timeSinceLast >= npcMaxWait)
		changeState(NPCSTATE_IDLE)
		target = null
		timeSinceLast = 0

/mob/player/npc/proc/changeState(var/state)
	npcState = state

/mob/player/npc/proc/updateLocation()
	if(lastPos != loc)
		actualView = oview(src,world.view)
		inView = oview(src,wanderRange)
		inRange = orange(src,wanderRange)
		lastPos = loc

/mob/player/npc/proc/processTargets()
	for(var/a in actualView)
		if(istype(a,/mob/player))
			if(mobFaction.isHostile(a:mobFaction))
				return a
	return null

/mob/player/npc/proc/npcIdle()
	if(npcState == NPCSTATE_IDLE)
		if(wander && timeSinceLast >= wanderFuzziness)
			if(inView.len)
				target = pick(inView)
				changeState(NPCSTATE_MOVE)
				timeSinceLast = 0
		if(npcNature == NPCTYPE_AGGRESSIVE)
			var/t = processTargets()
			if(t)
				target = t
				npcState = NPCSTATE_FIGHTING
				timeSinceLast = 0

/mob/player/npc/proc/npcMove()
	if(npcState == NPCSTATE_MOVE)
		MoveTo(target)
		checkTimeout()

/mob/player/npc/proc/npcCombat()
	var/obj/item/AH = activeHand()
	if(AH)
		wanderRange = AH:range
	else
		wanderRange = initial(wanderRange)
	if(npcNature == NPCTYPE_PASSIVE)
		return
	if(npcState == NPCSTATE_FIGHTING)
		if(target)
			if(timeSinceLast >= attackFuzziness)
				if(istype(target,/mob/player))
					if(get_dist(src,target) < wanderRange && target:playerData.hp.statModified > 0)
						intent = INTENT_HARM
						if(AH)
							if(AH.range <= 1)
								target:objFunction(src,AH)
							else
								AH.onUsed(src,target)
						else
							target:objFunction(src)
				timeSinceLast = 0

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
	updateLocation()
	npcIdle()
	npcMove()
	npcCombat()
	timeSinceLast++