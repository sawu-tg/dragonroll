//Separate dm because it relates to two types of atoms + ease of removal in case it's needed.
//Also assemblies.dm for falsewall checking for this when used.
//I should really make the shuttle wall check run every time it's moved, but centcom uses unsimulated floors so !effort

/atom/proc/relativewall() //atom because it should be useable both for walls and false walls
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			junction |= get_dir(src,W)

	/*for(var/obj/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			junction |= get_dir(src,W)*/

	if(istype(src,/turf/wall))
		var/turf/wall/wall = src
		wall.icon_state = "[wall.walltype][junction]"
	/*else if (istype(src,/obj/structure/falsewall))
		if(istype(src,/obj/structure/falsewall/reinforced))
			icon_state = "rwall[junction]"
		else
			var/obj/structure/falsewall/fwall = src
			fwall.icon_state = "[fwall.mineral][junction]"*/
	return

/atom/proc/relativewall_neighbours()
	for(var/turf/wall/W in range(src,1))
		W.relativewall()
	/*for(var/obj/structure/falsewall/W in range(src,1))
		W.relativewall()
		W.update_icon() //Refreshes the wall to make sure the icons don't desync
		*/
	return

/turf/wall/New()
	relativewall_neighbours()
	..()

/turf/wall/Del()
	spawn(10)
		for(var/turf/wall/W in range(src,1))
			W.relativewall()

		/*for(var/obj/structure/falsewall/W in range(src,1))
			W.relativewall()*/
	..()

/turf/wall/relativewall()
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	/*for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)*/
	var/turf/wall/wall = src
	wall.icon_state = "[wall.walltype][junction]"
	return