/*
	light_speed.dm
	Light Speed
	The fastest light system for BYOND
	Written by FIREking

	Special thanks to Forum_Account for his contributions to the community and his library Dynamic Lighting from which this was inspired
	Thanks to D4RK3 54B3R for Angular Shadow Casting optimization
*/

/*
What is light speed?
Light Speed is an ultra fast lighting library for BYOND

How does it work?
Light Speed is event-based, not loop based which is why it is fast.
It only acts when it needs to, which makes it efficient.

Why is it fast? What are the limitations?
* Light Speed is fast because it doesn't support moving opaque objects
* Light Speed does not provide math heavy cone-like effects, only radius based light sources
* Light Speed will only render lights that clients can actually see
* Light Speed renders a static light only once
* Light Speed uses pre-rendered icon_state switching to provide shading


How can I use it?

////////////////////////////////////////
To make a turf light up
////////////////////////////////////////

turf
	lamp
		New()
			..()
			light = new(src, 3, 0.9)
			//3 is the radius, 0.9 is the intensity (0 - 1)

////////////////////////////////////////
To make a turf block light
////////////////////////////////////////

turf
	wall
		opaque = 1

////////////////////////////////////////
To make a mob have a light source
////////////////////////////////////////

mob
	New()
		..()
		light = new(src, 3, 0.9)
		light.loc = src.loc

	Move()
		. = ..()
		if(.)
			light.loc = src.loc
			light.update()

////////////////////////////////////////
To make a player have a light source
////////////////////////////////////////

mob
	Login()
		..()

		//set mob location first

		light = new(src, 3, 0.9)
		light.loc = src.loc

	Move()
		. = ..()
		if(.)
			light.loc = src.loc
			light.update()

That's it!

How do I make my own lighting icon?
1. Open !lighting.dm
2. Change #define LIGHTING_GENERATOR 0 to #define LIGHTING_GENERATOR 1
3. Set your desired darkest_alpha, lightest_alpha, detail, red, green, and blue values
4. Click Build -> Compile
5. Run the project, and pay attention to the output as it updates you on current light generation progress
6. When it is done generating the light, it will ask you to name the file and save it somewhere on your computer
7. Save it to a location within the project
8. Return to the project and click on the File tab on the left
9. Click the "Refresh" button so that your new icon shows up in the file tree
10. Open !lighting.dm again
11. Change #define LIGHTING_ICON 'lighting_64.dmi' to #define LIGHTING_ICON 'the_file_you_just_made_here.dmi'
12. Change #define LIGHTING_GENERATOR 1 to #define LIGHTING_GENERATOR 0
13. Click Build -> Compile
14. Run the project again to test out your new lighting icon!

Other stuff:

You must call light.update() if you change the light.
This includes turning the light on or off, moving it, changing its ambient, radius, or intensity values
The library does not use cpu to update the light if it isn't visible to any clients

*/
#define BLANK_ICON '_blank.dmi' //trying to force inclusion for this file which is usually orphaned on building

atom/var/tmp/light/light = null
//every atom can have a light

atom/Del()
	//make sure lights (and their effect) are removed properly on light's owner death!
	if(light)
		del light
		light = null
	..()

turf/var/opaque = 0
//opaque is used to block light
//only turfs can block light

turf/var/opaque_shading = 0
//by default, opaque objects don't recieve luminosity
//set this to 1 if you want an object to block light, but still receive luminosity

turf/var/tmp/shading/shading = null
//every turf has a shading object
//do not manage or mess with shaders!

turf/New()
	..()
	//force a re-calculation of light to adjust to the turf changes
	if(world.time > 0)
		for(var/light/l in range(world.view, src))
			l.wake()
			l.update()

var/shading/null_shading = new(null, null, 0)
//default null shader

client
	var/tmp/list/lights_awake_list = list()

	New()
		..()
		spawn light_search()

	Del()
		unwake_lights()
		..()

	proc/light_search()
		unwake_lights()
		wake_lights()
		spawn(world.tick_lag) light_search()

	proc/wake_lights()
		if(!mob) return

		for(var/light/l in view(src))
			if(l.awake) continue
			l.wake()
			lights_awake_list += l
			if(l.on && !l.effect)
				l.update()
			if(!l.on && l.effect)
				l.update()

	proc/unwake_lights()
		for(var/light/l in lights_awake_list)
			l.unwake()
		lights_awake_list.Cut()

#if LIGHTING_ENABLED && !LIGHTING_GENERATOR
world/New()
	..()
	pad_edges()
	spawn lighting.init()

world/proc/pad_edges()
	world.maxx++
	world.maxy++
	for(var/turf/t in block(locate(world.maxx, 1, 1), locate(world.maxx, world.maxy, world.maxz)))
		t.icon = null
		t.density = 1
	for(var/turf/t in block(locate(1, world.maxy, 1), locate(world.maxx, world.maxy, world.maxz)))
		t.icon = null
		t.density = 1
#endif


#ifdef DEBUG

var/global/lights_awake = 0
var/global/lights_counter = 0
var/global/lights_rendered = 0

#endif

proc/los(x0, y0, x1, y1, z = 1)
	//line of sight
	//returns 1 if x0, y0 has line of sight to x1, y1
	//returns 0 otherwise
	//blocking is determined by turf.opaque only

	var/dx,dy,x,y,n,x_inc,y_inc,error

	dx = abs(x1 - x0)
	dy = abs(y1 - y0)

	x = x0
	y = y0
	n = 1 + dx + dy
	x_inc = (x1 > x0) ? 1 : -1
	y_inc = (y1 > y0) ? 1 : -1
	error = dx - dy
	dx *= 2
	dy *= 2

	for(n = n; n > 0; --n)
		var/turf/t = locate(x, y, z)
		if(t.opaque)
			return 0
		if(error > 0)
			x += x_inc
			error -= dy
		else
			y += y_inc
			error += dx
	return 1

proc/_get_angle(x, y)
	//get angle
	//this returns an angle in degrees. returned 0 is positive x axis, 90 is positive y axis

	if(x == 0)
		if(y > 0) return 90
		if(y < 0) return 270
		if(y == 0) return 0

	var/yx = y / x
	var/ang = arcsin((yx) / sqrt(1 + (yx) * (yx))) //arctan
	if(x < 0) ang += 180

	if(ang < 0) ang += 360
	if(ang >= 360) ang -= 360
	return ang

proc/_lengthsq(x1, y1, x2, y2)
	//this returns the length squared

	return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)

var/lighting/lighting = new()
//default lighting object

lighting
	var/tmp
		states = 0
		icon = LIGHTING_ICON
		list/initialized = list()

	proc/init()
		set background = 1
		if(!states)
			if(!icon)
				#ifdef DEBUG
				CRASH("The global var lighting.icon must be set.")
				#endif
				del(src)
			var/list/l = icon_states(icon)
			states = l.len ** 0.25

		var/list/z_levels = list()

		for(var/a in args)
			if(isnum(a))
				z_levels += a

		if(!z_levels.len)
			for(var/i = 1 to world.maxz)
				z_levels += i

		var/list/shaders = list()

		for(var/z in z_levels)
			if(z in initialized)
				continue
			initialized += z

			for(var/x = 1 to world.maxx)
				for(var/y = 1 to world.maxy)
					var/turf/t = locate(x,y,z)
					if(!t) break
					if(t.shading) continue
					t.shading = new(t)
					shaders += t.shading

		for(var/s in shaders)
			s:init()

light
	parent_type = /obj

	icon = null
	icon_state = null

	mouse_opacity = 0

	var/tmp
		atom/owner = null
		radius = 2
		radius_squared = 4
		intensity = 1
		on = 1
		list/effect = null

		awake = 0

	New(atom/a, radius = 3, intensity = 1)
		#ifdef DEBUG
		lights_counter++
		if(!a || !istype(a))
			CRASH("The first argument should be an atom, getting [a] instead")
		#endif

		owner = a

		if(istype(owner, /atom/movable))
			loc = owner.loc
		else
			loc = owner

		src.radius = radius
		src.radius_squared = radius * radius
		src.intensity = intensity

	Del()
		if(loc)
			if(effect)
				off()
				render()
				unwake()
			src.owner.light = null
			src.owner = null
			src.loc = null
			return
		#ifdef DEBUG
		lights_counter--
		#endif
		..()

	proc/wake()
		#ifdef DEBUG
		if(!awake)
			lights_awake++
		#endif
		awake = 1

	proc/unwake()
		#ifdef DEBUG
		if(awake)
			lights_awake--
		#endif
		awake = 0

	proc/update()
		if(!owner || !loc) del(src)
		render()

	proc/render()
		if(effect)
			for(var/s in effect)
				if(!s) continue
				s:lum(-effect[s])
				s:update()
			effect.Cut()

		if(on && loc && awake && world.cpu < LIGHTING_CPU_THROTTLE)
			effect = AngularShadowCasting()
			for(var/s in effect)
				if(!s) continue
				s:lum(effect[s])
				s:update()
			unwake()

	proc/on()
		if(on) return
		on = 1

	proc/off()
		if(!on) return
		on = 0

	proc/toggle()
		if(on) off()
		else on()

	proc/radius(r)
		if(radius == r) return

		radius = r
		radius_squared = r * r

	proc/intensity(i)
		if(intensity == i) return

		intensity = i

	proc/lum(atom/a)
		if(!radius) return 0
		if(!a) return 0

		var/d = (x - a.x) * (x - a.x) + (y - a.y) * (y - a.y)
		if(d > radius_squared) return 0
		d = sqrt(d)
		return cos(90 * d / radius) * intensity

	proc/LineOfSightShadowCasting()
		#ifdef DEBUG
		lights_rendered++
		#endif

		var/list/L = list()
		var/list/area = list()
		if(radius >= world.maxx || radius >= world.maxy)
			area = bounds(src,(radius*32)*4)
		else
			area = range(radius, src)
		for(var/shading/s in area)
			if(s.loc:opaque_shading)
				L[s] = lum(s)
				continue
			if(los(s.loc.x, s.loc.y, src.x, src.y, src.z))
				L[s] = lum(s)
		return L

	proc/AngularShadowCasting()
		#ifdef DEBUG
		lights_rendered++
		#endif

		var/list/L = list()

		//first iterate through every dense object in the radius
		//for each dense object, find the angles to its vertices and keep track of them
		var/list/oa1 = list() //opaque angle1, the greater angle
		var/list/oa2 = list() //opaque angle2, the lesser angle
		var/list/od = list()  //opaque distance

		for(var/shading/s in orange(radius, src) - src.loc.contents)
			if(!s.loc:opaque)
				continue
			var/ox = s.x
			var/oy = s.y
			od.Add(_lengthsq(x, y, ox, oy))

			if(ox > x)
				if(oy > y) // TR
					oa1.Add(_get_angle(ox - x - 0.5, oy - y + 0.5)) // TL
					oa2.Add(_get_angle(ox - x + 0.5, oy - y - 0.5)) // BR
				else if(oy < y) // BR
					oa1.Add(_get_angle(ox - x + 0.5, oy - y + 0.5)) // TR
					oa2.Add(_get_angle(ox - x - 0.5, oy - y - 0.5)) // BL
				else // MR
					oa1.Add(_get_angle(ox - x - 0.5, oy - y + 0.5)) // TL
					oa2.Add(_get_angle(ox - x - 0.5, oy - y - 0.5)) // BL
			else if(ox < x)
				if(oy > y) // TL
					oa1.Add(_get_angle(ox - x - 0.5, oy - y - 0.5)) // BL
					oa2.Add(_get_angle(ox - x + 0.5, oy - y + 0.5)) // TR
				else if(oy < y) // BL
					oa1.Add(_get_angle(ox - x + 0.5, oy - y - 0.5)) // BR
					oa2.Add(_get_angle(ox - x - 0.5, oy - y + 0.5)) // TL
				else // ML
					oa1.Add(_get_angle(ox - x + 0.5, oy - y - 0.5)) // BR
					oa2.Add(_get_angle(ox - x + 0.5, oy - y + 0.5)) // TR
			else
				if(oy > y) // TM
					oa1.Add(_get_angle(ox - x - 0.5, oy - y - 0.5)) // BL
					oa2.Add(_get_angle(ox - x + 0.5, oy - y - 0.5)) // BR
				else if(oy < y) // BM
					oa1.Add(_get_angle(ox - x + 0.5, oy - y + 0.5)) // TR
					oa2.Add(_get_angle(ox - x - 0.5, oy - y + 0.5)) // TL
				else CRASH("Should not be checking this turf.") // MM

		var/obsl = od.len
		var/list/area = list()
		if(radius >= world.maxx || radius >= world.maxy)
			area = bounds(src,(radius*32)*4)
		else
			area = range(radius, src)
		for(var/shading/s in area)
			if(s.loc:opaque && !s.loc:opaque_shading) continue
			var/ds = _lengthsq(s.x, s.y, src.x, src.y)

			if(ds > radius_squared) continue

			var/er = 1
			var/a = _get_angle(s.x - src.x, s.y - src.y)

			for(var/i = 1; i <= obsl; i++)
				if(od[i] >= ds) continue

				var
					a1 = oa1[i]
					a2 = oa2[i]

				if(a2 - a1 > 180)
					if(a < a1 || a > a2)
						goto NextShadingObj
				else
					if(a < a1 && a > a2)
						goto NextShadingObj

				if(a == a1 || a == a2)
					er = min(0.5, er) //This is for smoothing out edges

			L[s] = lum(s) * er

			NextShadingObj:

		return L

shading
	parent_type = /obj

	icon = LIGHTING_ICON
	icon_state = "0000"
	layer = LIGHTING_LAYER

	mouse_opacity = 0

	pixel_x = LIGHTING_HALF_ICON_SIZE
	pixel_y = LIGHTING_HALF_ICON_SIZE

	Del()
		if(c1 && c1.u3) c1.u3 = null_shading
		if(c2 && c2.u2) c2.u2 = null_shading
		if(c3 && c2.u1) c3.u1 = null_shading

		if(u1 && u1.c3) u1.c3 = null_shading
		if(u2 && u2.c2) u2.c2 = null_shading
		if(u3 && u3.c1) u3.c1 = null_shading
		..()

	var/tmp
		ilum = 0 //integer luminosity
		flum = 0 //float luminosity

		shading/c1 = null
		shading/c2 = null
		shading/c3 = null

		shading/u1 = null
		shading/u2 = null
		shading/u3 = null

		ambient = 0

	proc/init()
		c1 = locate(/shading) in get_step(loc, SOUTH)
		c2 = locate(/shading) in get_step(loc, SOUTHWEST)
		c3 = locate(/shading) in get_step(loc, WEST)

		u1 = locate(/shading) in get_step(loc, EAST)
		u2 = locate(/shading) in get_step(loc, NORTHEAST)
		u3 = locate(/shading) in get_step(loc, NORTH)

		if(!c1) c1 = null_shading
		if(!c2) c2 = null_shading
		if(!c3) c3 = null_shading

		if(!u1) u1 = null_shading
		if(!u2) u2 = null_shading
		if(!u3) u3 = null_shading

		if(world.time > 0)

			if(c1.u3 && c1.u3 != src) c1.u3 = src
			if(c2.u2 && c2.u2 != src) c2.u2 = src
			if(c3.u1 && c3.u1 != src) c3.u1 = src

			if(u1.c3 && u1.c3 != src) u1.c3 = src
			if(u2.c2 && u2.c2 != src) u2.c2 = src
			if(u3.c1 && u3.c1 != src) u3.c1 = src

	proc/lum(n)
		flum += n
		ilum = min(max(round(flum * lighting.states, 1), 0), lighting.states -1)

	proc/update()
		if(loc && c1 && c2 && c3)
			icon_state = text("[][][][]", c1.ilum, c2.ilum, c3.ilum, ilum)
		if(u1 && u1.loc)
			u1.icon_state = text("[][][][]", u1.c1.ilum, u1.c2.ilum, u1.c3.ilum, u1.ilum)
		if(u2 && u2.loc)
			u2.icon_state = text("[][][][]", u2.c1.ilum, u2.c2.ilum, u2.c3.ilum, u2.ilum)
		if(u3 && u3.loc)
			u3.icon_state = text("[][][][]", u3.c1.ilum, u3.c2.ilum, u3.c3.ilum, u3.ilum)

#if LIGHTING_GENERATOR

world/New()
	..()

	spawn lighting_generator()

proc/lighting_generator()

	var/icon/master = new

	var/total = detail * detail * detail
	var/count = 0

	for(var/a = 1 to detail)
		for(var/b = 1 to detail)
			for(var/c = 1 to detail)
				for(var/d = 1 to detail)
					var/icon/I = generate_state(a, b, c, d)

					master.Insert(I, "[a-1][b-1][c-1][d-1]")

				count += 1
				var/percent = round(100 * count / total)
				world << "[percent]%"

				sleep(world.tick_lag)

	world << ftp(master, "lighting_[world.icon_size].dmi")

proc/generate_state(a, b, c, d)
	var/icon/I = icon('_blank.dmi', "blank")
	I.Scale(world.icon_size, world.icon_size)

	var/a_val = value(a)
	var/b_val = value(b)
	var/c_val = value(c)
	var/d_val = value(d)

	for(var/x = 1 to world.icon_size)
		for(var/y = 1 to world.icon_size)
			var/i = (x - 1) / (world.icon_size - 1)
			var/j = (y - 1) / (world.icon_size - 1)

			var/a_wgt = (    i) * (1 - j)
			var/b_wgt = (1 - i) * (1 - j)
			var/c_wgt = (1 - i) * (    j)
			var/d_wgt = (    i) * (    j)

			var/alpha = round(a_val * a_wgt + b_val * b_wgt + c_val * c_wgt + d_val * d_wgt)

			I.DrawBox(rgb(red, green, blue, alpha), x, y)

	return I

proc/value(state)
	return darkest_alpha - (darkest_alpha - lightest_alpha) * ((state - 1) / (detail - 1))

#endif