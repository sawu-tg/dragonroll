/*
	Written by: FIREking
*/

world
	fps = 40
	icon_size = 64

	view = "13x9"

	turf = /turf/grass
	mob = /player

	name = "Light Speed"
	status = "Testing Light Speed, Please Join!"

client
	perspective = EDGE_PERSPECTIVE

player
	Login()
		..()
		light = new(src, 3)
		src.loc = locate(32,1,1)
		light.loc = src.loc

turf
	icon = '_turf.dmi'
	opaque = 0 //by default, turfs do not block light

	grass
		icon_state = "grass"

		Click()
			new /turf/wall(src)

	wall
		icon_state = "wall"
		density = 1
		opaque = 1 //walls block light!

		Click()
			new /turf/grass(src)

	light
		icon_state = "light"
		density = 1

		New()
			..()
			light = new(src, 6, 1)

		Click()
			if(light.on)
				opaque = 1
				icon_state = "light_off"
			else
				opaque = 0
				icon_state = "light"

			light.toggle()
			light.update()

player
	robot
		parent_type = /player
		icon = '_mob.dmi'
		speed = 1
		New()
			..()
			light = new(src, 3, 0.5)
			spawn(rand(1, 10)) life()

		proc/life()
			step_rand(src)
			spawn(get_speed_delay(src.speed)) life()

		Click()
			del src