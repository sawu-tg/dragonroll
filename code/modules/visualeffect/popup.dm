/atom/proc/timebar(var/list/colors,var/basecolor = "#000000",var/fadetime=30)
	if(!colors || !colors.len)
		return

	var/barwidth = 30
	var/barheight = 5
	var/baroffx = 0
	var/baroffy = 20

	var/matrix/basetransform = matrix()
	basetransform.Scale(barwidth/32,barheight/32)

	var/matrix/emptytransform = matrix()
	emptytransform.Scale(0,barheight/32)
	emptytransform.Translate((-barwidth/2) + baroffx,baroffy)

	var/image/I = image(null,loc=src) //<= put your desired background icon here and adjust bar width and height bby

	var/image/I2 = image('sprite/gui/guiObj.dmi',loc=src,icon_state="white")
	I2.color = basecolor
	I2.transform = basetransform

	var/image/I3 = image('sprite/gui/guiObj.dmi',loc=src,icon_state="empty")
	I3.color = colors[1]
	I3.layer = I.layer + 0.1
	I3.transform = emptytransform

	I.overlays += I2

	for(var/mob/M in viewers(src))
		M << I
		M << I3

	for(var/i=2, i<=colors.len, i++)
		var/fill = (i-1) / (colors.len-1)
		var/barfill = barwidth*fill
		var/matrix/filltransform = matrix()
		var/currcolor = colors[i]

		filltransform.Scale(barfill/32,barheight/32)
		filltransform.Translate(-barwidth/2 + barfill/2 + baroffx,baroffy)

		if(i == 2) //THIS IS DISGUSTING BUT IT DOESN'T WORK ANY OTHER WAY FUCK
			animate(I3,transform = filltransform,color = currcolor,icon_state="white",time = fadetime / (colors.len-1))
		else
			animate(transform = filltransform,color = currcolor,icon_state="white",time = fadetime / (colors.len-1))

	animate(alpha = 0,time = 3)

	animate(I,alpha = 254,time = fadetime)
	animate(alpha = 0,time = 3)

	spawn(fadetime)
		del(I)
		del(I3)

/mob/verb/test_timebar()
	timebar(list("#FF0000","#FFFF00","#00FF00"),fadetime = rand(30,60))


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


