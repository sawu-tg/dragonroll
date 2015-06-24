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
		if(ableToSpawn > 0)
			var/toSpawn = pick(spawnTypes)
			if(toSpawn)
				new toSpawn(get_turf(src))

/turf/floor/balance/evil
	name = "Hellish Tiling"
	desc = "It seems to resonate with an evil presence."
	icon_state = "cult"

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