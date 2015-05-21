#define WIRETOOL_IDLE 0
#define WIRETOOL_SELECT_NODE1 1
#define WIRETOOL_NODE1 2
#define WIRETOOL_SELECT_NODE2 3
#define WIRETOOL_NODE2 4

/obj/item/powerdevice/wiretool
	name = "wiretool"
	desc = "Generates wires between wireable components"

	icon = 'sprite/obj/wire.dmi'
	icon_state = "wiretool"

	var/datum/wirenode/node1
	var/datum/wirenode/node2
	var/mode = WIRETOOL_IDLE

/obj/item/powerdevice/wiretool/proc/default_wire_action(var/mob/user,var/datum/wiremodule/wires)
	if(!user || !wires)
		return

	switch(mode)
		if(WIRETOOL_IDLE)
			node1 = begin_selection(user,wires.myatom,wires.inputs)

			if(node1)
				mode = WIRETOOL_NODE1
		if(WIRETOOL_NODE1)
			node2 = begin_selection(user,wires.myatom,wires.outputs)

			if(node2)
				mode = WIRETOOL_NODE2

				wire_up(user)

/obj/item/powerdevice/wiretool/objFunction(var/mob/user,var/obj/item/with)
	if(!user)
		return

	if(with)
		return ..()

	clear()

/obj/item/powerdevice/wiretool/proc/clear()
	node1 = null
	node2 = null
	mode = WIRETOOL_IDLE

/obj/item/powerdevice/wiretool/proc/wire_up(var/mob/user)
	if(!node1 || !node2)
		return

	user << "You wire [node1.parent.myatom] up to [node2.parent.myatom]"

	node1.connect(node2)

	clear()

/obj/item/powerdevice/wiretool/proc/begin_selection(var/mob/user,var/atom/wireobj,var/list/wirenodes)
	if(!user || !wirenodes || !wireobj)
		return

	if(!wirenodes.len)
		user << "[wireobj] doesn't have any wires."
		return

	var/chosennode = input(user,"Choose a node to wire.","Wiretool",null) in wirenodes

	return wirenodes[chosennode]