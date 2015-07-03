/mob/verb/generateminimap()
	set name = "Generate Mini-map"
	set category = "Debug Verbs"
	var/Z = input(usr,"What Z-Level?") as num
	if(!Z)
		return
	if(Z < 0)
		Z = 0
	if(Z > world.maxz)
		Z = world.maxz
	var/icon/I = icon('sprite/obj/tg_effects/effects.dmi',icon_state="nothing")
	I.Scale(world.maxx,world.maxy)
	for(var/X = 1; X < world.maxx; X++)
		for(var/Y = 1; Y < world.maxy; Y++)
			var/turf/T = locate(X,Y,Z)
			var/icon/I2 = icon(T.icon,icon_state=T.icon_state)
			var/pixColor = T.color ? T.color : I2.GetPixel(1,1)
			if(pixColor)
				I.DrawBox(pixColor,X,Y)
			else
				if(!T)
					I.DrawBox("purple",X,Y)
				else
					I.DrawBox("red",X,Y)
	usr << ftp(I,"minimap-[Z].png")