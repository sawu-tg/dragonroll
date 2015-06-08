///
// Construction Parts
///

/obj/item/buildable
	name = "buildable"
	icon = 'sprite/obj/items.dmi'
	desc = "makes things"
	anchored = 1
	var/ofType
	var/list/canBuildOn()

/obj/item/buildable/objFunction(var/mob/user)
	new ofType(src.loc)
	del(src)

/obj/item/buildable/woodenWall
	name = "wooden wall parts"
	desc = "It would keep things out if you actually built it."
	icon_state = "wood_tableparts"
	ofType = /turf/wall/woodWall

/obj/item/buildable/woodenDoor
	name = "wooden door parts"
	desc = "It would keep things out if you actually built it."
	icon_state = "wood_tableparts"
	ofType = /obj/structure/door