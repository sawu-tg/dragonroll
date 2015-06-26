/mob/player/npc/boss
	name = "boss"
	desc = "grrr"
	icon_state = ""
	icon = 'sprite/mob/boss.dmi'
	forceRace = /datum/race/Boss
	var/bossLevel = 2 // how many * normal the stats are
	isMonster = TRUE
	npcNature = NPCTYPE_AGGRESSIVE
	alignment = ALIGN_EVIL

/mob/player/npc/boss/New()
	actualIconState = icon_state
	..()
	spawn(10)
		for(var/datum/stat/S in playerData.playerStats)
			S.setBaseTo(S.statModified * bossLevel)
			S.change(S.statModified)
		recalculateBaseStats()
		recalculateStats()
	mobFaction = new/datum/faction/generic_hostile
	popup("<b>[name]</b>",COL_HOSTILE,tsize=16,fadetime=0)

/obj/structure/floater
	name = "test"
	desc = "desc"
	icon = 'sprite/obj/projectiles.dmi'
	density = 0
	anchored = 0
	var/movtarget
	var/rotspeed = 30
	var/stage = 0
	var/maxStage = 6
	var/diesOnTarget = FALSE
	var/reversing = FALSE

proc/lerp(A, B, C) return A + (B - A) * C

/mob/verb/spawnFloaters()
	set name = "Spawn Floaties"
	var/target = input("What?") as null|anything in range(usr,8)
	if(target)
		for(var/a = 0; a < 16; ++a)
			spawn(1)
				var/obj/structure/floater/B = new/obj/structure/floater(get_turf(src))
				B.movtarget = target
				B.diesOnTarget = TRUE

/obj/structure/floater/New()
	..()
	icon_state = "[pick("red","blue","green","purple")]_laser"
	addProcessingObject(src)

/obj/structure/floater/doProcess()
	if(movtarget)
		step_towards(src,get_turf(movtarget),1)
	if(diesOnTarget)
		if(get_dist(get_turf(src),get_turf(movtarget)) <= 1)
			sdel(src)
	pixel_x = lerp(pixel_x,sin(world.time*rotspeed)*(16*stage),0.25)
	pixel_y = lerp(pixel_y,cos(-(world.time*rotspeed))*(16*stage),0.25)
	if(stage <= maxStage)
		if(reversing)
			--stage
		else
			++stage
	if(stage >= maxStage || stage < 0)
		reversing = !reversing

///
// Or'otsk, the shadow of Death
///
/mob/player/npc/boss/orotsk
	name = "Or'otsk, the Shadow of Death"
	desc = "He pulses with a dark aura, which seems to leech the very life of it's surroundings"
	icon_state = "death"
	npcSpells = list(/datum/ability/deathbeam,/datum/ability/toxicthrow,/datum/ability/slowbolt)