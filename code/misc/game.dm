var/list/cardinal = list( NORTH, SOUTH, EAST, WEST )
var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

/proc/get_dist_euclidian(atom/Loc1 as turf|mob|obj,atom/Loc2 as turf|mob|obj)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)

	return dist

/proc/get_angle(atom/start,atom/end)//For beams.
	if(!start || !end) return 0
	var/dy
	var/dx
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

/proc/vector2angle(dx,dy)//For beams.
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

/proc/arctan(x)
	var/y=arcsin(x/sqrt(1+x*x))
	return y


/matrix/proc/TurnTo(old_angle, new_angle)
	. = new_angle - old_angle
	Turn(.) //BYOND handles cases such as -270, 360, 540 etc. DOES NOT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT


/atom/proc/SpinAnimation(speed = 10, loops = -1)
	var/matrix/m120 = matrix(transform)
	m120.Turn(120)
	var/matrix/m240 = matrix(transform)
	m240.Turn(240)
	var/matrix/m360 = matrix(transform)
	speed /= 3      //Gives us 3 equal time segments for our three turns.
	                //Why not one turn? Because byond will see that the start and finish are the same place and do nothing
	                //Why not two turns? Because byond will do a flip instead of a turn
	animate(src, transform = m120, time = speed, loops)
	animate(transform = m240, time = speed)
	animate(transform = m360, time = speed)

/atom/proc/total_x()
	return (x+0.5) * 32 + pixel_x

/atom/proc/total_y()
	return (y+0.5) * 32 + pixel_y

/proc/get_turf(atom/movable/AM)
	if(istype(AM))
		return locate(/turf) in AM.locs
	else if(isturf(AM))
		return AM

/proc/get_outermost_atom(atom/AM)
	if(!AM.loc || isturf(AM.loc))
		return AM
	else
		return get_outermost_atom(AM.loc)

/proc/is_type_in_list(var/atom/A, var/list/L)
	for(var/type in L)
		if(istype(A, type))
			return 1
	return 0

/proc/FloodFill(var/datum/start, var/proc/adjacency)
	var/list/visited = list()
	. = list()
	visited |= start

	var/i = 1
	while(visited.len > 0 && i <= visited.len)
		var/T = visited[i]
		//visited -= T
		if(T)
			. |= T
			visited |= call(adjacency)(T)
		i++
