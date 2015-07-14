/obj/structure/trap
	name = "trap"
	desc = "Traps things"
	icon = 'sprite/obj/traps.dmi'
	var/damage = 1
	var/reusable = FALSE
	var/ready = FALSE
	var/triggered = FALSE

/obj/structure/trap/New()
	..()
	icon_state = "[initial(icon_state)]0"

/obj/structure/trap/proc/trigger(var/atom/A)
	triggered = TRUE
	icon_state = "[initial(icon_state)]0"

/obj/structure/trap/Cross(var/atom/movable/A)
	if(!triggered && ready)
		trigger(A)
		return 1

/obj/structure/trap/objFunction(var/mob/user, var/obj/item/I)
	if(!I)
		messageInfo("You ready the [src]",user,src)
		ready = TRUE
		if(reusable)
			triggered = FALSE
		icon_state = "[initial(icon_state)]1"

//TRAPS

/obj/structure/trap/bear
	name = "Bear Trap"
	desc = "Snap!"
	icon_state = "beartrap"
	helpInfo = "Clicking the trap will ready it, just don't step in it afterwards!"
	reusable = TRUE
	var/retuned = FALSE

/obj/structure/trap/bear/objFunction(var/mob/user, var/obj/item/I)
	..()
	if(I)
		if(istype(I,/obj/item/weapon/tool/hammer))
			if(!retuned)
				messageInfo("You adjust the [src]'s springs.",user,src)
				retuned = TRUE
				damage = 6

/obj/structure/trap/bear/trigger(var/atom/A)
	..()
	if(istype(A,/mob/player))
		var/mob/player/P = A
		P.takeDamage(damage,DTYPE_MELEE)
		playsound(get_turf(A), 'sound/effects/snap.ogg', 50, 0)
		playsound(get_turf(A), 'sound/weapons/bladeslice.ogg', 50, 0)
		var/leg = pick("left leg", "right leg")
		var/datum/organ/O = P.findOrgan(leg)
		if(O)
			O.health -= damage*10
		P.addStatusEffect(/datum/statuseffect/stun,30)