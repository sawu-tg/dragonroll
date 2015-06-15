/obj/structure/pipe_node
	name = "liquid pipe node"
	icon = 'sprite/obj/alchemy/pipes.dmi'
	icon_state = "node"
	density = 0
	opacity = 0

	var/list/connectedpipes = list()
	var/pipeid
	var/maxrange = 6

/obj/structure/pipe_node/New()
	..()

	reagents = new(src,1000)

	addProcessingObject(src)

/obj/structure/pipe_node/proc/linkTo(var/obj/structure/pipe_node/other)
	if(!other || isConnectedTo(other))
		return

	var/list/line = BresenhamLine(src,other)
	var/datum/liquidpipe/newpipe = new(src,other)

	for(var/turf/T in line)
		if(istype(T))
			var/obj/structure/pipe_segment/S = new(T)
			newpipe.segments += S

	src.connectedpipes |= newpipe
	other.connectedpipes |= newpipe

/obj/structure/pipe_node/proc/isConnectedTo(var/obj/structure/pipe_node/other)
	for(var/datum/liquidpipe/pipe in connectedpipes)
		if(pipe.node1 == other || pipe.node2 == other)
			return TRUE

	return FALSE