/mob/player/npc
	name = "NPC player"

	var/forceRace

	var/timeSinceLast = 0

	var/wander = 1
	var/wanderFuzziness = 125 // how high "timeSinceLast" should reach before wandering again
	var/wanderRange = 5

	var/npcMaxWait = 15 //maximum time to wait in certain actions, before reverting to idle

	var/npcState = NPCSTATE_IDLE
	var/npcNature = NPCTYPE_PASSIVE

	speed = 4

	var/target
	var/turf/lastPos
	var/list/inView = list()
	var/list/inRange = list()

	var/list/firstName = list("Steve","John","Reggie","Oswald","Daniel","Delilah","Rudy","Christine","Chad","Roma","Jessy","Mike","Gabe")
	var/list/secondName  = list("Smith","Rivers","Bombastic","Donalds","Stevens","Black","McRand","Compton","Chadswick","Hunt","Horn")

	New()
		..()
		name = "[pick(firstName)] [pick(secondName)]"
		if(forceRace)
			spawn(1)
				raceChange(forceRace,TRUE)
		nameChange(name)
		addProcessingObject(src)

/mob/player/npc/doProcess()
	..()
	if(isDisabled())
		return
	if(lastPos != loc)
		inView = oview(src,wanderRange)
		inRange = orange(1,src)
	if(npcState == NPCSTATE_IDLE)
		if(wander && timeSinceLast > wanderFuzziness)
			if(inView.len)
				target = pick(inView)
				npcState = NPCSTATE_MOVE
				timeSinceLast = 0
	if(npcState == NPCSTATE_MOVE)
		if(timeSinceLast >= npcMaxWait)
			npcState = NPCSTATE_IDLE
			target = null
		if(!(target in inRange))
			walk_to(src,target,2,speed)
			timeSinceLast = 0
		else
			target = null
			npcState = NPCSTATE_IDLE
	timeSinceLast++