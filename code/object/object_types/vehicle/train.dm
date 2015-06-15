//////////////////////////////////////////////////////////////////////////
//   _______  __   __  __   __    ___      __   __  _______  _______
//  |   _   ||  | |  ||  | |  |  |   |    |  |_|  ||   _   ||       |
//  |  |_|  ||  |_|  ||  |_|  |  |   |    |       ||  |_|  ||   _   |
//  |       ||       ||       |  |   |    |       ||       ||  | |  |
//  |       ||_     _||_     _|  |   |___ |       ||       ||  |_|  |
//  |   _   |  |   |    |   |    |       || ||_|| ||   _   ||       |
//  |__| |__|  |___|    |___|    |_______||_|   |_||__| |__||_______|
//
//////////////////////////////////////////////////////////////////////////

#define REGULAR_SPEED 100

/obj/structure/rail
	name = "rail"
	desc = "A rail for trains to go on."
	icon = 'sprite/obj/train.dmi'
	icon_state = "rail15"
	layer = TURF_LAYER+0.15

	density = 0
	opacity = 0
	anchored = 1

	var/odir = 15

/obj/structure/rail/New()
	connect_from_iconstate()

/obj/structure/rail/proc/connect_from_iconstate()
		var/num = text2num(copytext(icon_state,5))

		set_connect(num)

/obj/structure/rail/proc/set_connect(var/ndir)
		odir = ndir
		icon_state = "rail[odir]"

//Accepts wire input
/obj/structure/rail/soulsteel
	name = "soulsteel rail"
	color = "#AA77AA"
	var/datum/wiremodule/wires

/obj/structure/rail/soulsteel/New()
	..()

	wires = new(src, 6)
	wires.add_input("North")
	wires.add_input("South")
	wires.add_input("East")
	wires.add_input("West")

/obj/structure/rail/soulsteel/receive_wiresignal(input,signal,is_pulse)
	var/ndir = wires.receive_wiresignal("North") ? NORTH : 0
	ndir |= wires.receive_wiresignal("South") ? SOUTH : 0
	ndir |= wires.receive_wiresignal("East") ? EAST : 0
	ndir |= wires.receive_wiresignal("West") ? WEST : 0

	set_connect(ndir)

/obj/structure/rail/soulsteel/objFunction(var/mob/user,var/obj/item/with)
	if(istype(with,/obj/item/powerdevice/wiretool))
		var/obj/item/powerdevice/wiretool/WT = with
		WT.default_wire_action(user,wires)

/obj/train
	name = "metal chassis"
	desc = "choo choo"
	icon = 'sprite/obj/train.dmi'
	icon_state = "chassis"
	layer = TURF_LAYER+0.3

	weight = 5000 //Stop no don't lift this you fuck
	anchored = 1

	opacity = 0
	density = 0

	var/obj/train/train_control/controller

	Del()
		..()

		controller.break_train()

/obj/train/floor
	name = "wooden floor"
	desc = "choo choo"
	icon = 'sprite/world/floors.dmi'
	icon_state = "wood"
	layer = TURF_LAYER+0.4

/obj/train/floor/metal
	name = "metal floor"
	desc = "choo choo"
	icon = 'sprite/world/floors.dmi'
	icon_state = "floor"

/obj/train/wheel
	name = "wheel"
	desc = "choo choo"
	icon = 'sprite/obj/train.dmi'
	icon_state = "wheel0"
	layer = TURF_LAYER+0.35

/obj/train/wall
	name = "wooden wall"
	desc = "choo choo"
	icon = 'sprite/world/walls.dmi'
	icon_state = "wood0"
	layer = TURF_LAYER+0.45
	density = 1
	opacity = 1

/obj/train/train_control
	name = "train controller"
	desc = "choo choo"
	icon = 'sprite/obj/train.dmi'
	icon_state = "control"
	layer = OBJ_LAYER-0.1

	var/list/train_walls = list()
	var/list/train_floors = list()
	var/list/train_wheels = list()

	var/list/controllers = list()

	var/list/train = list()
	var/list/stored_anchor = list()

	var/list/collisions = list()

	var/speed = 0
	var/currspeed = 0
	var/maxspeed = 100

	var/movedir = 1
	var/steerdir = 0

	var/broken = 0

	var/list/blacklist = list(/obj/structure/rail,/atom/movable/lighting_overlay)
	var/list/ancwhitelist = list(/obj/train,/obj/structure/lightswitch,/obj/structure/door)

	var/datum/wiremodule/wires

	New()
		spawn(10)
			init_train()
			update_train()
			addProcessingObject(src)

			set_light(5,3,"#FF3333")

		wires = new(src, 6)
		wires.add_input("Speed")

	receive_wiresignal(input,signal,is_pulse)
		speed = wires.receive_wiresignal("Speed")

	objFunction(var/mob/user,var/obj/item/with)
		if(istype(with,/obj/item/powerdevice/wiretool))
			var/obj/item/powerdevice/wiretool/WT = with
			WT.default_wire_action(user,wires)
		else if(!broken)
			init_train()
			update_train()

	doProcess()
		if(broken) return

		currspeed += speed

		var/list/possibledirs = list(movedir, turn(movedir,90), turn(movedir,-90), turn(movedir,180))

		if(steerdir)
			possibledirs.Insert(1,steerdir)

		while(currspeed > REGULAR_SPEED)
			update_train()
			gen_collisions()

			for(var/cdir in possibledirs)
				if(cdir in collisions)
					continue

				move_train(cdir)
				movedir = cdir
				break

			currspeed -= REGULAR_SPEED

	proc/init_train()
		var/list/components = FloodFill(src,/proc/adjacent_trainsegments)

		train_floors.Cut()
		train_walls.Cut()
		train_wheels.Cut()

		for(var/obj/train/TR in components)
			if(istype(TR,/obj/train/floor))
				train_floors |= TR
			if(istype(TR,/obj/train/wall))
				train_walls |= TR
			if(istype(TR,/obj/train/wheel))
				train_wheels |= TR

	proc/update_train()
		train.Cut()

		train = train_floors | train_walls | train_wheels //Tram is everything that makes up the tram
		for(var/obj/train/OT in train)
			var/turf/T = get_turf(OT)
			for(var/atom/movable/AM in T) //Including anything inside of it
				if(AM in train)	continue
				if(!check_validity(AM))	continue
				train |= AM

		train |= src

	proc/break_train()
		if(broken)
			return

		broken = 1

		spawn(30)
			init_train()
			update_train()
			broken = 0

	proc/check_validity(var/atom/movable/AM)
		if(!AM)	return 0
		if(is_type_in_list(AM, blacklist))	return 0
		if(AM.anchored)
			if(is_type_in_list(AM, ancwhitelist))
				return 1
			return 0
		return 1


	proc/gen_collisions()
		collisions.Cut()

		for(var/obj/train/W in train_walls + train_floors)
			for(var/cdir in cardinal)
				var/turf/T = get_step(W, cdir)
				if(istype(T))
					if(T.density)
						collisions |= cdir
					if(!T.density)
						for(var/atom/movable/A in T)
							if(A.density || istype(A,/obj/train))
								if(train.Find(A))	continue
								collisions |= cdir



		for(var/cdir in cardinal)
			var/wheels = 0

			for(var/obj/train/wheel/W in train_wheels)

				var/obj/structure/rail/R = locate() in W.loc

				if(!istype(R))
					continue
				else
					flick("wheel1",W)

				wheels++

				if(!(R.odir & cdir))
					//world << "trying [R.odir] against [cdir]"
					collisions |= cdir

			if(wheels < 2)
				collisions |= cdir


	proc/move_train(var/dir)
		for(var/atom/movable/A in train)
			var/turf/T = get_step(A,dir)
			A.loc = T //THIS IS HACKY AS FUCK
			if(A.light_range)
				A.set_light()

proc/adjacent_trainsegments(var/obj/train/T)
	. = list()

	for(var/obj/train/TR in orange(T,1))
		if(TR.controller && TR.controller == T.controller)
			continue

		. |= TR