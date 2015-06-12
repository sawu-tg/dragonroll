/datum/liquidpipe
	var/obj/structure/pipe_node/node1
	var/obj/structure/pipe_node/node2
	var/list/segments = list()

	var/volume = 0
	var/freedirections = PIPE_NODE1 | PIPE_NODE2 //If it contains the PIPE_NODE1 flag, it means that liquid can flow to node 1.

/datum/liquidpipe/New(var/obj/structure/pipe_node/n1,var/obj/structure/pipe_node/n2)
	node1 = n1
	node2 = n2

/datum/liquidpipe/proc/update()
	for(var/obj/structure/pipe_segment/segment in segments)
		volume += segment.volume

		if(istype(segment,/obj/structure/pipe_segment/oneway))
			freedirections &= ~segment:forbiddendir

	return

/datum/liquidpipe/proc/canPush(var/originnode,var/volume)
	if(originnode == node1)
		return (freedirections & PIPE_NODE2) > 0
	if(originnode == node2)
		return (freedirections & PIPE_NODE1) > 0

	return FALSE