/obj/projectile
	name = "projectile"
	desc = "generic projectile"
	icon = 'sprite/obj/effects.dmi'
	layer = LAYER_DEFAULT
	density = 1
	var/detRange = 1
	var/projSpeed = 0.25
	var/guided = FALSE
	var/atom/target
	var/damage = 1
	var/effect = 0

/obj/projectile/New(var/atom/at)
	if(guided)
		target = at
	else
		target = at.loc
	addProcessingObject(src)

/obj/projectile/proc/doProjAct(var/atom/what)
	if(istype(what,/mob/player))
		var/mob/player/P = what
		mobAddFlag(P,ACTIVE_STATE_DAZED,damage,TRUE)
		P.playerData.hp.change(damage)
	del(src)

/obj/projectile/Bump(var/atom/what)
	..()
	doProjAct(what)

/obj/projectile/Cross(var/atom/what)
	..()
	doProjAct(what)

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

	New()
		set_light(3,2,"#FF5500")
		..()

/obj/projectile/healingblast
	name = "Healing blast"
	desc = "Delicious heals!"
	icon = 'sprite/obj/projectiles.dmi'
	icon_state = "ion"

	New()
		set_light(3,2,"#FF5500")
		..()
