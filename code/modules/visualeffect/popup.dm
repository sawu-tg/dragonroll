/atom/proc/popup(var/text = "",var/color = "#FFFFFF",var/fadetime=30, var/xoffset = 0, var/yoffset = 0)
	if(!src)
		return

	var/actualtext = "<text style='text-align: center; vertical-align: middle; font: 8px arial;'>[text]</text>"

	var/image/I = image(null,loc=src)
	I.maptext = actualtext
	I.maptext_width = world.icon_size*4
	I.pixel_x = -(I.maptext_width/2) + 16 + xoffset
	I.pixel_y = yoffset
	I.color = color

	for(var/d in cardinal)
		var/offx = (d & 4 ? 1 : 0) + (d & 8 ? -1 : 0)
		var/offy = (d & 1 ? 1 : 0) + (d & 2 ? -1 : 0)

		var/image/I2 = image(null,loc=src)
		I2.maptext_width = I.maptext_width
		I2.maptext = actualtext
		I2.color = "#000000"
		I2.pixel_x = offx
		I2.pixel_y = offy

		I.underlays += I2

	for(var/mob/M in viewers(src))
		M << I

	animate(I, pixel_z = 50, alpha = 0, time = fadetime)

	spawn(fadetime)
		sdel(I)


/mob/verb/popup_anything()

	var/thing = input("Popup text:") as text
	if(!istext(thing))
		src << "no"
		return

	var/xoff = input("X") as num
	var/yoff = input("Y") as num

	popup(thing, xoffset = xoff, yoffset = yoff)


