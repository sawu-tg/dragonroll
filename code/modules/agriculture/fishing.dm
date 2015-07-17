/obj/item/weapon/tool/fishingrod
	name = "Fishing Rod"
	desc = "A bit of string tied around a stick."
	icon_state = "chain"
	loot_icon_state = "fishingrod"
	loot_icon = 'sprite/obj/weapons.dmi'
	helpInfo = "Use this on water to cast out a line, and reel in various aquatic life!"
	var/obj/item/bait
	var/obj/fishingbouy/bouy
	range = 5
	var/length = 50
	var/fish_given = 1
	var/list/fishables = list(/obj/item/food/fish/minnow,
							/obj/item/food/fish/sardine,
							/obj/item/food/fish/herring,
							/obj/item/food/fish/pike)
	var/fishing = FALSE
	var/cast_message = "You cast out a line!"
	var/catch_message = "You reel in "
/obj/item/weapon/tool/fishingrod/onUsed(var/mob/player/user,var/atom/onWhat)
	if(fishing)
		return
	if(istype(onWhat,/turf/floor/outside/liquid))
		messageInfo(cast_message,user,src)
		bouy = new/obj/fishingbouy(get_turf(onWhat))
		spawn(1)
			bouy.Beam(get_turf(src),time=length,icon_state="f_beam")
		var/sleep_length = length / fish_given
		fishing = TRUE
		for(var/i = 0; i < fish_given; ++i)
			sleep(sleep_length)
			var/list/picked_fish = list()
			for(var/F in fishables)
				var/obj/item/food/fish/FF = new F()
				if(user.playerData.fishing.statModified >= FF.required_level_fishing)
					picked_fish.Add(F)
					sdel(FF)
			if(!picked_fish.len) // not pro enough to catch anything.
				messageInfo("You fail to catch anything.",user,src)
				fishing = FALSE
				sdel(bouy)
				return
			var/obj/item/food/fish/catchType = pick(picked_fish)
			var/obj/item/food/fish/caught = new catchType(get_turf(src),user.playerData.fishing.statModified)
			user.playerData.fishing.addxp(caught.exp_granted_fishing, user)
			messageInfo("[catch_message][caught].",user,src)
		messageInfo("You finish fishing.",user,src)
		giveMedal("The Deeps",user)
		fishing = FALSE
		sdel(bouy)

/obj/item/weapon/tool/fishingrod/net
	name = "Fishing Net"
	desc = "A net for fishing."
	range = 1
	length = 50
	fish_given = 5
	loot_icon_state = "fishingnet"
	fishables = list(/obj/item/food/fish/shrimp,
					/obj/item/food/fish/anchovies,
					/obj/item/food/fish/monkfish)
	cast_message = "You set the net in the water!"
	catch_message = "You catch "

/obj/item/weapon/tool/fishingrod/cage
	name = "Fishing Cage"
	desc = "A cage for fishing."
	range = 1
	length = 50
	fish_given = 5
	loot_icon_state = "fishingcage"
	fishables = list(/obj/item/food/fish/crayfish,
					/obj/item/food/fish/lobster)
	cast_message = "You set the cage in the water!"
	catch_message = "You catch a "

/obj/item/weapon/tool/fishingrod/net/big
	name = "Big Fishing Net"
	desc = "A net for fishing."
	fish_given = 3
	loot_icon_state = "fishingnet"
	fishables = list(/obj/item/food/fish/mackerel,
					/obj/item/food/fish/cod,
					/obj/item/food/fish/bass)
	cast_message = "You set the big net in the water!"
	catch_message = "You catch a "

/obj/item/weapon/tool/fishingrod/harpoon
	name = "Harpoon"
	desc = "A harpoon for fishing."
	length = 30
	fish_given = 3
	loot_icon_state = "spearglass1"
	fishables = list(/obj/item/food/fish/tuna,
					/obj/item/food/fish/swordfish,
					/obj/item/food/fish/shark,
					/obj/item/food/fish/great_white_shark,
					/obj/item/food/fish/sponge)
	cast_message = "You start harpooning the water!"
	catch_message = "You harpoon a "

/obj/item/weapon/tool/fishingrod/fly
	name = "Fly Fishing Rod"
	desc = "A rod for fly fishing."
	length = 30
	fish_given = 1
	fishables = list(/obj/item/food/fish/trout,
					/obj/item/food/fish/salmon,
					/obj/item/food/fish/rainbow_fish)
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
	helpInfo = "You can cook this over a fire for a tasty treat, but be careful of poisonous food!"
	var/randColour = TRUE
	var/required_level_fishing = 1
	var/exp_granted_fishing = 1

/obj/item/food/fish/New()
	..()
	if(randColour)
		color = rgb(rand(20,255),rand(20,255),rand(20,255))
	var/extraType = pick(/datum/reagent/nutrients,/datum/reagent/rawess,/datum/reagent/toxin/paratoxin,/datum/reagent/toxin/neurotoxin,/datum/reagent/toxin/suffocatetoxin)
	var/datum/reagent/RE = new extraType
	reagents.addliquid(RE.id, rand(1,5))
	for(var/datum/reagent/R in reagents.liquidlist)
		if(R.id == "ntox" || R.id == "ptox" || R.id == "stox")
			name = "[pick("Bitter","Sour","Infected","Sick")] [name]"
		if(R.id == "rawess")
			name = "Fey [name]"
