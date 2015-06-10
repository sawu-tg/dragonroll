/obj/item/buildable/turf/trainpart
	name = "train parts"
	desc = "The best. Made by the best for the best."
	icon = 'sprite/obj/train.dmi'
	icon_state = "chassis_construct"
	ofType = /obj/train

/obj/item/buildable/train/build(var/atom/targetloc)
	var/turf/T = get_turf(targetloc)

	if(!ofType || !T) return 0

	new ofType(T)

	return 1

/obj/item/buildable/train/wheel
	name = "wheel parts"
	desc = "We have reinvented it again."
	icon = 'sprite/obj/train.dmi'
	icon_state = "wheel_construct"
	ofType = /obj/train/wheel
	canBuildOn = list(/obj/train)
	canNotBuildOn = list(/obj/train/wall,/obj/train/wheel,/obj/train/floor,/obj/train/train_control)

/obj/item/buildable/train/floor
	name = "wooden platform"
	desc = "Vintage."
	icon = 'sprite/obj/items.dmi'
	icon_state = "tile-wood"
	ofType = /obj/train/floor
	canBuildOn = list(/obj/train)
	canNotBuildOn = list(/obj/train/wall,/obj/train/floor,/obj/train/train_control)

/obj/item/buildable/train/floor/metal
	name = "metal platform"
	desc = "Industrial."
	icon = 'sprite/obj/items.dmi'
	icon_state = "tile"
	ofType = /obj/train/floor/metal

/obj/item/buildable/train/wall
	name = "wooden container wall"
	desc = "Vintage and sturdy."
	icon = 'sprite/obj/items.dmi'
	icon_state = "wood_tableparts"
	ofType = /obj/train/wall
	canBuildOn = list(/obj/train)
	canNotBuildOn = list(/obj/train/wall,/obj/train/train_control)

/obj/item/buildable/train/control
	name = "controller box"
	desc = "This looks important."
	icon = 'sprite/obj/train.dmi'
	icon_state = "control_construct"
	ofType = /obj/train/train_control
	canBuildOn = list(/obj/train/wall)
