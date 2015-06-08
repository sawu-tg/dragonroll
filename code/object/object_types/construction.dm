///
// Construction Parts
///

/obj/item/buildable
	name = "buildable"
	icon = 'sprite/obj/items.dmi'
	desc = "makes things"
	//anchored = 1
	var/ofType
	var/list/canBuildOn = list()
	var/list/requiredTools = list()

/obj/item/buildable/objFunction(var/mob/user)
	world << "using [src]"

	if(loc != user)
		return

	var/attempt = buildAt(user)

	if(!attempt)
		attempt = buildAt(get_turf(user))

	if(attempt)
		del(src)

	..()

/obj/item/buildable/onUsed(var/mob/user,var/atom/onWhat)
	world << "using [src] on [onWhat]"

	var/attempt = buildAt(onWhat)

	if(!attempt)
		attempt = buildAt(get_turf(onWhat))

	if(attempt)
		del(src)

/obj/item/buildable/proc/buildAt(var/atom/targetloc)
	if(!targetloc || !is_type_in_list(targetloc, canBuildOn))
		return

	return build(targetloc)

/obj/item/buildable/proc/build(var/atom/targetloc)
	return 0

/obj/item/buildable/turf/build(var/atom/targetloc)
	new ofType(targetloc)

	return 1

/obj/item/buildable/turf/woodenWall
	name = "wooden wall parts"
	desc = "It would keep things out if you actually built it."
	icon_state = "wood_tableparts"
	ofType = /turf/wall/woodWall
	canBuildOn = list(/turf)

/obj/item/buildable/turf/woodenDoor
	name = "wooden door parts"
	desc = "It would keep things out if you actually built it."
	icon_state = "wood_tableparts"
	ofType = /obj/structure/door
	canBuildOn = list(/turf,/obj/train)