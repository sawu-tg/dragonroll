/obj/structure/trap
	name = "trap"
	desc = "Traps things"
	icon = 'sprite/obj/traps.dmi'
	var/damage = 10
	var/reusable = FALSE
	var/ready = FALSE
	var/triggered = FALSE
	var/spawnReady = FALSE
	var/usesReadyIcon = FALSE

/obj/structure/trap/New()
	..()
	icon_state = "[initial(icon_state)]0"
	if(spawnReady)
		ready()

/obj/structure/trap/proc/trigger(var/atom/A)
	triggered = TRUE
	if(!usesReadyIcon)
		icon_state = "[initial(icon_state)]1"
		spawn(30)
			icon_state = "[initial(icon_state)]0"
	else
		icon_state = "[initial(icon_state)]0"

/obj/structure/trap/proc/ready()
	ready = TRUE
	if(reusable)
		triggered = FALSE
	if(usesReadyIcon)
		icon_state = "[initial(icon_state)]1"

/obj/structure/trap/proc/unready()
	ready = FALSE
	triggered = FALSE
	if(!usesReadyIcon)
		icon_state = "[initial(icon_state)]0"

/obj/structure/trap/Cross(var/atom/movable/A)
	if(!triggered && ready)
		trigger(A)
		return 1

/obj/structure/trap/objFunction(var/mob/user, var/obj/item/I)
	if(!I)
		if(!ready)
			messageInfo("You ready the [src]",user,src)
			ready()
		else
			messageInfo("You disable the [src]",user,src)
			unready()

//TRAPS

/obj/structure/trap/bear/spike
	name = "Spike Trap"
	desc = "Stab!"
	icon_state = "spiketrap"
	helpInfo = "Clicking the trap will ready it, just don't step in it afterwards!"
	usesReadyIcon = FALSE
	reusable = TRUE

/obj/structure/trap/bear
	name = "Bear Trap"
	desc = "Snap!"
	icon_state = "beartrap"
	helpInfo = "Clicking the trap will ready it, just don't step in it afterwards!"
	reusable = TRUE
	usesReadyIcon = TRUE
	var/retuned = FALSE

/obj/structure/trap/bear/objFunction(var/mob/user, var/obj/item/I)
	..()
	if(I)
		if(istype(I,/obj/item/weapon/tool/hammer))
			if(!retuned)
				messageInfo("You adjust the [src]'s springs.",user,src)
				retuned = TRUE
				damage = 30

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

/obj/structure/trap/grinder
	name = "Grinding Trap"
	desc = "Bzzzzzp!"
	icon_state = "grindertrap"
	helpInfo = "Clicking the trap will ready it, just don't step in it afterwards!"
	damage = 5

/obj/structure/trap/grinder/trigger(var/atom/A)
	..()
	if(istype(A,/mob/player))
		var/mob/player/P = A
		playsound(get_turf(A), 'sound/machines/juicer.ogg', 50, 0)
		for(var/I = 0; I < 7; ++I)
			spawn(I*5)
				if(get_turf(P) == get_turf(src))
					P.takeDamage(damage,DTYPE_MELEE)
				playsound(get_turf(A), 'sound/weapons/bladeslice.ogg', 50, 0)
		P.addStatusEffect(/datum/statuseffect/stun,30)

/obj/structure/trap/acid
	name = "Acid Trap"
	desc = "Kshhh!"
	icon_state = "acidtrap"
	helpInfo = "Clicking the trap will ready it, just don't step in it afterwards!"
	damage = 5

/obj/structure/trap/acid/trigger(var/atom/A)
	..()
	if(istype(A,/mob/player))
		var/mob/player/P = A
		playsound(get_turf(A), 'sound/effects/smoke.ogg', 50, 0)
		P.addStatusEffect(/datum/statuseffect/poison,30)