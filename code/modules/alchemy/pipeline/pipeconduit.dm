/obj/structure/pipe_segment
	name = "liquid pipe segment"
	icon = 'sprite/obj/alchemy/pipes.dmi'
	icon_state = "pipe"
	density = 0
	opacity = 0

	var/datum/liquidpipe/master
	var/volume = 10

/obj/structure/pipe_segment/oneway
	name = "one-way pipe segment"
	icon_state = "pipe"
	var/forbiddendir = 1

/obj/structure/pipe_segment/buffer
	name = "buffer pipe segment"
	icon_state = "pipe"
	volume = 200