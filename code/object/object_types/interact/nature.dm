/obj/interact/nature
	name = "nature thing"
	desc = "grows stuff"
	icon = 'sprite/world/ausflora.dmi'

/obj/interact/nature/bush
	name = "small bush"
	desc = "Needs a bit of a trim."

/obj/interact/nature/bush/New()
	icon_state = "grassybush_[rand(1,4)]"

/obj/interact/nature/rock
	name = "small rock"
	desc = "Do not bang your head on this."
	icon = 'sprite/world/rocks.dmi'

/obj/interact/nature/rock/New()
	icon_state = "rock[rand(1,5)]"