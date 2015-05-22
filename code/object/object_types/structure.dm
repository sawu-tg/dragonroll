/obj/structure
	name = "default structure"
	desc = "probably in the way"
	anchored = 1
	density = 1

/obj/structure/door
	name = "door"
	icon = 'sprite/obj/doors/mineral_doors.dmi'
	icon_state = "wood"
	var/doorOpenTime = 60
	var/doorCounter = 0

/obj/structure/door/doProcess()
	if(doorCounter > 0)
		doorCounter--
		if(doorCounter == 0)
			remProcessingObject(src)
			icon_state = "[initial(icon_state)]"
			density = 1

/obj/structure/door/Cross(atom/Obstacle)
	if(doorCounter <= 0)
		addProcessingObject(src)
		icon_state = "[initial(icon_state)]open"
		density = 0
		doorCounter = doorOpenTime
		return ..()
	else
		return