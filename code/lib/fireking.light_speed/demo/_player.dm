/*
	Written by: FIREking
*/

proc/get_speed_delay(n)
	return (world.icon_size * world.tick_lag) / (! n ? 1 : n ) //prevents divide by zero

proc/get_glide_size(n, dir)
	if(dir & (dir - 1)) //diagonal
		return n + (n >> 1) //n / 2 is n >> 1
	else //cardinal
		return n

player
	parent_type = /mob

	icon = '_mob.dmi'

	var/tmp
		north = 0
		south = 0
		east = 0
		west = 0
		move_time = 0

	var/speed = 6

	Login()
		..()
		src.client.add_keys()
		src.client.set_focus(src.client.mob)
		spawn src.update_move()
		world << "[src] logs in"
		winset(src, "map", "icon-size=64")

	Logout()
		..()
		world << "[src] logs out"
		del(src)

	Move()
		if(!src.loc) return ..()

		if(world.time < src.move_time) return

		. = ..()

		if(.)
			src.glide_size = get_glide_size(src.speed, src.dir)
			if(client) src.client.glide_size = src.glide_size
			src.move_time = world.time + get_speed_delay(src.speed)
			if(src.light)
				light.loc = src.loc
				light.update()

	proc/update_move()

		if(src.client.keys["w"]) src.north = 1
		else src.north = 0

		if(src.client.keys["a"]) src.west = 1
		else src.west = 0

		if(src.client.keys["s"]) src.south = 1
		else src.south = 0

		if(src.client.keys["d"]) src.east = 1
		else src.east = 0

		if(src.north && src.south)
			src.north = 0
			src.south = 0
		if(src.east && src.west)
			src.east = 0
			src.west = 0

		var/dirs = (src.north && NORTH) | (src.south && SOUTH) | (src.east && EAST) | (src.west && WEST)
		if(dirs && !step(src, dirs) && dirs & (dirs - 1)) //try diagonal
			if(!step(src, dirs & (NORTH | SOUTH))) // if diagonal and step failed, try vertical
				step(src, dirs & (EAST | WEST)) // if vertical failed, try horizontal

		spawn(world.tick_lag) src.update_move()

	verb/say(t as text)
		world << "[key]: [t]"

	#ifdef DEBUG
	verb/check_lights_awake()
		var/counter = 0
		for(var/light/l in world)
			if(l.awake)
				counter++
		world << "there are [counter] lights awake"
	#endif

	key_down(k, client/c)
		if(k == "return")
			var/v = input("Enter text", "Chat") as text | null
			if(v)
				say(v)

		if(k == "q")
			new/turf/light(src.loc)

		if(k == "e")
			for(var/i = 1 to 100)
				new/player/robot(src.loc)

		if(k == "add")
			light.intensity(light.intensity+0.1)
			light.update()

		if(k == "subtract")
			light.intensity(light.intensity-0.1)
			light.update()