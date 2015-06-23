/obj/item/weapon/tool/fishingrod
	name = "Fishing Rod"
	desc = "A bit of string tied around a stick."
	icon_state = "fishingrod"
	var/obj/item/bait
	var/obj/fishingbouy/bouy
	range = 5
	var/length = 50
	var/fish_given = 1
	var/list/fishables = list(/obj/item/food/fish/minnow = 25,
							/obj/item/food/fish/sardine = 25,
							/obj/item/food/fish/herring = 25,
							/obj/item/food/fish/pike = 25)
	var/fishing = FALSE
	var/cast_message = "You cast out a line!"
	var/catch_message = "You reel in "
/obj/item/weapon/tool/fishingrod/onUsed(var/mob/player/user,var/atom/onWhat)
	if(fishing)
		return
	if(istype(onWhat,/turf/floor/outside/liquid))
		messageInfo(cast_message,user,src)
		bouy = new/obj/fishingbouy(get_turf(onWhat))
		Beam(bouy,time=length,icon_state="f_beam")
		var/sleep_length = length / fish_given
		fishing = TRUE
		for(var/i = 0; i < fish_given; ++i)
			sleep(sleep_length)
			var/list/picked_fish = fishables
			for(var/obj/item/food/fish/F in fishables)
				if(F.required_level_fishing > user.playerData.fishing.statCurr)
					picked_fish -= F
			if(!picked_fish.len) // not pro enough to catch anything.
				messageInfo("You fail to catch anything.",user,src)
				return
			var/obj/item/food/fish/catchType = pickweight(picked_fish)
			var/obj/item/food/fish/catch = new catchType(get_turf(user))
			user.playerData.fishing.addxp(catch.exp_granted_fishing, user)
			messageInfo("[catch_message][catch].",user,src)
		messageInfo("You finish fishing.",user,src)
		fishing = FALSE
		sdel(bouy)

/obj/item/weapon/tool/fishingrod/net
	name = "Fishing Net"
	desc = "A net for fishing."
	range = 1
	length = 50
	fish_given = 5
	fishables = list(/obj/item/food/fish/shrimp = 33,
					/obj/item/food/fish/anchovies = 33,
					/obj/item/food/fish/monkfish = 33)
	cast_message = "You set the net in the water!"
	catch_message = "You catch "

/obj/item/weapon/tool/fishingrod/cage
	name = "Crayfish Cage"
	desc = "A cage for fishing."
	range = 1
	length = 50
	fish_given = 5
	fishables = list(/obj/item/food/fish/crayfish = 100)
	cast_message = "You set the cage in the water!"
	catch_message = "You catch a "

/obj/item/weapon/tool/fishingrod/net/big
	name = "Big Fishing Net"
	desc = "A net for fishing."
	fish_given = 3
	fishables = list(/obj/item/food/fish/mackerel = 33,
					/obj/item/food/fish/cod = 33,
					/obj/item/food/fish/bass = 33)
	cast_message = "You set the big net in the water!"
	catch_message = "You catch a "

/obj/item/weapon/tool/fishingrod/harpoon
	name = "Harpoon"
	desc = "A harpoon for fishing."
	length = 30
	fish_given = 3
	fishables = list(/obj/item/food/fish/tuna = 25,
					/obj/item/food/fish/swordfish = 25,
					/obj/item/food/fish/shark = 25,
					/obj/item/food/fish/great_white_shark = 25)
	cast_message = "You start harpooning the water!"
	catch_message = "You harpoon a "

/obj/item/weapon/tool/fishingrod/fly
	name = "Fly Fishing Rod"
	desc = "A rod for fly fishing."
	length = 30
	fish_given = 1
	fishables = list(/obj/item/food/fish/trout = 33,
					/obj/item/food/fish/salmon = 33,
					/obj/item/food/fish/rainbow_fish = 33)
	cast_message = "You start fly fishing!"
	catch_message = "You catch a "

/obj/fishingbouy
	name = "Fishing Bouy"
	desc = "Dynamic fish attracting powers!"
	icon_state = "effect_bouy"
	icon = 'sprite/obj/effects.dmi'
// FISHIES GLUB GLUB
/obj/item/food/fish
	name = "Fish"
	desc = "Floats and glubs."
	icon = 'sprite/obj/fish.dmi'
	icon_state = "fish"
	var/randColour = TRUE
	var/required_level_fishing = 1
	var/exp_granted_fishing = 1

/obj/item/food/fish/New()
	..()
	if(randColour)
		color = rgb(rand(20,255),rand(20,255),rand(20,255))
	if(prob(10))
		var/extraType = pick(/datum/reagent/nutrients,/datum/reagent/rawess,/datum/reagent/paratoxin,/datum/reagent/neurotoxin,/datum/reagent/suffocatetoxin)
		var/datum/reagent/RE = new extraType
		reagents.addliquid(RE.id, rand(1,5))
		for(var/datum/reagent/R in reagents.liquidlist)
			if(R.id == "ntox" || R.id == "ptox" || R.id == "stox")
				name = "[pick("Bitter","Sour","Infected","Sick")] [name]"
			if(R.id == "rawess")
				name = "Fey [name]"