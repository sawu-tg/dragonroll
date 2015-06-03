/mob/player/npc
	name = "NPC player"

	var/forceRace

	var/timeSinceLast = 0

	var/wander = TRUE
	var/wanderFuzziness = 15 // how high "timeSinceLast" should reach before wandering again
	var/wanderRange = 2

	var/npcMaxWait = 5 //maximum time to wait in certain actions, before reverting to idle

	var/npcState = NPCSTATE_IDLE
	var/npcNature = NPCTYPE_PASSIVE

	speed = 4

	var/target
	var/turf/lastPos
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
		walk_to(src,walkTarget,2,speed)

/mob/player/npc/proc/checkTimeout()
	if(timeSinceLast >= npcMaxWait)
		changeState(NPCSTATE_IDLE)
		target = null
		timeSinceLast = 0

/mob/player/npc/proc/changeState(var/state)
	npcState = state

/mob/player/npc/doProcess()
	..()
	if(isDisabled())
		return
	if(lastPos != loc)
		inView = oview(src,wanderRange)
		inRange = orange(src,wanderRange)
		lastPos = loc
	if(npcState == NPCSTATE_IDLE)
		if(wander && timeSinceLast >= wanderFuzziness)
			if(inView.len)
				target = pick(inView)
				changeState(NPCSTATE_MOVE)
				timeSinceLast = 0
	if(npcState == NPCSTATE_MOVE)
		MoveTo(target)
		checkTimeout()
	timeSinceLast++