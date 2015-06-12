/obj/item/weapon/tool/fishingrod
	name = "Fishing Rod"
	desc = "A bit of string tied around a stick."
	icon_state = "fishingrod"
	var/obj/item/bait
	var/obj/effect/fishingbouy/bouy
	range = 5

/obj/item/weapon/tool/fishingrod/onUsed(var/mob/user,var/atom/onWhat)
	if(istype(onWhat,/turf/floor/outside/liquid))
		if(bouy)
			return
		messageInfo("You cast out a line!",user,src)
		bouy = new/obj/effect/fishingbouy(get_turf(onWhat),user,bait)


/obj/effect/fishingbouy
	name = "Fishing Bouy"
	desc = "Dynamic fish attracting powers!"
	icon_state = "effect_bouy"
	length = 30
	var/mob/fisherman

/obj/effect/fishingbouy/New(var/turf/atloc,var/owner,var/bait)
	..(atloc)
	fisherman = owner
	spawn(1)
		Beam(owner,time=length,icon_state="f_beam")

/obj/effect/fishingbouy/onDestroy()
	..()
	var/A = get_turf(src)
	var/catchType = pickweight(A:fishables)
	var/catch = new catchType(get_turf(fisherman))
	messageInfo("You reel in a [catch]",fisherman,src)

/turf/floor/outside/liquid
	var/list/fishables = list(/obj/item/food/fish = 100)


///
// FISHIES GLUB GLUB
///

/obj/item/food/fish
	name = "Fish"
	desc = "Floats and glubs"
	icon = 'sprite/obj/fish.dmi'
	icon_state = "bluefish"

/obj/item/food/fish/New()
	..()
	icon_state = "[pick("blue","red","green","orange","pink","dark")]fish"