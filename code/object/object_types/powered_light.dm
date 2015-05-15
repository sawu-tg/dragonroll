/obj/structure/powered/light
	name = "light"
	desc = "Brightens your day"
	icon = 'sprite/obj/lighting.dmi'
	icon_state = "tube1"
	powerNeeded = 10
	powerHeld = 1000
	powerOn = TRUE
	luminosity = 8

/obj/structure/powered/light/New()
	light = new(src, 12)
	light.loc = src.loc
	icon_state = "tube1"

/obj/structure/powered/light/verb/toggle()
	set src in view(32)
	powerOn = !powerOn
	light.toggle()
	light.update()
	icon_state = "tube[powerOn]"

/obj/structure/powered/light/debugPower()
	..()
	world << "Lums: [luminosity]"