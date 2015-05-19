/obj/structure/powered/light
	name = "light"
	desc = "Brightens your day"
	icon = 'sprite/obj/lighting.dmi'
	icon_state = "tube1"
	powerNeeded = 10
	powerHeld = 1000
	powerOn = TRUE
	luminosity = 8

	var/datum/wiremodule/wires

/obj/structure/powered/light/New()
	light = new(src, 12)
	light.loc = src.loc
	icon_state = "tube1"

	wires = new(src, 6)
	wires.add_input("On")
	wires.add_output("On")

	//set_on(1)

	addProcessingObject(src)

/obj/structure/powered/light/doProcess()
	..()

	var/wireoff = 12

	var/xoff = ((dir & 4) ? wireoff : 0) + ((dir & 8) ? -wireoff : 0)
	var/yoff = ((dir & 1) ? wireoff : 0) + ((dir & 2) ? -wireoff : 0)

	var/xtrans = ((dir & 1) ? wireoff : 0) + ((dir & 2) ? -wireoff : 0)
	var/ytrans = ((dir & 4) ? wireoff : 0) + ((dir & 8) ? -wireoff : 0)

	wires.move_input("On",16 + xoff + xtrans,16 + yoff + ytrans)
	wires.move_output("On",16 + xoff - xtrans,16 + yoff - ytrans)

	wires.doProcess()

/obj/structure/powered/light/verb/toggle()
	set src in view(32)
	//powerOn = !powerOn
	//light.toggle()
	//light.update()
	//icon_state = "tube[powerOn]"
	set_on(!powerOn)

/obj/structure/powered/light/proc/set_on(var/on)
	powerOn = on

	//This is the most disgusting thing I've ever seen :V
	if(powerOn)
		light.on()
	else
		light.off()
	light.update()

	wires.set_wiresignal("On",powerOn)
	icon_state = "tube[powerOn]"

/obj/structure/powered/light/debugPower()
	..()
	world << "Lums: [luminosity]"

/obj/structure/powered/light/receive_wiresignal(input,signal,is_pulse)
	//world << "[src]: [input] got [signal]"

	if(input == "On")
		set_on(signal > 0)

/obj/structure/lightswitch
	name = "light switch"
	desc = "This is a light switch. Behaves oddly."
	icon = 'sprite/obj/power.dmi'
	icon_state = "light0"

	var/datum/wiremodule/wires
	var/on = 0

/obj/structure/lightswitch/New()
	..()

	wires = new(src, 6)
	wires.add_output("On",16,20)

	spawn(10)
		for(var/obj/structure/powered/light/lightfixture in range(6,src))
			world << "wiring up [lightfixture]"

			wires.wire_output("On",lightfixture.wires,"On")

		set_on(1)

	addProcessingObject(src)

/obj/structure/lightswitch/doProcess()
	..()

	wires.doProcess()

/obj/structure/lightswitch/proc/set_on(var/new_on)
	on = new_on

	wires.set_wiresignal("On",on)
	wires.doProcess()

	icon_state = "light[on]"

/obj/structure/lightswitch/objFunction(var/mob/user,var/obj/item/with)
	set_on(!on)
	user << "You flip [src]."