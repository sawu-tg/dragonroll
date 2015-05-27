/obj/projectile
	name = "projectile"
	desc = "generic projectile"
	icon = 'sprite/obj/effects.dmi'
	layer = LAYER_DEFAULT
	density = 1
	var/projectileLight
	var/detRange = 1
	var/projSpeed = 0.25
	var/guided = FALSE
	var/atom/target
	var/damage = 1
	var/effect = 0
	var/mob/player/projectileOwner

/obj/projectile/New(var/atom/at,var/mob/owner)
	if(guided)
		target = at
	else
		target = at.loc
	if(projectileLight)
		set_light(3,2,projectileLight)
		..()
	projectileOwner = owner
	addProcessingObject(src)

/obj/projectile/proc/doProjAct(var/atom/what)
	if(istype(what,/mob/player))
		var/mob/player/P = what
		mobAddFlag(P,effect,damage,TRUE)
		P.playerData.hp.change(damage)
	del(src)

/obj/projectile/doProcess()
	..()
	if(!(target in range(detRange,src)))
		step_to(src,target,0,projSpeed)
	else
		doProjAct(target)

//projectiles

/obj/projectile/manablast
	name = "Mana blast"
	desc = "Goodness gracious, great blasts of mana!"
	icon = 'sprite/obj/projectiles.dmi'
	icon_state = "heavylaser"
	projectileLight = "#FF5500"

/obj/projectile/healingblast
	name = "Healing blast"
	desc = "Delicious heals!"
	icon = 'sprite/obj/projectiles.dmi'
	icon_state = "ion"
	projectileLight = "#66FFFF"

/obj/projectile/toxinthrow
	name = "Toxin"
	desc = "Does many things, but making you feel better is not one."
	icon = 'sprite/obj/projectiles.dmi'
	icon_state = "neurotoxin"
	projectileLight = "#00CC00"

/obj/projectile/spear
	name = "Spear"
	desc = "Be very worried."
	icon = 'sprite/obj/projectiles.dmi'
	icon_state = "spear"
	guided = TRUE

/obj/projectile/spear/doProjAct(var/atom/what)
	if(what == target)
		var/atom/movable/AM = what
		if(AM)
			loc = AM.loc
			if(do_roll(1,20,projectileOwner.playerData.str.statCur) >= AM.weight + AM.size)
				AM.throw_at(projectileOwner)
				projectileOwner.Beam(AM,time=15,icon_state="c_beam")
	..()