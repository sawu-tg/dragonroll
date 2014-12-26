/obj/furniture
	name = "furniture"
	desc = "don't sit on me.. maybe"
	icon = 'sprite/furniture.dmi'

/obj/furniture/chest
	name = "Chest"
	desc = "Contains Loot, most of the time."
	icon_state = "chest_close"
	var/chestOpen = 0

/obj/furniture/chest/objFunction(var/mob/user)
	chestOpen = !chestOpen
	displayInfo("You [chestOpen ? "open" : "close"] the [src]","[user] [chestOpen ? "opens" : "closes"] the [src]",user,src)
	icon_state = "chest[chestOpen ? "_open" : "_close"]"

//OVER/UNDERLAYS
/obj/furniture/overlay
	name = "overlay object"
	layer = MOB_LAYER + 1

/obj/furniture/underlay
	name = "underlay object"
	layer = MOB_LAYER - 1

/obj/furniture/underlay/bed/bedframe
	name = "Bed frame"
	desc = "The frame of a wooden bed."
	icon_state = "bedframe"

/obj/furniture/underlay/bed
	name = "Bed"
	desc = "A light grey bed."
	icon_state = "bed"

/obj/furniture/overlay/bed/bedsheet
	name = "Bed sheet"
	desc = "A white sheet."
	icon_state = "bedsheet"

/obj/furniture/underlay/bed/pillow
	name = "Pillow"
	desc = "A white pillow."
	icon_state = "pillow"

/obj/furniture/overlay/bed/blanket
	name = "Blanket"
	desc = "A heavy white blanket."
	icon_state = "blanket"

//misc furniture

/obj/furniture/table
	name = "generic table"
	density = 1

/obj/furniture/table/wooden
	name = "Wooden table"
	desc = "A round wooden table."
	icon_state = "table"

/obj/furniture/seat
	name = "generic seat"
	var/seatArms = 0

/obj/furniture/seat/New()
	if(seatArms)
		var/image/arms = image('sprite/furniture.dmi',"[icon_state]_top")
		arms.layer = MOB_LAYER + 1
		overlays.Add(arms)

/obj/furniture/seat/stool
	name = "Red stool"
	desc = "A red stool for sitting."
	icon_state = "rstool"

/obj/furniture/seat/chair
	name = "Metal chair"
	desc = "A metallic chair."
	icon_state = "chair"
	seatArms = 1

/obj/furniture/seat/chair/office
	name = "Metal office chair"
	desc = "A metallic office chair with white padding."
	icon_state = "officechair_white"

/obj/furniture/seat/chair/office/grey
	name = "Metal office chair"
	desc = "A metallic office chair with grey padding."
	icon_state = "officechair_dark"

/obj/furniture/seat/chair/podchair
	name = "Metal pod chair"
	desc = "A metallic pod chair"
	icon_state = "podchair"

/obj/furniture/seat/chair/comfy/
	name = "Black comfy chair"
	desc = "A nice chair to relax in."
	icon_state = "comfychair_black"

/obj/furniture/seat/chair/comfy/beige
	name = "Beige comfy chair"
	desc = "A nice chair to relax in."
	icon_state = "comfychair_beige"

/obj/furniture/seat/chair/comfy/lime
	name = "Lime comfy chair"
	desc = "A nice chair to relax in."
	icon_state = "comfychair_lime"

/obj/furniture/seat/chair/comfy/teal
	name = "Teal comfy chair"
	desc = "A nice chair to relax in."
	icon_state = "comfychair_teal"

