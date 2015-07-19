// This is where the pathfinding is implemented.
// You don't need to worry about this file unless you are curious how it works.


#define DEBUGGING 0
// #define DEBUGGING 1

#define BASE_PATHNODE_LIMIT	300

atom/movable
	var/tmp
		BaseCamp/PathController/base_path	// Used by base_StepTowards() to manage pathing.

	proc
		base_StepTowards(destination, minimum_distance = 0, pathSizeLimit = 10)
			// Moves the mob one step toward the specified destination.
			// If the mob ends up within minimum distance of the destination, returns 1, otherwise returns 0.
			if (!base_path)
				base_path = new(src)
			return base_path.StepTowards(destination, minimum_distance, pathSizeLimit)

		base_CanEnterTurf(turf/destination)
			// Can I enter this turf?
			// Provided so this can be overridden for special circumstances, like multi-turf mobs.
			if (destination.Enter(src))
				return 1
			return 0

turf
	var/tmp
		list/_base_accessibleTurfs

	proc
		base_AccessibleTurfs()
            /* Returns a list of the turfs accessible from this turf.
               If this function gets called, it caches the results to improve
               efficiency if called again.  However, the list returned is a unique
               copy, so you can munge it without fear of causing problems.

               If you have special features in your game like teleporters, you may
               want to override this function to indicate other turfs accessible
               from here. */
			if (!_base_accessibleTurfs)
				_base_accessibleTurfs = new /list()

				// Get the eight surrounding turfs.
				var/turf/north     = locate(x,   y+1, z)
				var/turf/west      = locate(x-1, y,   z)
				var/turf/east      = locate(x+1, y,   z)
				var/turf/south     = locate(x,   y-1, z)
				var/turf/northwest = locate(x-1, y+1, z)
				var/turf/northeast = locate(x+1, y+1, z)
				var/turf/southwest = locate(x-1, y-1, z)
				var/turf/southeast = locate(x+1, y-1, z)

				if (north)     _base_accessibleTurfs += north
				if (west)      _base_accessibleTurfs += west
				if (east)      _base_accessibleTurfs += east
				if (south)     _base_accessibleTurfs += south
				if (northwest) _base_accessibleTurfs += northwest
				if (northeast) _base_accessibleTurfs += northeast
				if (southwest) _base_accessibleTurfs += southwest
				if (southeast) _base_accessibleTurfs += southeast
			return _base_accessibleTurfs.Copy()


BaseCamp/PathController
	// Used to handle pathing for a mob.  This object keeps movement state and is called by base_StepTowards().
	var/tmp
		atom/movable/owner
		destination
		turf/destination_turf

		list/pathList

	var/tmp
		list/openTurfs
		list/closedTurfs

		bestTotal
		newBest   						// boolean
		list/nodes						// sorted open node
		checkLimit						// How many steps out should we look before returning best known path?


	New(my_owner)
		var/result = ..()
		owner = my_owner
		return result

	proc
		StepTowards(new_dest, minimum_distance = 0, pathSizeLimit = 10)
			// Takes one step toward the destination, and returns 1 if the owner ends up within minimum_distance of the destination.
			var/current_loc = owner.loc
			var/turf/previous_destination_turf = destination_turf

			var/dest_is_turf = 0
			if (destination != new_dest)
				destination = new_dest

				if (isturf(destination))
					dest_is_turf = 1
					destination_turf = destination
				else
					destination_turf = locate(destination:x, destination:y, destination:z)
			else
				if (!dest_is_turf)
					var/new_loc = locate(destination:x, destination:y, destination:z)
					if (destination_turf != new_loc)
						destination_turf = new_loc

			/* If we have a new destination, see if we can avoid creating a whole new path.
			   There is a good chance that the new destination is an extension of our current
			   path or is already hit in our current path, if we're following someone. */
			if (length(pathList) && previous_destination_turf != destination_turf)
				var/isExistingPath = 0
				if (length(pathList))
					// Is it already in our path?
					var/turf/existing_turf
					for (existing_turf in pathList)
						if (existing_turf == destination_turf)
							isExistingPath = 1
							break

					if (!isExistingPath)
						/* Did our previous path reach its destination in the end?
						   If not, and if this new destination is near the old destination, remove last path node so
						   we reconsider end of path. */
						if (pathList[pathList.len] != previous_destination_turf)
							var/list/connected = previous_destination_turf.base_AccessibleTurfs()
							for (var/turf/connected_turf in connected)
								if (connected_turf == destination_turf)
									// Remove last item from pathList.
									pathList.Cut(pathList.len)
									isExistingPath = 1
									break

					// Is it an extension of our current path?
					// If so, to act intelligently, drop the last item from our current path
					// to avoid walking up to their last location and then moving toward them.
					if (!isExistingPath)
						// See if it's near the last turf.
						var/turf/last_turf = pathList[pathList.len]
						var/list/connected = last_turf.base_AccessibleTurfs()
						for (var/turf/connected_turf in connected)
							if (connected_turf == destination_turf)
								// Remove last item from pathList.
								pathList.Cut(pathList.len)
								isExistingPath = 1
								break

				if (!isExistingPath)
					pathList = null


			if (!length(pathList))
				pathList = Path(pathSizeLimit)

			if (!length(pathList))
				goto distance_check

			var/turf/nextstep = pathList[1]
			if (current_loc == nextstep)
				// This is where we already are -- skip to next node.
				pathList.Cut(1,2)
				if (pathList.len)
					nextstep = pathList[1]
				else
					goto distance_check

			// Take the actual step.
//			var/result = step_towards(owner, nextstep)
			// Lummox modification: If nextstep is on another level, let Move() handle.
			var/result = nextstep.z == owner.z ? step_towards(owner, nextstep) : owner.Move(nextstep)
			if (!result)
				// Give up on this path.
//				world << "[type].StepTowards() failed trying to reach [nextstep.x], [nextstep.y]." // DEBUG

				// See if I can step toward any of the turfs after this, if there are any.
				pathList.Cut(1,2)
				while (!result && length(pathList))
//					world << "[type].base_StepTowards() can't reach turf; skipping to try next turf." // DEBUG
					nextstep = pathList[1]
					result = step_towards(owner, nextstep)
					if (!result)
						pathList.Cut(1,2)

				if (!result)
					pathList = null
					return -1

			if (owner.loc == nextstep)
				// We reached our next node, so cut it from the list.
				pathList.Cut(1, 2)

			// DISTANCE_CHECK goto label -- used because several points need to run this check as last thing.
			distance_check:

			if (dd_get_dist(owner, destination_turf) <= minimum_distance)
				pathList = null
				return 1
			else
				// We haven't reached our destination yet.
				return 0

		Path(distanceLimit = 0)
			// Call Path() to kick things off.
			// Returns a list of the turfs which make up a path to the destination, or null if no path found.
			var/starting_point = owner.loc
			checkLimit = distanceLimit

			bestTotal    = 0
			newBest      = 0				// boolean
			checkLimit   = distanceLimit	// How many steps out should we look before returning best known path?

			var/BaseCamp/PathNode/solution
			var/BaseCamp/PathNode/firstPathnode
			var/BaseCamp/PathNode/parent
			var/costs = 0
			var/distanceEstimate

			openTurfs = new /list()
			closedTurfs = new /list()
			nodes = new /list()

			distanceEstimate = dd_get_dist(starting_point, destination_turf)
			firstPathnode = new(starting_point, parent, costs, distanceEstimate)

			openTurfs.Add(starting_point)
			nodes.Add(firstPathnode)

			solution = _search()

			// Get a list of the turfs in path order.
			var/list/sequence = _getSequence(solution)

			// Clean up.
			// Erase all possible object references before deletion, to speed things up.
			var/BaseCamp/PathNode/node
			var/count
			for (count = 1, count <= nodes.len, count++)
				node = nodes[count]
				nodes[count] = null
				node.Clear()
			del(nodes)

			var/turf/T
			for (T in openTurfs)
				node = T.base_pathnode
				if (node)
					node.Clear()
				T.base_pathnode = null
			del(openTurfs)

			for (T in closedTurfs)
				node = T.base_pathnode
				if (node)
					node.Clear()
				T.base_pathnode = null
			del(closedTurfs)

			// DEBUG
//			world << "[type].Path() returning path with [sequence.len] steps."
			return sequence


		_search()
			var/BaseCamp/PathNode/bestPathnode
			var/list/childTurfs
			var/childCosts

			// While there are any open nodes...
			while (nodes.len > 0)
				// Start with the first node.
				bestPathnode = nodes[1]
				var/turf/bestTurf = bestPathnode.turf

				if (DEBUGGING) { world << "\red*** Now evaluating node: turf x: [bestTurf.x] y: [bestTurf.y] costs: [bestPathnode.costs] estDistance: [bestPathnode.distance]. ***\red" }

				// If this is a closed node, remove it from the open list and stop considering it.
				var/closedCheck = closedTurfs.Find(bestPathnode.turf)
				if (closedCheck != 0)
					if (DEBUGGING) { world << "\blue      *** Node found in closed list, cutting... ***\blue" }
					nodes.Cut(1, 2)
					continue

				// If this turf is the destination, we're done.  Return the pathnode.
				// TODO: For multi-tile objects, just cause the turf is found doesn't mean they can enter it.
				// TODO: It may be inaccessible to the head object.
				if (bestTurf == destination_turf)
					if (DEBUGGING) { world << "\red*** Found destination! ***\red" }
					return bestPathnode

				// If we've exceeded the limit, return the best path we have so far, which is this one.
				if (nodes.len > BASE_PATHNODE_LIMIT || (checkLimit > 0 && bestPathnode.costs >= checkLimit))
					if (DEBUGGING) { world << "\red *** Reached checkLimit -- returning best path so far. ***\red" }
					return bestPathnode

				// This turf isn't the destination, so remove it from the open turfs and put it with the closed turfs.
				openTurfs -= bestTurf
				closedTurfs += bestTurf
				if (DEBUGGING) { world << "\red      *** Closed node turf x: [bestTurf.x] y: [bestTurf.y]. ***\red" }
				nodes.Cut(1,2)

				// Get the children of this turf, sort them to try for a straight line if possible, and increment the cost.
				childTurfs = bestTurf.base_AccessibleTurfs()

				if (DEBUGGING) { world << "\magenta      *** Now evaluating node's [childTurfs.len] children...\magenta" }
				childCosts = bestPathnode.costs + 1

				// Process the children.
				for (var/i = 1, i <= childTurfs.len, i++)
					var/turf/childTurf = childTurfs[i]
					var/BaseCamp/PathNode/theNode
					var/closedPosition
					var/openPosition

					// DEBUG: If in a straight line, decrease the cost by one to bias for straight lines.
					var/biasedCost = childCosts
					if (childTurf.x == destination_turf.x || childTurf.y == destination_turf.y)
						biasedCost--

					if (DEBUGGING) { world << "          *** Checking child x: [childTurf.x] y: [childTurf.y]...***" }

					// If the moving object is dense and this turf is obstructed, skip it,
					// unless it's where we're actually trying to get to.
					if (!owner.base_CanEnterTurf(childTurf) && childTurf != destination_turf)
						continue

					// Determine whether this turf has an associated pathnode in either the closed or open lists.
					// If it's in one of these lists, we've processed this turf for another path.
					// If so, see if we found a faster way to get here.
					closedPosition = closedTurfs.Find(childTurf)
					if (closedPosition != 0)
						if (DEBUGGING) { world << "\blue               *** Found child on closed list. ***\blue" }
						theNode = childTurf.base_pathnode
					else
						openPosition = openTurfs.Find(childTurf)
						if (openPosition != 0)
							if (DEBUGGING) { world << "\blue               *** Found child on open list. ***\blue" }
							theNode = childTurf.base_pathnode

					if (closedPosition != 0 || openPosition != 0)
						if (DEBUGGING) { world << "\blue               *** Comparing previous costs: [theNode.costs] vs. current cost: [childCosts]. ***\blue" }
						if (biasedCost < theNode.costs)
//						if (childCosts < theNode.costs)
							// If it's on the closed list, remove it and put it on the open list.
							if (closedPosition != 0)
								// Deadron: This is the one part of the algorithm I'm not sure I understand.  I don't know why this would ever be reached.
								if (DEBUGGING) { world << "\blue               *** This is better path to turf -- opening it again. ***\blue" }
								openTurfs.Add(childTurf)
								closedTurfs.Remove(childTurf)
							else
								if (DEBUGGING) { world << "\blue               *** This is better path to turf -- replacing previous open node. ***\blue" }
								// This turf is on the open list for another path that isn't as efficient,
								// so create a pathnode for this path and replace the other node in the open list.
								// This is a creative way to ensure this turf is always associated with the shortest known path to it.
								var/dist = theNode.distance
								theNode = new /BaseCamp/PathNode(childTurf, bestPathnode, biasedCost, dist)
//								theNode = new /BaseCamp/PathNode(childTurf, bestPathnode, childCosts, dist)

							theNode.costs = biasedCost
//							theNode.costs = childCosts
							theNode.parent = bestPathnode
							_addNodeToSortedList(theNode)
					else
						var/estimatedDistance
						var/BaseCamp/PathNode/newnode

						if (isnull(childTurf) || isnull(destination_turf))
							world << "\red Almost called dd_get_dist with childTurf: [childTurf] destination: [destination_turf]"
							return
						estimatedDistance = dd_get_dist(childTurf, destination_turf)
						newnode = new /BaseCamp/PathNode(childTurf, bestPathnode, biasedCost, estimatedDistance)
//						newnode = new /BaseCamp/PathNode(childTurf, bestPathnode, childCosts, estimatedDistance)
						if (DEBUGGING) { world << "\red               *** Turf never considered.  Creating newnode: turf x: [childTurf.x] y: [childTurf.y] bestPathnode: [bestPathnode.name] costs: [childCosts] estDistance: [estimatedDistance]. ***\red" }
						openTurfs.Add(childTurf)
						_addNodeToSortedList(newnode)
			// DEBUG
//			world << "[type]._search() returning null for path. nodes.len: [nodes.len] destination x: [destination:x] y: [destination:y]"
			return null					// No open nodes and no solution.


		_addNodeToSortedList(BaseCamp/PathNode/node)
			var/newTotal = node.Total(owner)
			var/newCosts = node.costs
			var/index = _binarySearch(1, nodes.len, newTotal, newCosts)

			// Special case adding to end of list.
			if (index > nodes.len)
				nodes.Add(node)
			else
				// Because BYOND lists don't support insert, have to do it by:
				// 1) taking out bottom of list, 2) adding item, 3) putting back bottom of list.
				var/list/listBottom = nodes.Copy(index)
				nodes.Cut(index)
				nodes.Add(node)
				nodes.Add(listBottom)

			if (DEBUGGING)
				var/BaseCamp/PathNode/currentNode
				var/turf/currentTurf
				var/i
				for (i = 1, i <= nodes.len, i++)
					currentNode = nodes[i]
					currentTurf = currentNode.turf
					world << "       nodes[i]: x: [currentTurf.x] y: [currentTurf.y]"
			return


		_binarySearch(lowIndex, highIndex, total, costs)
			// Use binary search to order by cost.
			// This works by going to the half-point of the list, seeing if the node in question is higher or lower cost,
			// then going halfway up or down the list and checking again.
			// This is a very fast way to sort an item into a list.
			while (lowIndex <= highIndex)
				// Figure out the midpoint, rounding up for fractions.  (BYOND rounds down, so add 1 if necessary.)
				var/midwayCalc = (lowIndex + highIndex) / 2
				var/currentIndex = round(midwayCalc)
				if (midwayCalc > currentIndex)
					currentIndex++
				var/BaseCamp/PathNode/currentNode = nodes[currentIndex]
				var/currentTotal = currentNode.Total(owner)

				if ((total < currentTotal) || (total == currentTotal && costs >= currentNode.costs))
					highIndex = currentIndex - 1
				else
					lowIndex = currentIndex + 1
			return lowIndex			// Insert before lowIndex.


		_getSequence(BaseCamp/PathNode/n)
			// Unwraps nodes, pulling out turfs and putting them from first to last.
			var/list/result

			if (isnull(n))
				result = new /list()
			else
				result = _getSequence(n.parent)
				result.Add(n.turf)
			return result



turf/var/BaseCamp/PathNode/base_pathnode				// pathnode currently associated with this turf.


BaseCamp/PathNode
	// PathNodes make up a linked list which is a path on the map.
	// Each PathNode contains one turf, its part of the path.
	var
		name
		turf/turf
		costs
		distance
		BaseCamp/PathNode/parent

	New(theTurf, theParent, theCosts, theDistance)
		turf = theTurf
		turf.base_pathnode = src

		parent   = theParent
		costs    = theCosts
		distance = theDistance

		name = turf.name
		return ..()

	proc
		Total(atom/movable/owner)
			// Owner is passed for games that calculate aspects of pathing based on the type of mob,
			// such as whether the mob is afraid of fire. (Crispy)
			//
			// Add a fudge factor that increases with distance...this makes the pathing more
			// efficient by encouraging it to spend more time on turfs closer to the destination.
			var/fudge_factor = distance * 0.5
			return costs + distance + fudge_factor
//			return costs + distance

		Clear()
			// Clear references to other objects to speed up deletion of things.
			turf.base_pathnode = null	// Necessary?
			parent = null