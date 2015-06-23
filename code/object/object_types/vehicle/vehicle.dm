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


/obj/vehicle/garbageCleanup()
	..()
	driver = null
	passengers = null


/obj/vehicle/verb/GetIn()
	set name = "Ride"
	set desc = "Ride the vehicle"
	set src in view(1)
	EnterVehicle(usr)

/obj/vehicle/proc/EnterVehicle(var/mob/user)
	if(!driver)
		messagePlayer("You start driving the [src]",user,src)
		driver = user
		driver.loc = loc
		user.mounted = src
	else
		if(driver == user)
			Eject(driver)
		else
			if(user in passengers)
				Eject(user)
			else
				Ride(user)

/obj/vehicle/proc/Ride(var/mob/who)
	messagePlayer("You start riding on the [src]",who,src)
	if(driver)
		passengers |= who
	who.loc = loc

/obj/vehicle/proc/Eject(var/mob/who)
	messagePlayer("You leave the [src]",who,src)
	if(who == driver)
		driver = null
		who.mounted = null
	passengers.Remove(who)
	who.loc = get_turf(src)

/obj/vehicle/proc/driverCheck()
	if(driver)
		if(get_dist(src,driver) > 2)
			Eject(driver)

/obj/vehicle/Move(var/newLoc)
	if(maxSteps > 0)
		--maxSteps
	if(maxSteps == 0)
		sdel(src)
	for(var/mob/m in passengers)
		m.Move(newLoc)
	..()

/obj/vehicle/proc/CanPass(var/turf/T)
	driverCheck()
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