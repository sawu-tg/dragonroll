//////////////////////////////////////////////////////////////////////////////////////
// Generic Invisible Wire System
//////////////////////////////////////////////////////////////////////////////////////

#define WIRE_INPUT 0
#define WIRE_OUTPUT 1

atom/proc/receive_wiresignal(input,signal,is_pulse)
	//if(is_pulse)
		//world << "[src] received [input] = [signal] wirepulse"

	return

datum/wirenode
	var/datum/wiremodule/parent

	var/name = ""
	var/value = 0
	var/mode = WIRE_OUTPUT

	var/datum/wirenode/connected

	New(var/datum/wiremodule/parent,name,mode)
		src.parent = parent
		src.name = name
		src.mode = mode

	proc/set_value(newvalue)
		if(mode == WIRE_OUTPUT)
			value = newvalue

			//world << "setting [connected] to [newvalue]"

			if(connected && connected.value != newvalue)
				connected.value = newvalue
				connected.pulse()

	proc/get_value()
		if(!connected)
			return 0

		if(mode == WIRE_INPUT)
			return connected.value

	proc/pulse()
		parent.pulse_wiresignal(name)

	proc/connect(var/datum/wirenode/othernode,var/direct = 1)
		if(!othernode || othernode.mode == src.mode)
			return

		if(connected)
			disconnect()

		connected = othernode

		if(direct)
			connected.connect(src,0)

	proc/disconnect(var/direct = 1)
		if(connected && direct)
			connected.disconnect(0)

		value = 0
		connected = null

		//world << "node disconnected"

	proc/wirelength()
		if(!connected)
			return 0

		var/atom/origin = parent.myatom
		var/atom/terminus = connected.parent.myatom

		return get_dist_euclidian(origin,terminus)


datum/wiremodule
	var/atom/myatom

	var/maxlength = 8 //How far the wire reaches, too long and it will cull.

	var/list/outputs = list() //Reference to wire objects connected to outputs
	var/list/inputs = list() //Reference to wire objects connected to inputs

	var/list/cableimages = list()

	New(var/atom/A,cablelen = 8)
		myatom = A
		maxlength = cablelen

	proc/doProcess()
		cull_wires()
		render()

	proc/cull_wires()
		for(var/outnode in outputs)
			var/datum/wirenode/O = outputs[outnode]

			if(O.wirelength() > maxlength)
				//world << "culling wire with length [O.wirelength()] > [maxlength]"

				O.disconnect()

		for(var/innode in inputs)
			var/datum/wirenode/I = inputs[innode]

			if(I.wirelength() > maxlength)
				//world << "culling wire with length [I.wirelength()] > [maxlength]"

				I.disconnect()

	//For dynamically changing inputs and outputs
	proc/add_input(input)
		if(inputs[input])
			return

		inputs[input] = new /datum/wirenode(src,input,WIRE_INPUT)

	proc/remove_input(input)
		var/datum/wirenode/I = inputs[input]

		if(!I)
			return

		I.disconnect()
		inputs.Remove(input)

	proc/add_output(output)
		if(outputs[output])
			return

		outputs[output] = new /datum/wirenode(src,output,WIRE_OUTPUT)

	proc/remove_output(output)
		var/datum/wirenode/O = outputs[output]

		if(!O)
			return

		O.disconnect()
		outputs.Remove(output)

	//Wiring up outputs
	proc/wire_output(output,var/datum/wiremodule/other,input)
		if(!other)
			return

		var/datum/wirenode/O = outputs[output]
		var/datum/wirenode/I = other.inputs[input]

		if(O && I)
			O.connect(I)

	proc/unwire_output(output)
		var/datum/wirenode/O = outputs[output]

		if(O)
			O.disconnect()

	proc/wire_input(input,var/datum/wiremodule/other,output)
		if(!other)
			return

		var/datum/wirenode/O = inputs[input]
		var/datum/wirenode/I = other.outputs[output]

		if(O && I)
			I.connect(O)

	proc/unwire_input(input)
		var/datum/wirenode/I = inputs[input]

		if(I)
			I.disconnect()

	proc/set_wiresignal(output,signal)
		var/datum/wirenode/O = outputs[output]

		if(O)
			O.set_value(signal)

	proc/receive_wiresignal(input)
		var/datum/wirenode/I = inputs[input]

		if(I)
			return I.get_value()

	proc/pulse_wiresignal(input)
		myatom.receive_wiresignal(input,receive_wiresignal(input),TRUE)

	proc/render()
		for(var/image/I in cableimages)
			del(I)

		cableimages.Cut()

		for(var/outnode in outputs)
			var/datum/wirenode/O = outputs[outnode]
			var/datum/wirenode/I = O.connected

			if(I && O)
				render_wire(I.parent,"wire_out")

		for(var/innode in inputs)
			var/datum/wirenode/I = inputs[innode]
			var/datum/wirenode/O = I.connected

			if(I && O)
				render_wire(O.parent,"wire_in")

		for(var/client/C)
			C.images |= cableimages

	proc/render_wire(var/datum/wiremodule/enddevice,iconstate,color = "#FF00FF")
		var/atom/origin = src.myatom
		var/atom/terminus = enddevice.myatom

		if(!origin || !terminus)
			return

		var/angle = get_angle(origin,terminus)
		var/dist = get_dist_euclidian(origin,terminus)

		var/image/I = image('wire.dmi',origin,iconstate,10000)
		I.color = color
		var/matrix/trans = matrix()
		I.transform = trans.Turn(angle-90)
		I.blend_mode = BLEND_ADD
		if(dist != 0)
			I.pixel_x = ((terminus.x - origin.x) / dist) * 16
			I.pixel_y = ((terminus.y - origin.y) / dist) * 16
		else
			I.icon_state = "wire_connect"

		cableimages += I

