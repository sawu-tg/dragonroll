/obj/item/weapon/tool/fishingrod
	name = "Fishing Rod"
	desc = "A bit of string tied around a stick."
	icon_state = "fishingrod"
	var/obj/item/bait
	var/obj/effect/fishingbouy/bouy
	range = 5

/obj/item/weapon/tool/fishingrod/onUsed(var/mob/user,var/atom/onWhat)
	if(istype(onWhat,/turf/floor/outside/liquid))
		if(bouy)
			return
		messageInfo("You cast out a line!",user,src)
		bouy = new/obj/effect/fishingbouy(get_turf(onWhat),user,bait)


/obj/effect/fishingbouy
	name = "Fishing Bouy"
	desc = "Dynamic fish attracting powers!"
	icon_state = "effect_bouy"
	length = 30
	var/fishGiven = 1
	var/mob/player/fisherman

/obj/effect/fishingbouy/New(var/turf/atloc,var/owner,var/bait)
	..(atloc)
	fisherman = owner
	spawn(1)
		Beam(owner,time=length,icon_state="f_beam")

/obj/effect/fishingbouy/onDestroy()
	if(fishGiven > 0)
		var/A = get_turf(src)
		var/catchType = pickweight(A:fishables)
		var/caught = new catchType(get_turf(fisherman))
		fisherman.playerData.fishing.change(1)
		messageInfo("You reel in a [caught]",fisherman,src)
		--fishGiven
	..()

/turf/floor/outside/liquid
	var/list/fishables = list(/obj/item/food/fish = 50, /obj/item/food/fish/squid = 50, /obj/item/food/fish/urchin = 25, /obj/item/food/fish/clam = 25, /obj/item/food/fish/shrimp = 75,/obj/item/food/fish/lobster = 15,/obj/item/food/fish/crab = 15, /obj/item/food/fish/sponge = 5)


///
// FISHIES GLUB GLUB
///

/obj/item/food/fish
	name = "Fish"
	desc = "Floats and glubs."
	icon = 'sprite/obj/fish.dmi'
	icon_state = "fish"
	var/randColour = TRUE

/obj/item/food/fish/New()
	..()
	if(randColour)
		color = rgb(rand(20,255),rand(20,255),rand(20,255))
	var/extraType = pick(/datum/reagent/nutrients,/datum/reagent/rawess,/datum/reagent/paratoxin,/datum/reagent/neurotoxin,/datum/reagent/suffocatetoxin)
	var/datum/reagent/RE = new extraType
	reagents.addliquid(RE.id, rand(1,5))
	for(var/datum/reagent/R in reagents.liquidlist)
		if(R.id == "ntox" || R.id == "ptox" || R.id == "stox")
			name = "[pick("Bitter","Sour","Infected","Sick")] [name]"
		if(R.id == "rawess")
			name = "Fey [name]"

/obj/item/food/fish/squid
	name = "Squid"
	desc = "Bobs and Blibs."
	icon_state = "squid"

/obj/item/food/fish/urchin
	name = "Urchin"
	desc = "Like a sea-mine."
	icon_state = "urchin"

/obj/item/food/fish/clam
	name = "Clam"
	desc = "Portable sea-food in it's own packaging."
	icon_state = "clam"

/obj/item/food/fish/shrimp
	name = "Shrimp"
	desc = "It's other home is a barbeque."
	icon_state = "shrimp"

/obj/item/food/fish/lobster
	name = "Lobster"
	desc = "Pinchy!"
	icon_state = "lobster"

/obj/item/food/fish/crab
	name = "Crab"
	desc = "Pinchy Jr."
	icon_state = "crab"

/obj/item/food/fish/sponge
	name = "Sponge"
	desc = "Are you feeling it now Mr Krabs?"
	icon_state = "bob"
	randColour = FALSE


/obj/item/food/fish/sponge/New()
	..()
	var/matrix/M = matrix(transform)
	M.Turn(rand(1,360))
	transform = M