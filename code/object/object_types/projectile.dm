/obj/projectile
	name = "projectile"
	desc = "generic projectile"
	icon = 'sprite/obj/projectiles.dmi'
	layer = LAYER_DEFAULT
	density = 0
	var/spinning = FALSE
	var/projectileLight
	var/detRange = 0
	var/projSpeed = 1
	var/guided = FALSE
	var/atom/target
	var/damage = 1
	var/effectLength = 0
	var/effect
	var/lastProjMove = 0
	var/hit = FALSE
	var/mob/player/projectileOwner

/obj/projectile/New(var/atom/at,var/mob/owner,var/doesSpin)
	if(guided)
		target = at
	else
		target = at.loc
	if(projectileLight)
		set_light(3,2,projectileLight)
		..()
	projectileOwner = owner
	if(doesSpin)
		spinning = TRUE
	addProcessingObject(src)

/obj/projectile/garbageCleanup()
	..()
	target = null
	projectileOwner = null
	remProcessingObject(src)

/obj/projectile/proc/doProjAct(var/atom/what)
	if(!hit)
		if(istype(what,/mob/player))
			var/mob/player/P = what
			if(effect)
				P.addStatusEffect(effect,effectLength)
			if(damage > 0)
				P.healDamage(damage)
			else
				P.takeDamage(damage,DTYPE_MAGIC)
			hit = TRUE
	sdel(src)

/obj/projectile/Bump(var/atom/a)
	doProjAct(a)
	..()

/obj/projectile/Cross(var/atom/a)
	doProjAct(a)
	..()

/obj/projectile/Move()
	if(world.time < lastProjMove)
		return
	else
		lastProjMove = world.time + projSpeed
		return ..()

/obj/projectile/doProcess()
	..()
	if(!(target in range(detRange,src)))
		if(spinning)
			SpinAnimation(5,1)
		Move(get_step_to(src,target))
	else
		var/hit = FALSE
		for(var/a in loc)
			if(istype(a,/mob/player))
				doProjAct(a)
				hit = TRUE
		if(!hit)
			sdel(src)

//projectiles

/obj/projectile/manablast
	name = "Mana blast"
	desc = "Goodness gracious, great blasts of mana!"
	icon_state = "heavylaser"
	projectileLight = "#FF5500"

/obj/projectile/healingblast
	name = "Healing blast"
	desc = "Delicious heals!"
	icon_state = "magicm"
	projectileLight = "#66FFFF"

/obj/projectile/toxinthrow
	name = "Toxin"
	desc = "Does many things, but making you feel better is not one."
	icon_state = "neurotoxin"
	projectileLight = "#00CC00"

/obj/projectile/toxinthrow/gore
	name = "Gore"
	icon_state = "gore"

/obj/projectile/spear
	name = "Spear"
	desc = "Be very worried."
	icon_state = "spear"
	guided = TRUE

/obj/projectile/spear/doProjAct(var/atom/what)
	if(what == target)
		var/atom/movable/AM = what
		if(AM)
			loc = AM.loc
			if(do_roll(1,20,projectileOwner.playerData.str.statCurr) >= AM.weight + AM.size)
				AM.throw_at(projectileOwner)
				projectileOwner.Beam(AM,time=15,icon_state="c_beam")
	..()

/obj/projectile/arrow
	name = "Arrow"
	desc = "Be very worried."
	icon_state = "arrow"