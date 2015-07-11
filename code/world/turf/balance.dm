///
// Balance Turfs
///

/turf/floor/balance
	name = "magical floor"
	desc = "where did this come from?"
	turfCreeps = TRUE

/turf/wall/balance
	name = "magical wall"
	desc = "where did this come from?"

/obj/structure/balance
	name = "balance structure"
	desc = "balances things"
	icon = 'sprite/world/stationobjs.dmi'

///
// EVIL
///

///
// The "Boatman"
///

/obj/structure/angelod
	name = "Unidentified figure"
	desc = "It flits in and out of your vision much like a gnat."
	icon = 'sprite/mob/boss.dmi'
	icon_state = "death"
	var/mob/player/target
	var/stage = 0
	var/stageTimer = 45

/obj/structure/angelod/New(var/turf/T, var/totarget)
	if(!totarget)
		sdel(src)
	..(T)
	target = totarget
	addProcessingObject(src)

/obj/structure/angelod/doProcess()
	if(!Adjacent(target))
		src.loc = get_turf(target)
	else
		if(stageTimer > 0)
			--stageTimer
		else
			var/isDeath = target.alignment == ALIGN_GOOD
			stageTimer = initial(stageTimer)
			++stage
			switch(stage)
				if(1)
					var/list/greetings = list("Taken before your time,", "Lost before you had lived,", "Torn from this world,","Stolen away from those who need you,")
					var/brought = isDeath ? "I bring your end..." : "I bring comfort..."
					messagePlayer("[pick(greetings)] [target.name], [brought]", target, src,COL_HOSTILE)
				if(2)
					var/toway = isDeath ? "Your time has passed," : "Your time is not yet up,"
					messagePlayer("[toway] [target.name]", target, src,COL_HOSTILE)
				if(3)
					var/toway = isDeath ? "Leave," : "Rise,"
					messagePlayer("[toway] [target.name]", target, src,COL_HOSTILE)
					if(isDeath)
						var/P = locate(/obj/structure/balance/evilportal) in range(src,16)
						if(P)
							var/turf/T = get_turf(P)
							target.throw_at(T)
							spawn(5)
								messagePlayer("You tumble through the portal into a dark horizon...",target,src,COL_HOSTILE)
								target.z = 2
								target.revive()
					else
						target.revive()
					target.beingRezzed = FALSE
					spawn(10)
						target.addStatusEffect(/datum/statuseffect/regenerate,100)
					sdel(src)


///END

/obj/structure/balance/evilportal
	name = "Hellish Portal"
	desc = "Licks of flame and magma flit in and out of the portal."
	icon_state = "portal1"
	density = 0
	var/ableToSpawn = 8
	var/spawnRate = 120
	var/list/spawnTypes = list(/mob/player/npc/animal/wasp,/mob/player/npc/animal/spider)

/obj/structure/balance/evilportal/New()
	..()
	addProcessingObject(src)

/obj/structure/balance/evilportal/doProcess()
	if(spawnRate > 0)
		if(prob(1))
			ableToSpawn++
		--spawnRate
	else
		spawnRate = initial(spawnRate)
		for(var/mob/player/M in range(src,8))
			if(M.checkEffectStack("dying") > 0 || M.checkEffectStack("dead") > 0)
				if(!M.beingRezzed)
					new/obj/structure/angelod(get_turf(src),M)
				M.beingRezzed = TRUE
		if(ableToSpawn > 0)
			var/toSpawn = pick(spawnTypes)
			if(toSpawn)
				new toSpawn(get_turf(src))

/turf/floor/balance/evil
	name = "Hellish Tiling"
	desc = "It seems to resonate with an evil presence."
	icon_state = "cult"

/turf/floor/balance/evil/flesh
	name = "Fleshy mass"
	desc = "Reminds you of minced meat.."
	icon_state = "flesh"

/turf/floor/balance/evil/flesh/New()
	..()
	icon_state = "flesh[rand(1,5)]"

/turf/floor/balance/evil/New()
	..()
	balance.actsEvil += src
	var/foundIn = FALSE
	for(var/obj/interact/A in src)
		sdel(A)
		foundIn = TRUE
	if(foundIn)
		if(prob(15))
			new/obj/structure/balance/evilportal(get_turf(src))
		else
			new/turf/wall/balance/evil(get_turf(src))

/turf/wall/balance/evil
	name = "Hellish Wall"
	desc = "Every time it passes your peripheral vision, it seems to wiggle slightly."
	icon_state = "cult0"
	mineral = "cult"
	walltype = "cult"

/turf/wall/balance/evil/New()
	..()
	balance.actsEvil += src

///
// GOOD
///
/turf/floor/balance/good
	name = "Pristine Tiling"
	desc = "It seems to resonate with an godly presence."
	icon_state = "gold"

/turf/floor/balance/good/New()
	..()
	balance.actsGood += src
	var/foundIn = FALSE
	for(var/obj/interact/A in src)
		sdel(A)
		foundIn = TRUE
	if(foundIn)
		if(prob(15))
			new/obj/structure/balance/goodportal(get_turf(src))
		else
			new/turf/wall/balance/good(get_turf(src))

/turf/wall/balance/good
	name = "Pristine Wall"
	desc = "The surface seems impossible smooth, with no imperfections to speak of."
	icon_state = "gold0"
	mineral = "gold"
	walltype = "gold"

/turf/wall/balance/good/New()
	..()
	balance.actsGood += src

/obj/structure/balance/goodportal
	name = "Pristine Portal"
	desc = "A faint whistling sound is leaking from the portal."
	icon_state = "portal"
	density = 0
	var/datum/ability/portalSpell = new/datum/ability/taunt
	var/spawnRate = 25

/obj/structure/balance/goodportal/New()
	..()
	addProcessingObject(src)

/obj/structure/balance/goodportal/doProcess()
	if(spawnRate > 0)
		--spawnRate
	else
		spawnRate = initial(spawnRate)
		for(var/mob/player/M in range(7,src))
			spawn(1)
				if(M.alignment == ALIGN_EVIL)
					M.throw_at(src)
					spawn(1)
						if(M.checkEffectStack("dead") && !M.client)
							sdel(M)
						else
							M.takeDamage(5,DTYPE_DIRECT)