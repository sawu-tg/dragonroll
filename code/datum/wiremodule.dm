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

	var/list/datum/wirenode/connected = list()
	var/wirecolor = "#FFFFFF"

	New(var/datum/wiremodule/parent,name,mode)
		src.parent = parent
		src.name = name
		src.mode = mode

		wirecolor = HSVtoRGB(hsv(AngleToHue(rand(360)),255,128))

	proc/set_value(newvalue)
		if(mode == WIRE_OUTPUT)
			value = newvalue

			//world << "setting [connected] to [newvalue]"

			if(connected.len)
				for(var/datum/wirenode/N in connected)
					if(N.value != newvalue)
						N.value = newvalue
						N.pulse()

	proc/get_value()
		if(!connected)
			return 0

		if(mode == WIRE_INPUT)
			var/datum/wirenode/N = connected[1]
			return N.value

	proc/pulse()
		parent.pulse_wiresignal(name)

	proc/connect(var/datum/wirenode/othernode,var/direct = 1)
		if(!othernode || othernode.mode == src.mode)
			return

		//if(connected)
		//	disconnect()

		connected |= othernode

		if(direct)
			othernode.connect(src,0)

	proc/disconnect(var/datum/wirenode/othernode,var/direct = 1)
		if(!othernode)
			return

		//if(connected)
		//	disconnect()

		connected -= othernode

		if(direct)
			othernode.disconnect(src,0)

	proc/disconnect_all(var/direct = 1)
		if(connected.len && direct)
			for(var/datum/wirenode/otherN)
				otherN.disconnect(src,0)

		value = 0
		connected.Cut()

		//world << "node disconnected"

	proc/wirelength(var/datum/wirenode/othernode)
		if(!connected || !(othernode in connected))
			return 0

		var/atom/origin = parent.myatom
		var/atom/terminus = othernode.parent.myatom

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

				O.disconnect_all()

		for(var/innode in inputs)
			var/datum/wirenode/I = inputs[innode]

			if(I.wirelength() > maxlength)
				//world << "culling wire with length [I.wirelength()] > [maxlength]"

				I.disconnect_all()

	//For dynamically changing inputs and outputs
	proc/add_input(input)
		if(inputs[input])
			return

		inputs[input] = new /datum/wirenode(src,input,WIRE_INPUT)

	proc/remove_input(input)
		var/datum/wirenode/I = inputs[input]

		if(!I)
			return

		I.disconnect_all()
		inputs.Remove(input)

	proc/add_output(output)
		if(outputs[output])
			return

		outputs[output] = new /datum/wirenode(src,output,WIRE_OUTPUT)

	proc/remove_output(output)
		var/datum/wirenode/O = outputs[output]

		if(!O)
			return

		O.disconnect_all()
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
			O.disconnect_all()

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
			I.disconnect_all()

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

		var/list/nodes_to_render = list()

		for(var/outnode in outputs)
			var/datum/wirenode/O = outputs[outnode]
			//var/datum/wirenode/I = O.connected

			if(O.connected.len)
				for(var/datum/wirenode/N in O.connected)
					render_wire(N.parent,"wire_out",O.wirecolor)
			else
				nodes_to_render += O

		for(var/innode in inputs)
			var/datum/wirenode/I = inputs[innode]
			//var/datum/wirenode/O = I.connected

			if(I.connected.len)
				for(var/datum/wirenode/N in I.connected)
					render_wire(N.parent,"wire_in",N.wirecolor)
			else
				nodes_to_render += I

		var/count = 0

		for(var/datum/wirenode/N in nodes_to_render)
			var/drawangle = 360 * count / nodes_to_render.len

			//world << "[drawangle] nodes to render"

			var/image/I = image('wire.dmi',myatom,"wire_node",10000)
			I.color = N.wirecolor
			I.pixel_x = sin(drawangle) * 10
			I.pixel_y = cos(drawangle) * 10

			cableimages += I

			count++

		for(var/client/C)
			C.images |= cableimages

	proc/render_wire(var/datum/wiremodule/enddevice,iconstate,color = "#FF00FF")
		var/atom/origin = src.myatom
		var/atom/terminus = enddevice.myatom

		if(!origin || !terminus)
			return

		var/angle = get_angle(origin,terminus)
		var/dist = get_dist_euclidian(origin,terminus)

		var/image/I1 = image('wire.dmi',origin,iconstate,10000)
		I1.color = color
		var/matrix/trans = matrix()
		trans.Scale((dist/2) * 0.75,0.5)
		I1.transform = trans.Turn(angle-90)
		I1.blend_mode = BLEND_ADD
		if(dist != 0)
			I1.pixel_x = ((terminus.x - origin.x) / dist) * (8+dist*32*0.75/4)
			I1.pixel_y = ((terminus.y - origin.y) / dist) * (8+dist*32*0.75/4)
		else
			I1.icon_state = "wire_connect"

		var/image/I2 = image('wire.dmi',origin,"wire_connect",10000)
		I2.pixel_x = ((terminus.x - origin.x) / dist) * 8
		I2.pixel_y = ((terminus.y - origin.y) / dist) * 8
		I2.blend_mode = BLEND_ADD
		I2.color = color

		cableimages += I1
		cableimages += I2

