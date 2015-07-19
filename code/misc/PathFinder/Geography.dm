///////////////
// Geography //
///////////////
/***
Deadron's Geography library.

These are geography-related functions I use frequently.

Copyright (c) 1999, 2000, 2001, 2002 Ronald J. Hayden. All rights reserved.


atom/proc/dd_area()
	Returns the area for the object or mob, or null if the object is at the
	null location.

dd_direction_name(direction)
	This returns a text name for direction.
	For example, if direction is NORTH, this returns "NORTH".

dd_get_dist(first, second)
	Returns the distance between two objects.
	Objects can be anything with x and y variables.
	Originally provided due to a problem with the BYOND-provided function
	failing with large distances. That problem may have been fixed,
	so I may eventually remove this.

dd_get_step(object, direction)
	Returns the turf in the specified direction (NORTH, SOUTHWEST, etc) from the object.
	Accepts any object with x, y, z variables defining its location.
	Provided because the BYOND get_step() function only takes obj or mob as an argument.

dd_get_step_rand(object, considerDensity, randomness)
	Returns a random valid turf one step away from the object
	(anything with x and y variables), or null if it can't find any valid turfs.

	considerDensity specifies whether to check for dense obstacles before choosing a turf.
	A value of 1 checks for density, while 0 does not. By default the density is checked.

	randomness determines the percentage chance that the step will be random instead of
	continuing in the direction the object was already moving. By default the randomness
	is 10, which means that 90% of the time the move will be in the same direction the
	object was already facting, and 10% of the time it will be random. This setting only
	applies to non-turf objects. If a turf is passed as the object, then the result will
	always be completely random.

dd_reverse_direction(direction)
	This returns whatever direction is opposite of direction. For example, if direction
	is NORTH, dd_reverse_direction() returns SOUTH.

dd_step_rand(M, randomness)
	Moves the object one step, returning 1 on success or null on failure.

	randomness is the percentage chance that the object will move in a random direction
	instead of continuing in the direction it was already facing; it defaults to 10.
***/

atom/proc/dd_area()
	var/atom/possible_area = loc
	if (!possible_area)
		// Either this is an area itself or an obj/mob at null loc.
		if (istype(src, /area))
			return src
		return null

	while (!istype(possible_area, /area))
		possible_area = possible_area.loc
	return possible_area


proc/dd_direction_name(direction)
	switch(direction)
		if (NORTH) return "NORTH"
		if (WEST)  return "WEST"
		if (EAST)  return "EAST"
		if (SOUTH) return "SOUTH"
		if (NORTHWEST) return "NORTHWEST"
		if (NORTHEAST) return "NORTHEAST"
		if (SOUTHWEST) return "SOUTHWEST"
		if (SOUTHEAST) return "SOUTHEAST"

proc/dd_get_dist(first, second)
	// Right triangle rule: A squared + B squared = C squared.
	var/x = abs(first:x - second:x)
	var/y = abs(first:y - second:y)
	return round(sqrt((x * x) + (y * y)))

proc/dd_get_step(O, direction)
	var/x = O:x
	var/y = O:y
	var/z = O:z
	var/newX = x
	var/newY = y
	switch (direction)
		if (NORTHWEST)
			newX = x - 1
			newY = y + 1
		if (NORTH)
			newY = y + 1
		if (NORTHEAST)
			newX = x + 1
			newY = y + 1
		if (WEST)
			newX = x - 1
		if (EAST)
			newX = x + 1
		if (SOUTHWEST)
			newX = x - 1
			newY = y - 1
		if (SOUTH)
			newY = y - 1
		if (SOUTHEAST)
			newX = x + 1
			newY = y - 1
	return locate(newX, newY, z)

proc/dd_get_step_rand(O, considerDensity = 1, randomness = 10)
	var/turf/newLoc
	var/direction
	var/isTurf = istype(O, /turf)

	// Are we being random or predictable this time?
	// Turfs are always random.
	if (isTurf || prob(randomness))
		// Try a random direction.
		direction = pick(NORTHWEST, NORTH, NORTHEAST, WEST, EAST, SOUTHWEST, SOUTH, SOUTHEAST)
		newLoc = dd_get_step(O, direction)

		if (newLoc)
			if (isTurf || newLoc.Enter(O))
				return newLoc
	else
		// We're not being random, so just move in same direction if possible.
		direction = O:dir
		newLoc = dd_get_step(O, direction)
		// If the location exists, we're done.
		if (newLoc)
			if (newLoc.Enter(O))
				return newLoc

	// That didn't work, so rotate around from here until we find a valid spot.
	var/count
	for (count = 0, count < 7, count++)
		switch (direction)
			if (NORTH)     { direction = NORTHEAST }
			if (NORTHEAST) { direction = EAST }
			if (EAST)      { direction = SOUTHEAST }
			if (SOUTHEAST) { direction = SOUTH }
			if (SOUTH)     { direction = SOUTHWEST }
			if (SOUTHWEST) { direction = WEST }
			if (WEST)      { direction = NORTHWEST }
			if (NORTHWEST) { direction = NORTH }
		newLoc = dd_get_step(O, direction)
		if (newLoc)
			if (isTurf || newLoc.Enter(O))
				return newLoc

	// No valid spots.
	return null

proc/dd_reverse_direction(direction)
	switch(direction)
		if (NORTH) return SOUTH
		if (WEST)  return EAST
		if (EAST)  return WEST
		if (SOUTH) return NORTH
		if (NORTHWEST) return SOUTHEAST
		if (NORTHEAST) return SOUTHWEST
		if (SOUTHWEST) return NORTHEAST
		if (SOUTHEAST) return NORTHWEST

proc/dd_step_rand(M, randomness = 10)
	var/considerDensity = 1
	var/turf/newLoc = dd_get_step_rand(M, considerDensity, randomness)
	if (newLoc)
		return M:Move(newLoc)
	return null



