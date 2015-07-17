/obj/furniture
	name = "furniture"
	desc = "don't sit on me.. maybe"
	icon = 'sprite/world/furniture.dmi'
	size = 3
	weight = 5
	prevent_pickup = 1
/obj/item/furniture
	//items for furniture, pillows etc
	name = "furniture item"
	desc = "beat someone with me"
	icon = 'sprite/world/furniture.dmi'
	size = 1
	weight = 1

/obj/furniture/chest
	name = "Chest"
	desc = "Contains Loot, most of the time."
	icon_state = "chest_close"
	var/chestOpen = 0

/obj/furniture/chest/objFunction(var/mob/user)
	chestOpen = !chestOpen
	messageArea("You [chestOpen ? "open" : "close"] the [src]","[user] [chestOpen ? "opens" : "closes"] the [src]",user,src)
	icon_state = "chest[chestOpen ? "_open" : "_close"]"

//OVER/UNDERLAYS
/obj/furniture/overlay
	name = "overlay object"
	layer = LAYER_OVERLAY

/obj/item/furniture/overlay
	name = "overlay object"
	layer = LAYER_OVERLAY
	showAsLoot = FALSE

/obj/furniture/underlay
	name = "underlay object"
	layer = LAYER_UNDERLAY

/obj/item/furniture/underlay
	name = "underlay object"
	layer = LAYER_UNDERLAY
	showAsLoot = FALSE

/obj/furniture/underlay/bed/bedframe
	name = "Bed frame"
	desc = "The frame of a wooden bed."
	icon_state = "bedframe"

/obj/furniture/underlay/bed
	name = "Bed"
	desc = "A light grey bed."
	icon_state = "bed"

/obj/item/furniture/overlay/bedsheet
	name = "Bed sheet"
	desc = "A white sheet."
	icon_state = "bedsheet"

/obj/item/furniture/underlay/bed/pillow
	name = "Pillow"
	desc = "A white pillow."
	icon_state = "pillow"

/obj/item/furniture/overlay/bed/blanket
	name = "Blanket"
	desc = "A heavy white blanket."
	icon_state = "blanket"

//misc furniture

/obj/furniture/table
	name = "generic table"
	density = 1

/obj/furniture/table/objFunction(var/mob/user,var/obj/item/I)
	if(I)
		user.DropItem()
		I.loc = get_turf(src)

/obj/furniture/table/wooden
	name = "Wooden table"
	desc = "A round wooden table."
	icon_state = "table"

/obj/furniture/seat
	name = "generic seat"
	var/seatArms = 0

/obj/furniture/seat/objFunction(var/mob/user,var/obj/item/I)
	if(user)
		user.Move(get_turf(src))
		if(Adjacent(user))
			messageInfo("You take a seat on the [src]",user,src)
			user.dir = dir

/obj/furniture/seat/New()
	..()
	if(seatArms)
		var/image/arms = image('sprite/world/furniture.dmi',"[icon_state]_top")
		arms.layer = LAYER_OVERLAY
		overlays |= arms

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

/obj/item/furniture/underlay/comfyPillow
	name = "chair pillow"
	desc = "A large, comfortable pillow."
	icon_state = "comfychair_blackcushion"

/obj/furniture/seat/chair/comfy
	name = "Black comfy chair"
	desc = "A nice chair to relax in."
	icon_state = "comfychair_black"
	var/hasPillow = TRUE

/obj/furniture/seat/chair/comfy/verb/takePillow()
	set name = "Take Pillow"
	set category = "Objects"
	set src in oview(1)
	if(hasPillow)
		messageArea("You take the cushion from \the [src]","[usr] takes the cushion from \the [src]",usr,src)
		overlays |= image('sprite/world/furniture.dmi',icon_state="comfychair_nocushion",dir=dir)
		var/obj/item/furniture/underlay/comfyPillow/P = new(loc)
		P.icon_state = "[icon_state]_cushion"
		hasPillow = FALSE

/obj/furniture/seat/chair/comfy/verb/hideObject()
	set name = "Hide in Chair"
	set category = "Objects"

/obj/furniture/seat/chair/comfy/objFunction(var/mob/user,var/obj/item/I)
	if(I)
		messageArea("You hide \the [I] inside [src]","[user] slips something into [src]",user,src)
		user.DropItem()
		I.loc = src.loc
		I.layer = LAYER_HIDDEN
	else
		..(user)

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

///
// Structure Lights
///

/obj/furniture/light
	name = "Lantern"
	icon = 'sprite/obj/lighting.dmi'
	icon_state = "lantern-on"

/obj/furniture/light/New()
	..()
	set_light(7,1,"#FFFF66")