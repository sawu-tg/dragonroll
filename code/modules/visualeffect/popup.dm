/atom/proc/popup(var/text = "",var/color = "#FFFFFF",var/fadetime=30)
	if(!src)
		return

	var/actualtext = "<text style='text-align: center; vertical-align: middle; font: bold 8px arial;'>[text]</text>"

	var/image/I = image(null,loc=src)
	I.maptext = actualtext
	I.color = color

	for(var/d in cardinal)
		var/offx = (d == 4 ? 1 : 0) + (d == 8 ? -1 : 0)
		var/offy = (d == 1 ? 1 : 0) + (d == 2 ? -1 : 0)

		var/image/I2 = image(null,loc=src)
		I2.maptext = actualtext
		I2.color = "#333333"
		I2.pixel_x = offx
		I2.pixel_y = offy

		I.underlays += I2

	for(var/mob/M in viewers(src))
		M << I

	animate(I, pixel_z = 50, alpha = 0, time = fadetime)

	spawn(fadetime)
		del(I)