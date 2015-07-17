#include "implementation.dm"


/*
RELEASE NOTES

10/28/01:
	- Added an even better optimization that reduces the chance of paths being regenerated.
10/27/01:
	- Added optimizations to reduce the chance that paths are recreated unnecessarily.
	  Now before throwing away the existing path, the library checks to see if the new
	  destination already exists in the path, or might be just one step away.
	  This significantly reduces the CPU hit for mobs that are following each other.
*/


/////////////////////////////////////
// The one function you care about //
/////////////////////////////////////
atom/movable
	base_StepTowards(destination, minimum_distance = 0, pathSizeLimit = 10)
		/* This is the only function you will probably need to use.
		   Moves the mob one step toward the specified destination,
		   which can be any kind of object or turf on the map.

		   If the mob ends up within minimum distance of the destination,
		   returns 1, otherwise returns 0.

		   The pathSizeLimit indicates the longest path allowed. If that limit
		   is reached, the path up to that point is returned.

		   Example:

			src.base_StepTowards(my_enemy)
		*/
		return ..()







atom/movable
	base_CanEnterTurf(turf/destination)
		/* Am I able to enter this turf?
		   By default calls destination.Enter(src) for the answer.

		   Provided so this can be overridden for special circumstances,
		   like multi-turf mobs. */
		return ..()


turf
	base_AccessibleTurfs()
        /* Returns a list of the turfs accessible from this turf.
           If this function gets called, it caches the results to improve
           efficiency if called again.  However, the list returned is a unique
           copy, so you can munge it without fear of causing problems.

           If you have special features in your game like teleporters, you may
           want to override this function to indicate other turfs accessible
           from here. */
		return ..()






























BaseCamp/PathController
	StepTowards(new_dest, minimum_distance = 0, pathSizeLimit = 10)
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()

	Path(distanceLimit = 0)
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()


	_search()
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()


	_addNodeToSortedList(BaseCamp/PathNode/node)
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()


	_binarySearch(lowIndex, highIndex, total, costs)
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()

	_getSequence(BaseCamp/PathNode/n)
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()


BaseCamp/PathNode
	Total()
		/* This function is for internal use by the library.
		   You should never need to call it.

		   Use atom/movable/base_StepTowards().
		*/
		return ..()

