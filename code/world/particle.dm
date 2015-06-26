/proc/lerp(A, B, C) return A + (B - A) * C

/obj/structure/particle
	name = "test"
	desc = "desc"
	icon = 'sprite/obj/projectiles.dmi'
	density = 0
	anchored = 0
	var/mTarget
	var/pFlags // defines behaviour
	var/pRotSpeed = 30
	var/pStage = 0
	var/pUsesStages = TRUE
	var/m_pStage = 6
	var/deathOnTarget = FALSE
	var/pReverse = FALSE

/obj/structure/particle/New()
	..()
	icon_state = "[pick("red","blue","green","purple")]_laser"
	addProcessingObject(src)

/obj/structure/particle/proc/bScatter()
	if(pStage <= 0 && !pUsesStages)
		m_pStage = 1
	pixel_x = lerp(pixel_x,rand(-pRotSpeed/pStage,pRotSpeed/pStage)*(16*pStage),0.25)
	pixel_y = lerp(pixel_y,rand(-pRotSpeed/pStage,pRotSpeed/pStage)*(16*pStage),0.25)

/obj/structure/particle/proc/bWhirl()
	pixel_x = lerp(pixel_x,sin(world.time*pRotSpeed)*(16*pStage),0.25)
	pixel_y = lerp(pixel_y,cos(-(world.time*pRotSpeed))*(16*pStage),0.25)

/obj/structure/particle/proc/bFall()
	pixel_y = lerp(pixel_y,pixel_y-pRotSpeed,0.25)


/obj/structure/particle/doProcess()
	//
	if(mTarget)
		step_towards(src,get_turf(mTarget),1)
	if(deathOnTarget)
		if(get_dist(get_turf(src),get_turf(mTarget)) <= 1)
			sdel(src)
	//
	if(pFlags & PART_PHYS_SCATTER)
		bScatter()

	if(pFlags & PART_PHYS_WHIRL)
		bWhirl()

	if(pFlags & PART_PHYS_FALL)
		bFall()
	//
	if(pUsesStages)
		if(pStage <= m_pStage)
			if(pReverse)
				--pStage
			else
				++pStage
		if(pStage >= m_pStage || pStage < 0)
			pReverse = !pReverse


///
// PARTICLE PROCS
///

/mob/verb/spawnParticles()
	set name = "Spawn particle"
	var/target = input("Target?") as null|anything in range(usr,8)
	var/flags = input("Flags?") as num|anything in list(PART_PHYS_SCATTER,PART_PHYS_WHIRL,PART_PHYS_FALL)
	var/staged = input("Staged?") as null|anything in list("Yes","No")
	var/dies = input("Dies?") as null|anything in list("Yes","No")
	var/particles = input("Amount?") as num
	if(particles)
		for(var/a = 0; a < particles; ++a)
			spawn(1)
				var/obj/structure/particle/B = new/obj/structure/particle(get_turf(src))
				if(target)
					B.mTarget = target
				if(flags)
					B.pFlags = flags
				if(staged == "Yes")
					B.pUsesStages = TRUE
				if(dies == "Yes")
					B.deathOnTarget = TRUE