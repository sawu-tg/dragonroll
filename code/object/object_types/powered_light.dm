/obj/structure/powered/light
	name = "light"
	desc = "Brightens your day"
	icon = 'sprite/obj/lighting.dmi'
	icon_state = "tube1"
	powerNeeded = 10
	powerHeld = 1000
	powerOn = TRUE
	luminosity = 8

/obj/structure/powered/light/verb/toggle()
	set src in view(32)
	powerOn = !powerOn
	icon_state = "tube[powerOn]"

/obj/structure/powered/light/debugPower()
	..()
	world << "Lums: [luminosity]"

/obj/structure/powered/light/process()
	if(powerOn)
		updateLighting()
	..()