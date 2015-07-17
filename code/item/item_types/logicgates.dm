/obj/item/logicgate
	name = "logic slab"
	desc = "Intricate runes mark the surface but it seems inert."
	icon = 'sprite/obj/alchemy/runes.dmi'
	icon_state = "gate"
	var/gatecolor = "#FFFFFF"
	var/evaluating = 0
	var/datum/wiremodule/wires
	var/image/glowimage

	//QoL vars
	var/inputs
	var/outputs

/obj/item/logicgate/New()
	..()
	glowimage = image(icon,src,"[icon_state]_glow",1000)
	glowimage.blend_mode = BLEND_ADD
	glowimage.color = gatecolor

	overlays += glowimage

	wires = new(src,6)

	add_inputs()
	add_outputs()

	addProcessingObject(src)

/obj/item/logicgate/proc/add_inputs()
	if(inputs == 1)
		wires.add_input("In",16,16-6,gatecolor)
		return

	for(var/n = 1,n <= inputs,n++)
		wires.add_input(ascii2text(64+n),16 - 8 + ((n-0.5) / inputs) * 16,16-6,gatecolor)

/obj/item/logicgate/proc/add_outputs()
	if(outputs == 1)
		wires.add_output("Out",16,16+6,gatecolor)
		return

	for(var/n = 1,n <= outputs,n++)
		wires.add_output(ascii2text(64+n),16 - 8 + ((n-0.5) / outputs) * 16,16+6,gatecolor)

/obj/item/logicgate/objFunction(var/mob/user,var/obj/item/with)
	if(istype(with,/obj/item/powerdevice/wiretool))
		var/obj/item/powerdevice/wiretool/WT = with
		WT.default_wire_action(user,wires)
		return

	..()

/obj/item/logicgate/doProcess()
	..()
	wires.doProcess()

/obj/item/logicgate/receive_wiresignal(input,signal,is_pulse)
	if(!evaluating)
		evaluating = 1
		spawn() evaluate()

/obj/item/logicgate/proc/evaluate()
	evaluating = 0

/obj/item/logicgate/not
	name = "\"NOT\" slab"
	icon_state = "wrath"
	gatecolor = "#CC0000"

	inputs = 1
	outputs = 1

	evaluate()
		var/input = wires.receive_wiresignal("In")

		sleep(0.1)

		wires.set_wiresignal("Out",!input)

		..()

/obj/item/logicgate/and
	name = "\"AND\" slab"
	icon_state = "congelation"
	gatecolor = "#0000CC"

	inputs = 2
	outputs = 1

	evaluate()
		var/inputA = wires.receive_wiresignal("A")
		var/inputB = wires.receive_wiresignal("B")

		sleep(0.1)

		wires.set_wiresignal("Out",inputA && inputB)

		..()

/obj/item/logicgate/or
	name = "\"OR\" slab"
	icon_state = "calcination"
	gatecolor = "#00CC00"

	inputs = 2
	outputs = 1

	evaluate()
		var/inputA = wires.receive_wiresignal("A")
		var/inputB = wires.receive_wiresignal("B")

		sleep(0.1)

		wires.set_wiresignal("Out",inputA || inputB)

		..()

/obj/item/logicgate/xor
	name = "\"XOR\" slab"
	icon_state = "coagulation"
	gatecolor = "#CC00CC"

	inputs = 2
	outputs = 1

	evaluate()
		var/inputA = wires.receive_wiresignal("A")
		var/inputB = wires.receive_wiresignal("B")

		sleep(0.1)

		wires.set_wiresignal("Out",inputA ^ inputB)

		..()

/obj/item/logicgate/constant
	name = "Constant crystal"
	desc = "A brilliant stone that refracts light."
	gatecolor = "#FFFFFF"
	icon = 'sprite/obj/wire.dmi'
	icon_state = "constant"

	inputs = 0
	outputs = 1

	var/maxvalue = 100
	var/keepvalue = 1

/obj/item/logicgate/constant/aja
	name = "Red Stone of Aja"
	desc = "A brilliant red gemstone that refracts light over a million times, amplifying energy."
	icon_state = "constant_aja"
	maxvalue = 1000000

/obj/item/logicgate/constant/objFunction(var/mob/user,var/obj/item/with)
	if(istype(with,/obj/item/powerdevice/wiretool))
		var/obj/item/powerdevice/wiretool/WT = with
		WT.default_wire_action(user,wires)
	else
		keepvalue = input("Adjust the output value of this crystal (max [maxvalue])","Output Strength",0) as num

		if(!keepvalue)
			keepvalue = 0

		keepvalue = min(keepvalue,maxvalue)

		wires.set_wiresignal("Out",keepvalue)