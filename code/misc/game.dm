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

/proc/get_turf(atom/A)
	if (!istype(A))
		return
	for(A, A && !isturf(A), A=A.loc); //semicolon is for the empty statement
	return A

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

/proc/GetPath(var/atom/start,var/dir,var/maxDist = 4)
	var/turf/T = get_turf(start)
	var/count = 0
	while(!T.density)
		count++
		if(count <= maxDist)
			var/turf/T2 = get_step(T,dir)
			if(T2)
				T = T2
		else
			break
	return T


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

proc/pickweight(list/L)
	var/total = 0
	var/item
	for(item in L)
		if(!L[item]) L[item] = 1
		total += L[item]
		total=rand(1, total)
	for(item in L)
		total-=L[item]
		if(total <= 0) return item
	return null

/proc/circle(turf/source,radius=1,var/expensive = FALSE)
	var/list/l = list()
	var/rsq = radius * (radius+0.50)
	var/path = text2path("/[expensive ? "atom" : "turf"]")
	var/list/around = view(radius,source)
	var/count = 0
	for(count = 1; count < around.len; ++count)
		var/T = around[count]
		if(istype(T,path))
			var/dx = T:x - source.x
			var/dy = T:y - source.y
			if(dx*dx + dy*dy <= rsq)
				l |= T
	. = l

/proc/circleRange(turf/source,radius=1,var/expensive = FALSE)
	var/list/l = list()
	var/rsq = radius * (radius+0.50)
	var/path = text2path("/[expensive ? "atom" : "turf"]")
	var/list/around = range(radius,source)
	var/count = 0
	for(count = 1; count < around.len; ++count)
		var/T = around[count]
		if(istype(T,path))
			var/dx = T:x - source.x
			var/dy = T:y - source.y
			if(dx*dx + dy*dy <= rsq)
				l |= T
	. = l