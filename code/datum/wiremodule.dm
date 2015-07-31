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

	var/pixel_x = 16
	var/pixel_y = 16

	New(var/datum/wiremodule/parent,name,mode,pixel_x = 16,pixel_y = 16,color = "#FFFFFF")
		src.parent = parent
		src.name = name
		src.mode = mode

		src.pixel_x = pixel_x
		src.pixel_y = pixel_y

		//wirecolor = HSVtoRGB(hsv(AngleToHue(rand(360)),255,128))
		wirecolor = color

	proc/set_value(newvalue)
		if(mode == WIRE_OUTPUT)
			value = newvalue

			//world << "setting [connected] to [newvalue]"

			if(connected.len)
				for(var/datum/wirenode/N in connected)
					if(N && N.value != newvalue)
						N.value = newvalue
						N.pulse()

	proc/get_value()
		if(!connected.len)
			return 0

		if(mode == WIRE_INPUT)
			var/datum/wirenode/N = connected[1]
			return N.value

	proc/pulse()
		parent.pulse_wiresignal(name)

	proc/connect(var/datum/wirenode/othernode,var/direct = 1)
		if(othernode == src) //ARE YOU FUCK!?
			return

		if(!othernode || othernode.mode == src.mode)
			return

		//Do not attach more than one wire to inputs :V
		if(mode == WIRE_INPUT && connected.len)
			//world << "disconnecting superfluous input nodes"

			disconnect_all()

		connected |= othernode
		set_value(value)

		if(direct)
			othernode.connect(src,0)

	proc/disconnect(var/datum/wirenode/othernode,var/direct = 1)
		if(!othernode)
			return

		//if(connected)
		//	disconnect()

		set_value(0)
		connected -= othernode

		if(direct)
			othernode.disconnect(src,0)
			//world << "\ref[src] active disconnect"
		else
			//world << "\ref[src] passive disconnect"

	proc/disconnect_all(var/direct = 1)
		set_value(0)

		if(connected.len && direct)
			for(var/datum/wirenode/otherN)
				otherN.disconnect(src,0)

		//if(direct)
			//world << "[name] active disconnect"

		connected.Cut()

		//world << "node disconnected"

	proc/wirelength(var/datum/wirenode/othernode)
		if(!connected || !(othernode in connected))
			return 0

		var/atom/origin = get_outermost_atom(parent.myatom)
		var/atom/terminus = get_outermost_atom(othernode.parent.myatom)

		return get_dist_euclidian(origin,terminus)

	proc/totalx()
		if(!parent || !parent.myatom)
			return

		var/atom/A = get_outermost_atom(parent.myatom)

		return A.x * 32 + A.pixel_x + pixel_x

	proc/totaly()
		if(!parent || !parent.myatom)
			return

		var/atom/A = get_outermost_atom(parent.myatom)

		return A.y * 32 + A.pixel_y + pixel_y

datum/wiremodule
	var/atom/myatom

	var/maxlength = 8 //How far the wire reaches, too long and it will cull.

	var/list/datum/wirenode/outputs = list() //Reference to wire objects connected to outputs
	var/list/datum/wirenode/inputs = list() //Reference to wire objects connected to inputs

	var/list/cableimages = list()
	var/list/usedimages = list()

	var/wires/renderobj
	var/list/clientlist = list()

	New(var/atom/A,cablelen = 8)
		myatom = A
		maxlength = cablelen

		renderobj = new(myatom.loc)

	proc/doProcess()
		cull_wires()
		//render()
		renderobj.Move(get_turf(myatom))

	proc/cull_wires()
		for(var/outnode in outputs)
			var/datum/wirenode/O = outputs[outnode]

			for(var/datum/wirenode/N in O.connected)
				if(O.wirelength(N) > maxlength)
					O.disconnect(N)

		for(var/innode in inputs)
			var/datum/wirenode/I = inputs[innode]

			for(var/datum/wirenode/N in I.connected)
				if(I.wirelength(N) > maxlength)
					I.disconnect(N)

	//For dynamically changing inputs and outputs
	proc/add_input(input,pixel_x = 16,pixel_y = 16,color = "#FFFFFF")
		if(inputs[input])
			return

		inputs[input] = new /datum/wirenode(src,input,WIRE_INPUT,pixel_x,pixel_y,color)

	proc/move_input(input,pixel_x = 16,pixel_y = 16)
		var/datum/wirenode/I = inputs[input]

		if(!I)
			return

		I.pixel_x = pixel_x
		I.pixel_y = pixel_y

	proc/remove_input(input)
		var/datum/wirenode/I = inputs[input]

		if(!I)
			return

		I.disconnect_all()
		inputs.Remove(input)

	proc/add_output(output,pixel_x = 16,pixel_y = 16,color = "#FFFFFF")
		if(outputs[output])
			return

		outputs[output] = new /datum/wirenode(src,output,WIRE_OUTPUT,pixel_x,pixel_y,color)

	proc/move_output(output,pixel_x = 16,pixel_y = 16)
		var/datum/wirenode/O = outputs[output]

		if(!O)
			return

		O.pixel_x = pixel_x
		O.pixel_y = pixel_y

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
			O.connect(I)

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


	//TODO
	// DE-LAG THIS SHIT
	proc/render()
		//if(cableimages.len)
		//	return

		for(var/client/C in clientlist)
			for(var/refname in cableimages)
				if(refname in usedimages)
					continue

				var/image/I = cableimages[refname]

				C.images -= I
				cableimages.Remove(refname)

		usedimages.Cut()
		clientlist.Cut()

		var/list/nodes_to_render = list()

		for(var/outnode in outputs)
			var/datum/wirenode/O = outputs[outnode]
			//var/datum/wirenode/I = O.connected

			var/wirealpha = min(255,255 * (O.value+0.3))

			if(O.connected.len)
				for(var/datum/wirenode/N in O.connected)
					//render_wire(N.parent,"wire_out",O.wirecolor)
					render_wire(O,N,"wire_out",O.wirecolor,wirealpha)
			else
				nodes_to_render += O

		for(var/innode in inputs)
			var/datum/wirenode/I = inputs[innode]

			var/wirealpha = min(255,255 * (I.get_value()+0.3))
			//var/datum/wirenode/O = I.connected

			if(I.connected.len)
				for(var/datum/wirenode/N in I.connected)
					//render_wire(N.parent,"wire_in",N.wirecolor)
					render_wire(I,N,"wire_in",N.wirecolor,wirealpha)
			else
				nodes_to_render += I

		for(var/datum/wirenode/N in nodes_to_render)
			var/refname = "node_\ref[N]"
			var/image/I = cableimages[refname]

			usedimages += refname

			var/animate_steps = 10

			if(!I)
				I = image('sprite/obj/wire.dmi',renderobj,"wire_node",10000)
				cableimages[refname] = I
				animate_steps = 0

			animate(I,color = N.wirecolor, pixel_x = N.pixel_x - 16,pixel_y = N.pixel_y - 16,animate_steps)
			//I.color = N.wirecolor
			//I.pixel_x = N.pixel_x - 16
			//I.pixel_y = N.pixel_y - 16

		for(var/mob/M in viewers(world.view,renderobj))
			var/client/C = M.client

			if(!C)
				continue

			for(var/refname in cableimages)
				C.images |= cableimages[refname]

			clientlist |= M

	proc/render_wire(var/datum/wirenode/beginnode,var/datum/wirenode/endnode,iconstate,color = "#FF00FF",wirealpha = 255)
		var/datum/wiremodule/enddevice = endnode.parent

		if(!enddevice)
			return

		var/atom/origin = src.myatom
		var/atom/terminus = enddevice.myatom

		var/origin_x = beginnode.totalx()
		var/origin_y = beginnode.totaly()

		var/terminus_x = endnode.totalx()
		var/terminus_y = endnode.totaly()

		if(!origin || !terminus)
			return

		var/delta_x = terminus_x - origin_x
		var/delta_y = terminus_y - origin_y

		var/angle = vector2angle(delta_x,delta_y)
		var/dist = sqrt(delta_x ** 2 + delta_y ** 2)

		var/refname1 = "wire_\ref[beginnode]_\ref[endnode]"
		var/refname2 = "wirenode_\ref[beginnode]_\ref[endnode]"

		var/image/I1 = cableimages[refname1]

		if(!I1)
			I1 = image('sprite/obj/wire.dmi',renderobj,iconstate,10000)
			cableimages[refname1] = I1
		I1.color = color
		var/matrix/trans = matrix()
		trans.Scale(dist/(32*2),0.5)
		I1.transform = trans.Turn(angle-90)
		I1.blend_mode = BLEND_ADD
		I1.alpha = wirealpha

		var/pixx = beginnode.pixel_x - 16
		var/pixy = beginnode.pixel_y - 16

		if(dist != 0)
			pixx = beginnode.pixel_x - 16 + delta_x / 4
			pixy = beginnode.pixel_y - 16 + delta_y / 4
		else
			I1.icon_state = "wire_connect"

		I1.pixel_x = pixx
		I1.pixel_y = pixy

		//animate(I1,color = color, transform = trans.Turn(angle-90),alpha = wirealpha,pixel_x = pixx,pixel_y = pixy,animate_steps)

		var/image/I2 = cableimages[refname2]

		if(!I2)
			I2 = image('sprite/obj/wire.dmi',renderobj,"wire_connect",10000)
			cableimages[refname2] = I2
		I2.pixel_x = beginnode.pixel_x - 16
		I2.pixel_y = beginnode.pixel_y - 16
		I2.blend_mode = BLEND_ADD
		I2.alpha = wirealpha
		I2.color = color

		usedimages += refname1
		usedimages += refname2



/*	proc/render_wire(var/datum/wiremodule/enddevice,iconstate,color = "#FF00FF",pixel_x = 16,pixel_y = 16)
		var/atom/origin = src.myatom
		var/atom/terminus = enddevice.myatom

		if(!origin || !terminus)
			return

		var/angle = get_angle(origin,terminus)
		var/dist = get_dist_euclidian(origin,terminus)

		var/image/I1 = image('wire.dmi',renderobj,iconstate,10000)
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

		var/image/I2 = image('wire.dmi',renderobj,"wire_connect",10000)
		I2.pixel_x = ((terminus.x - origin.x) / dist) * 8
		I2.pixel_y = ((terminus.y - origin.y) / dist) * 8
		I2.blend_mode = BLEND_ADD
		I2.color = color

		cableimages += I1
		cableimages += I2*/

wires
	name = null
	parent_type = /obj

	//name = ""

	icon = null
	icon_state = null

	mouse_opacity = 0

