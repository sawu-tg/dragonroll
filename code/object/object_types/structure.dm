/obj/structure
	name = "default structure"
	desc = "probably in the way"
	anchored = 1
	density = 1

/obj/structure/door
	name = "door"
	icon = 'sprite/obj/doors/mineral_doors.dmi'
	icon_state = "wood"
	density = 1
	opacity = 1

	var/base_state = "wood"

	var/doorToggleTime = 5 //must be equal to animation time of door sprite
	var/doorOpenTime = 60
	var/doorCounter = 0

	var/toggling = 0
	var/open = 0
	var/is_glassdoor = 0

/obj/structure/door/proc/open()
	icon_state = "[base_state]open"
	flick("[base_state]opening",src)
	toggling = 1

	spawn(doorToggleTime)
		opacity = 0
		density = 0
		toggling = 0
		open = 1
		doorCounter = doorOpenTime
		addProcessingObject(src)

/obj/structure/door/proc/close()
	icon_state = "[base_state]"
	flick("[base_state]closing",src)
	toggling = 1
	remProcessingObject(src)

	spawn(doorToggleTime)
		opacity = !is_glassdoor
		density = 1
		toggling = 0
		open = 0

/obj/structure/door/doProcess()
	if(doorCounter > 0)
		doorCounter--
		if(doorCounter == 0 && !toggling)
			close()
			//flick("[base_state]closing",src)
			//toggling = 1
			//spawn(10)
			//	icon_state = "[base_state]"
			//	density = 1
			//	toggling = 0

/obj/structure/door/Cross(atom/Obstacle)
	if(!open && !toggling)
		open()

	if(open)
		return ..()

/obj/structure/door/old
	icon_state = "oldwood"
	base_state = "oldwood"
	doorToggleTime = 10