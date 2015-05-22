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

/obj/projectile/New(var/atom/at)
	if(guided)
		target = at
	else
		target = at.loc
	addProcessingObject(src)

/obj/projectile/proc/doProjAct(var/atom/what)
	if(istype(what,/mob/player))
		var/mob/player/P = what
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

/obj/projectile/fireball
	name = "Fire blast"
	desc = "Goodness gracious, great blasts of fire!"
	icon_state = "effect_projectile_fire"

	New()
		set_light(3,2,"#FF5500")

		..()

/obj/projectile/fireball/purple
	icon_state = "effect_projectile_purplefire"

/obj/projectile/fireball/blue
	icon_state = "effect_projectile_bluefire"

/obj/projectile/fireball/green
	icon_state = "effect_projectile_greenfire"
