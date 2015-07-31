/obj/vehicle
	name = "vehicle"
	desc = "takes you places your feet cannot"
	icon = 'sprite/obj/vehicles.dmi'
	size = 3
	weight = 5
	var/maxSteps = -1
	density = 0
	var/vehicleFlags = VEHICLE_PASS_LAND
	layer = LAYER_OVERLAY
	var/mob/player/driver
	var/list/passengers = list()
	move_delay = 2 * TICK_LAG
	var/trailType
	var/trailIcon
	var/trailState
	var/hidesPlayer = FALSE
	var/locksPlayerIn = FALSE
	var/noMessage = FALSE

/obj/vehicle/garbageCleanup()
	..()
	Eject(driver)
	for(var/mob/A in passengers)
		Eject(A)
	driver = null
	passengers = null


/obj/vehicle/verb/GetIn()
	set name = "Ride"
	set desc = "Ride the vehicle"
	set src in view(1)
	EnterVehicle(usr)

/obj/vehicle/proc/EnterVehicle(var/mob/user)
	if(!driver)
		if(!noMessage)
			messagePlayer("You start controlling the [src]",user,src)
		driver = user
		driver.loc = get_turf(src)
		driver.move_delay = move_delay
		user.mounted = src
		if(hidesPlayer)
			user.invisibility++
	else
		if(driver == user)
			Eject(driver)
		else
			if(user in passengers)
				Eject(user)
			else
				Ride(user)

/obj/vehicle/proc/Ride(var/mob/who)
	if(!noMessage)
		messagePlayer("You enter the [src]",who,src)
	if(driver)
		passengers |= who
	if(hidesPlayer)
		who.invisibility++
	who.move_delay = move_delay
	who.loc = loc

/obj/vehicle/proc/Eject(var/mob/who)
	if(!who)
		return
	if(!noMessage)
		messagePlayer("You leave the [src]",who,src)
	if(who == driver)
		driver = null
		who.mounted = null
	passengers.Remove(who)
	who.loc = get_turf(src)
	who.move_delay = 4 * TICK_LAG
	if(hidesPlayer)
		who.invisibility--

/obj/vehicle/proc/driverCheck()
	if(driver)
		if(get_dist(src,driver) > 2)
			if(locksPlayerIn)
				driver.loc = get_turf(src)
			else
				Eject(driver)

/obj/vehicle/Move(var/newLoc)
	driverCheck()
	if(trailType)
		var/obj/effect/E = createEffect(get_turf(src),trailType)
		if(trailIcon && trailState)
			E.icon = trailIcon
			E.icon_state = trailState
			E.dir = dir
	if(maxSteps >= 0)
		--maxSteps
	if(maxSteps <= 0)
		Eject(driver)
		for(var/mob/A in passengers)
			Eject(A)
		invisibility = 99
		spawn(10)
			sdel(src)
	for(var/mob/m in passengers)
		m.Move(newLoc)
	..()

/obj/vehicle/proc/CanPass(var/turf/T)
	if(VEHICLE_PASS_ANY)
		return TRUE
	if(istype(T,/turf/floor/outside/liquid))
		var/turf/floor/outside/liquid/L = T
		if((vehicleFlags & VEHICLE_PASS_LIQUID_WATER) && !L.corrosive)
			return TRUE
		if((vehicleFlags & VEHICLE_PASS_LIQUID_ALL) && L.corrosive)
			return TRUE
		else
			return FALSE
	else
		if((vehicleFlags & VEHICLE_PASS_LAND))
			return TRUE
	return FALSE

///
// VEHICLES
///

/obj/vehicle/boat
	name = "boat"
	desc = "row row fight the powa"
	icon_state = "boat"
	vehicleFlags = VEHICLE_PASS_LIQUID_WATER