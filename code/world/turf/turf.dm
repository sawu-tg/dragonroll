/turf
	var/mineral = "iron"
	var/ambient_factor = 0
	luminosity = 1
	var/turfCreeps = FALSE // does the turf slowly spread over time?
	var/maxCreeps = 8 // maximum times this turf can creep
	var/creepRate = 60
	var/list/nearby
	var/useNaturalTiling = FALSE
	var/edge_weight = 0
	var/edge_icon = 'sprite/world/edges.dmi'
	var/turfRotBy = 0
	var/edged = FALSE

/turf/New()
	if(turfCreeps)
		spawn(creepRate)
			nearby = range(1,src)
			for(var/turf/T in nearby)
				if(T.type == src.type)
					maxCreeps--
			addProcessingObject(src)
	if(useNaturalTiling)
		turfRotBy = pick(90,180,270)
		src.transform = turn(src.transform,turfRotBy)
		useNaturalTiling = FALSE
	if(edged)
		spawn(5)
			generate_edges()
			for(var/A in alldirs)
				var/turf/T = get_step(src,A)
				if(T)
					T.generate_edges()
	..()

/turf/doProcess()
	if(maxCreeps > 0 && turfCreeps)
		if(creepRate > 0)
			--creepRate
		else
			creepRate = initial(creepRate)
			--maxCreeps
			var/turf/T = get_turf(pick(nearby))
			if(T)
				if(!istype(T.type,src.type))
					var/turf/S = new src.type(T)
					S.maxCreeps = initial(maxCreeps) - 1
	else
		remProcessingObject(src)

/turf/floor
	icon = 'sprite/world/floors.dmi'
	icon_state = "floor"

/turf/wall
	icon = 'sprite/world/walls.dmi'
	icon_state = "0"
	density = 1
	opacity = 1
	anchored = 1
	var/walltype = "metal"

/turf/wall/lobbyWall
	name = "Lobby Wall"
	icon_state = "wood0"
	mineral = "wood"
	walltype = "wood"

/turf/floor/lobbyFloor
	name = "Lobby Floor"
	icon_state = "wood"

/turf/floor/voidFloor
	name = "Void Space"
	icon_state = "black"
	density = 1
	opacity = 1

/turf/floor/darknessfloor
	name = "Strange tiling"
	icon_state = "cult"

/turf/floor/darknessfloor/New()
	..()
	spawn(1)
		icon_state = pick("cult","cultdamage[rand(1,7)]")


//End of default floors

//turf edge generation courtesy of forum_account

/turf
	var/has_edges = 0


/turf/proc/__needs_edge(turf/t)
	if(!t) return 0
	if(istype(t, type)) return 0
	if(t.edge_weight > edge_weight) return 0
	return 1

/turf/proc/__add_edge(d)
	var/icon/i = icon('sprite/obj/tg_effects/effects.dmi', "nothing")

	var/icon/turf_icon = icon(src.icon,src.icon_state)
	var/icon/mask_icon = new('sprite/world/masks.dmi', "pattern-3", d)
	mask_icon.MapColors(-1,0,0,-1, 0,-1,0,-1, 0,0,-1,-1, 1,1,1,0, 1,1,1,1)
	turf_icon.Blend(mask_icon,ICON_MULTIPLY)
	i.Blend(turf_icon,ICON_OVERLAY)
	i.Turn(-turfRotBy)

	var/image/ii = image(i,layer = TURF_LAYER + 0.01 * edge_weight)

	if(d & NORTH) ii.pixel_y = 32
	if(d & SOUTH) ii.pixel_y = -32
	if(d & EAST) ii.pixel_x = 32
	if(d & WEST) ii.pixel_x = -32

	overlays += ii

/turf/proc/generate_edges()

	if(has_edges) return

	var/north = __needs_edge(locate(x, y + 1, z))
	var/south = __needs_edge(locate(x, y - 1, z))
	var/east = __needs_edge(locate(x + 1, y, z))
	var/west = __needs_edge(locate(x - 1, y, z))

	if(north) __add_edge(NORTH)
	if(north && east) __add_edge(NORTHEAST)
	if(north && west) __add_edge(NORTHWEST)

	if(south) __add_edge(SOUTH)
	if(south && east) __add_edge(SOUTHEAST)
	if(south && west) __add_edge(SOUTHWEST)

	if(east) __add_edge(EAST)
	if(west) __add_edge(WEST)

	has_edges = 1

/turf/proc/clear_edges()

	if(!has_edges) return

	overlays = null
	has_edges = 0

/proc/my_text2num(txt, base = 10)
	ASSERT(istext(txt))
	ASSERT(base >= 2)
	ASSERT(base <= 16)

	. = 0

	var/negative = 0
	if(copytext(txt,1,2) == "-")
		txt = copytext(txt,2)
		negative = 1

	txt = uppertext(txt)
	var/list/num_char = list("0"=0,"1"=1,"2"=2,"3"=3,"4"=4,"5"=5,"6"=6,"7"=7,"8"=8,"9"=9,"A"=10,"B"=11,"C"=12,"D"=13,"E"=14,"F"=15)
	for(var/i = 1 to length(txt))
		var/c = copytext(txt,i,i+1)
		if(c in num_char)
			c = num_char[c]
			if(c >= base)
				. = usr
				CRASH("Invalid character '[c]' in base [base] string '[txt]'.")
			. = (base * .) + c
		else
			return null

	if(negative)
		. = -.

/datum/Color
	var/red = 0
	var/green = 0
	var/blue = 0
	var/alpha = 255

	// The constructor has three forms:
	//
	//     new /Color()
	//     new /Color(red, green, blue, [alpha])
	//     new /Color(color_string)
	//
	// For the first form, all RGBA components are initialized
	// to zero.
	// For the second form, the RGBA components are set as you
	// specify. If you leave out the alpha it is set to 255.
	// For the third form the string can be of the form "#RRGGBB"
	// or "#RRGGBBAA".
/datum/Color/New(a, b = 0, c = 0, d = 255)
	if(istext(a))
		red = my_text2num(copytext(a,2,4),16)
		green = my_text2num(copytext(a,4,6),16)
		blue = my_text2num(copytext(a,6,8),16)
		if(length(a) > 7)
			alpha = my_text2num(copytext(a,8,10),16)

	else if(isnum(a))
		red = a
		green = b
		blue = c
		alpha = d
	else if(isnull(a))
		alpha = 0

/datum/Color/proc/RGB()
	if(alpha >= 0)
		return rgb(red, green, blue, alpha)
	return rgb(red, green, blue)