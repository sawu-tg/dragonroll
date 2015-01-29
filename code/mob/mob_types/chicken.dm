/mob/player/npc/chicken
	name = "Chicken"
	desc = "You wonder where it came from."
	icon_state = "chicken_white"
	icon = 'sprite/mob/animal.dmi'

/mob/player/npc/chicken/New()
	..()
	icon_state = "chicken_[pick("white","black","brown")]"