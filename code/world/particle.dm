/proc/lerp(A, B, C) return A + (B - A) * C

/obj/structure/particleSystem
	name = ""
	desc = ""

	// Passed partical flags
	var/mTarget
	var/pFlags
	var/pRotSpeed
	var/pUsesStages
	var/m_pStage
	var/pTargDeath
	var/maxParticles = 32
	var/list/p_list = list()

/obj/structure/particleSystem/New(var/turf/T, var/pTarget, var/pFlag, var/pRotSp, var/pStages, var/pDoesStage, var/pTargetDeath,var/maxParts)
	..(T)
	mTarget = pTarget
	pFlags = pFlag
	pRotSpeed = pRotSp
	m_pStage = pStages
	pUsesStages = pDoesStage
	pTargDeath = pTargetDeath
	maxParticles = maxParts
	addProcessingObject(src)

/obj/structure/particleSystem/doProcess()
	if(p_list.len < maxParticles)
		spawn(0)
			var/obj/effect/particle/B = new/obj/effect/particle(get_turf(src))
			B.mTarget = mTarget
			B.pFlags = pFlags
			B.pRotSpeed = pRotSpeed
			B.m_pStage = m_pStage
			B.pUsesStages = pUsesStages
			B.deathOnTarget = pTargDeath
			B.m_pSystem = src


/obj/effect/particle
	name = ""
	desc = ""
	icon = 'sprite/obj/projectiles.dmi'
	length = 30
	fades = TRUE
	layer = LAYER_LIGHTING
	var/mTarget
	var/pFlags // defines behaviour
	var/pRotSpeed = 30
	var/pStage = 0
	var/pUsesStages = TRUE
	var/m_pStage = 6
	var/deathOnTarget = FALSE
	var/pReverse = FALSE
	var/obj/structure/particleSystem/m_pSystem

/obj/effect/particle/New()
	..()
	icon_state = "[pick("red","blue","green","purple")]_laser"
	addProcessingObject(src)

/obj/effect/particle/proc/bScatter()
	pixel_x = lerp(pixel_x,rand(-pRotSpeed,pRotSpeed)*16,0.25)
	pixel_y = lerp(pixel_y,rand(-pRotSpeed,pRotSpeed)*16,0.25)

/obj/effect/particle/proc/bWhirl()
	pixel_x = lerp(pixel_x,sin(world.time*pRotSpeed)*(16*pStage),0.25)
	pixel_y = lerp(pixel_y,cos(-(world.time*pRotSpeed))*(16*pStage),0.25)

/obj/effect/particle/proc/bFall()
	pixel_y = lerp(pixel_y,pixel_y-pRotSpeed,0.25)

/obj/effect/particle/garbageCleanup()
	remProcessingObject(src)
	m_pSystem.p_list -= src
	m_pSystem = null
	..()


/obj/effect/particle/doProcess()
	//
	if(mTarget)
		step_towards(src,mTarget,1)
	if(deathOnTarget)
		if(get_dist(get_turf(src),mTarget) <= 0)
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
		new/obj/structure/particleSystem(get_turf(src), target, flags, 30, 6, staged == "Yes" ? TRUE : FALSE, dies == "Yes" ? TRUE : FALSE,particles)