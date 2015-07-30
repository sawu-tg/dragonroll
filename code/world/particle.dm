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
	var/ofState
	var/icon/ofIcon

/obj/structure/particleSystem/New(var/turf/T, var/pTarget, var/pFlag, var/pRotSp, var/pStages, var/pDoesStage, var/pTargetDeath,var/maxParts,var/toState,var/toIcon)
	..(T)
	mTarget = pTarget
	pFlags = pFlag
	pRotSpeed = pRotSp
	m_pStage = pStages
	pUsesStages = pDoesStage
	pTargDeath = pTargetDeath
	maxParticles = maxParts
	if(toState)
		ofState = toState
	if(toIcon)
		ofIcon = toIcon
	addProcessingObject(src)

/obj/structure/particleSystem/doProcess()
	if(p_list.len < maxParticles)
		spawn(0)
			if(pFlags == PART_PHYS_EXPLODE)
				for(var/I = 1; I < round(360/maxParticles); ++I)
					var/obj/effect/particle/B = new/obj/effect/particle(get_turf(src),ofIcon,ofState)
					B.initialAngle = I*maxParticles
					B.mTarget = mTarget
					B.pFlags = pFlags
					B.pRotSpeed = pRotSpeed
					B.m_pStage = m_pStage
					B.pUsesStages = pUsesStages
					B.deathOnTarget = pTargDeath
					B.m_pSystem = src
					p_list += B
			else
				var/obj/effect/particle/B = new/obj/effect/particle(get_turf(src),ofIcon,ofState)
				B.mTarget = mTarget
				B.pFlags = pFlags
				B.pRotSpeed = pRotSpeed
				B.m_pStage = m_pStage
				B.pUsesStages = pUsesStages
				B.deathOnTarget = pTargDeath
				B.m_pSystem = src
				p_list += B


/obj/effect/particle
	name = ""
	desc = ""
	icon = 'sprite/obj/projectiles.dmi'
	length = 30
	fades = TRUE
	layer = LAYER_LIGHTING
	var/initialAngle = 0
	var/mTarget
	var/pFlags // defines behaviour
	var/pRotSpeed = 30
	var/pStage = 0
	var/pUsesStages = TRUE
	var/m_pStage = 6
	var/deathOnTarget = FALSE
	var/pReverse = FALSE
	var/obj/structure/particleSystem/m_pSystem

/obj/effect/particle/New(var/turf/T,var/asIcon,var/asState)
	..(T)
	if(asIcon)
		icon = asIcon
	if(asState)
		icon_state = asState
	if(!asIcon && !asState)
		icon_state = "[pick("red","blue","green","purple")]_laser"
	addProcessingObject(src)

/obj/effect/particle/proc/bScatter()
	animate(src, pixel_x = Lerp(pixel_x,rand(-pRotSpeed,pRotSpeed)*16,0.25), time = TICK_LAG, loop = 1)
	animate(src, pixel_y = Lerp(pixel_y,rand(-pRotSpeed,pRotSpeed)*16,0.25), time = TICK_LAG, loop = 1)

/obj/effect/particle/proc/bWhirl()
	animate(src, pixel_x = Lerp(pixel_x,sin(world.time*pRotSpeed)*(16*pStage),0.25), time = TICK_LAG, loop = 1)
	animate(src, pixel_y = Lerp(pixel_y,cos(-(world.time*pRotSpeed))*(16*pStage),0.25), time = TICK_LAG, loop = 1)

/obj/effect/particle/proc/bExplode()
	var/vel_x = sin(initialAngle) * 16
	var/vel_y = cos(initialAngle) * 16
	animate(src, pixel_x = Lerp(pixel_x,pStage * vel_x,0.25), time = TICK_LAG, loop = 1)
	animate(src, pixel_y = Lerp(pixel_y,pStage * vel_y,0.25), time = TICK_LAG, loop = 1)

/obj/effect/particle/proc/bFall()
	animate(src, pixel_y = Lerp(pixel_y,pixel_y-pRotSpeed,0.25), time = TICK_LAG, loop = 1)

/obj/effect/particle/garbageCleanup()
	remProcessingObject(src)
	animate(src,color=rgb(0,0,0,0),time=1,loop=1)
	spawn(5)
		m_pSystem.p_list -= src
		m_pSystem = null
		..()


/obj/effect/particle/doProcess()
	//
	if(mTarget)
		step_towards(src,mTarget,1)
	if(deathOnTarget)
		if(mTarget)
			if(get_dist(get_turf(src),mTarget) <= 0)
				sdel(src)
		else
			if(pStage >= m_pStage-1)
				spawn(0)
					sdel(src)
	//
	if(pFlags & PART_PHYS_SCATTER)
		bScatter()

	if(pFlags & PART_PHYS_WHIRL)
		bWhirl()

	if(pFlags & PART_PHYS_FALL)
		bFall()

	if(pFlags & PART_PHYS_EXPLODE)
		bExplode()
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

/mob/verb/MakeExplosion()
	set name = "Spawn Explosion"
	set category = "DM"
	new/obj/structure/particleSystem(get_turf(src), null, PART_PHYS_EXPLODE, 32, 16, TRUE, TRUE,16,"smoke",icon('sprite/obj/tg_effects/effects.dmi'))

/mob/verb/spawnParticles()
	set name = "Spawn Particle System"
	set category = "DM"
	var/target = input("Target?") as null|anything in range(usr,8)
	var/list/ofFlags = list("Scatter" = PART_PHYS_SCATTER,"Whirl" = PART_PHYS_WHIRL,"Fall" = PART_PHYS_FALL)
	var/flags = input("Flags?") as num|anything in ofFlags
	var/staged = input("Staged?") as null|anything in list("Yes","No")
	var/dies = input("Dies?") as null|anything in list("Yes","No")
	var/particles = input("Amount?") as num
	var/icon/ofIcon = input("Display?") as icon
	var/ofState
	if(ofIcon)
		ofState = input("State?") as null|anything in icon_states(ofIcon)
	if(particles)
		new/obj/structure/particleSystem(get_turf(src), target, ofFlags[flags], 30, 6, staged == "Yes" ? TRUE : FALSE, dies == "Yes" ? TRUE : FALSE,particles,ofState,ofIcon)