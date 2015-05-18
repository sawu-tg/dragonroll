/*
	Written by FIREking
*/
var/cpu_readings
var/cpu_average
var/cpu_total

#ifdef DEBUG
var/clients = 0
atom/verb/see()
	set src in view()
	var/t = ""
	for(var/v in vars)
		t += "[v] == [vars[v]]\n"
	alert(t)

client
	New()
		..()
		clients++
	Del()
		clients--
		..()

turf
	verb/check_shading()
		set src in view()
		for(var/shading/s in src)
			alert("shading = [s] / lum: [s.ilum] / __lum: [s.flum] / icon_state: [s.icon_state]")
mob
	Stat()
		stat("pos:", "x:[x],y:[y]")
		stat("cpu:", world.cpu)
		cpu_total += world.cpu
		cpu_readings++
		cpu_average = cpu_total / cpu_readings
		stat("cpu average:", cpu_average)
		stat("lights:", lights_counter)
		stat("lights awake", lights_awake)
		stat("light renderings:", lights_rendered)
		if(src.light) stat("your light intensity: ", light.intensity)
		stat("players:", clients)
		stat("Instructions", {"
WASD for movement
Q places a light source
E creates a bot
Mob: Click toggles light on and off
Light: Click toggles light on and off
Wall: Click toggles grass / wall
Grass: Click toggles wall / grass
Enter: Brings up chat input window to talk
+: raises light intensity
-: lowers light intensity
"})

	Click()
		if(light)
			light.toggle()
			light.update()

	verb/check_lights_awake_list()
		for(var/light/l in src.client.lights_awake_list)
			world << "[l] is here"

	verb/look_at_lights()
		for(var/light/l in world)
			l.see()

	verb/kill_all_lights()
		for(var/light/l in world)
			if(l == src.light) continue
			del l

	verb/check_robots()
		for(var/player/robot/r in world)
			world << "[r]"

	verb/make_tons_of_lights()
		for(var/i = 1 to 1000)
			var/turf/t = locate(rand(1,world.maxx), rand(1,world.maxy), 1)
			t.light = new(t, 1)

#endif