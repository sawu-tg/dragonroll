/datum/farmedGood
	var/name = "farm stuff"
	var/desc = "grown for you"
	var/list/grownItems = list()
	var/growthStages = 6
	var/lastGrowthTime = 0
	var/curGrowthStage = 1
	var/timePerStage = 130
	var/dropsProduce = FALSE

	var/icon = 'sprite/obj/hydroponics/growing.dmi'
	var/icon_state = ""


/turf/floor/outside/farm
	name = "Tilled Dirt"
	desc = "Ready for your seed!"
	icon_state = "farmed"
	var/datum/farmedGood/FG
	var/water = 0
	var/nutrients = 0
	helpInfo = "Use seeds on this tilled dirt to start growing fruits, vegetables and flowers!"

/turf/floor/outside/farm/New()
	..()
	updateArea()

/turf/floor/outside/farm/verb/DebugTurf()
	set src in view()
	if(!FG)
		return
	world << "Name: [FG.name]"
	world << "Desc: [FG.desc]"
	world << "Icon State: [FG.icon_state]"
	world << "Growth Stages: [FG.growthStages]"
	world << "Last Growth: [FG.lastGrowthTime]"
	world << "Current Time: [world.time]"
	world << "Time To Growth: [world.time - FG.lastGrowthTime]"
	world << "Current Stage: [FG.curGrowthStage]"
	world << "Time Per Stage: [FG.timePerStage]"
	world << "Processing?: [src in procObjects]"
	world << "Grows: "
	for(var/a in FG.grownItems)
		world << "[a]"

/turf/floor/outside/farm/proc/updateOverlay()
	icon_state = "farmed[water > 0 ? "_fed" : ""]"
	overlays.Cut()
	if(!FG)
		return
	var/icon/I = icon(FG.icon,icon_state="[FG.icon_state][FG.curGrowthStage <= FG.growthStages ? "-grow[FG.curGrowthStage]" : "-harvest"]")
	overlays += I

/turf/floor/outside/farm/proc/updateArea()
	water = 0
	for(var/turf/A in range(src,1))
		if(istype(A,/turf/floor/outside/liquid/water))
			water += A:depth/2

/turf/floor/outside/farm/proc/doHarvest(var/toWhere)
	if(!toWhere)
		toWhere = get_turf(src)
	for(var/a in FG.grownItems)
		for(var/b = 0; b < FG.grownItems[a]; b++)
			new a(toWhere)
	if(FG.dropsProduce)
		remProcessingObject(src)
		FG = null
	else
		FG.curGrowthStage = 0
		FG.lastGrowthTime = 0
	updateOverlay()
	updateArea()

/turf/floor/outside/farm/doProcess()
	if(!FG)
		return
	if(world.time > FG.lastGrowthTime)
		if(FG.curGrowthStage <= FG.growthStages)
			FG.curGrowthStage++
			FG.lastGrowthTime = world.time + (FG.timePerStage - ((water/4)*(nutrients/10)))
			updateArea()
		updateOverlay()

/turf/floor/outside/farm/objFunction(var/mob/user, var/obj/item/with)
	..()
	if(FG)
		if(FG.curGrowthStage >= FG.growthStages)
			doHarvest(get_turf(user))
	else
		if(istype(with,/obj/item/seedpack))
			FG = with:held_seed
			addProcessingObject(src)
			spawn(1)
				messageInfo("You plant the [FG.name].",user,src)
				user.DropItem()
				sdel(with)
		if(istype(with,/obj/item/food))
			nutrients += with:foodLevel
			messageInfo("You fertilize the soil with the [with.name].",user,src)
			spawn(1)
				user.DropItem()
				sdel(with)

///
// FARMING ITEMS
///
/obj/item/seedpack
	name = "seedpack"
	desc = "contains seeds"
	icon = 'sprite/obj/hydroponics/seeds.dmi'
	icon_state = "seed"
	helpInfo = "Use these seeds on tilled dirt, and you can grow something!"
	var/datum/farmedGood/held_seed = new/datum/farmedGood/test

/obj/item/seedpack/New()
	var/newtype = pick(typesof(/datum/farmedGood) - /datum/farmedGood/test)
	held_seed = new newtype
	name = "[held_seed.name] seeds"
	desc = "Grows [held_seed.name]"

/obj/item/weapon/tool/hoe
	name = "Hoe"
	desc = "Tills soil"
	icon_state = "scythe0"
	loot_icon_state = "scythe0"
	helpInfo = "You can use this item on regular grass to till it into farmable land.<br>Make sure you remember to till near water!"

/obj/item/weapon/tool/hoe/onUsed(var/mob/user,var/atom/onWhat)
	if(istype(onWhat,/turf/floor/outside/grass))
		messageInfo("You till the soil!",user,src)
		onWhat = new/turf/floor/outside/farm(get_turf(onWhat))
		onWhat:updateOverlay()

/obj/item/weapon/tool/shovel
	name = "Shovel"
	desc = "Helps dig channels"
	icon_state = "shovel"
	loot_icon_state = "shovel"
	helpInfo = "Using this item, you can dig channels, which flow water into them!"

/obj/item/weapon/tool/shovel/onUsed(var/mob/user,var/atom/onWhat)
	if(istype(onWhat,/turf/floor/outside/grass) || istype(onWhat,/turf/floor/outside/dirt) || istype(onWhat,/turf/floor/outside/snow))
		messageInfo("You dig a channel in the soil!",user,src)
		onWhat = new/turf/floor/outside/waterChannel(get_turf(onWhat))
	if(istype(onWhat,/turf/floor/outside/farm))
		if(onWhat:FG)
			messageInfo("You uproot the plant!",user,src)
			onWhat:FG = null
			onWhat:updateOverlay()

/turf/floor/outside/waterChannel
	name = "Channel"
	desc = "Liquids can flow into this!"
	icon_state = "asteroid_dug"
	helpInfo = "A nearby water source can be used to fill this!"

/turf/floor/outside/waterChannel/New()
	..()
	addProcessingObject(src)

/turf/floor/outside/waterChannel/doProcess()
	..()
	spawn(1)
		for(var/A in range(src,2))
			if(istype(A,/turf/floor/outside/liquid))
				remProcessingObject(src)
				var/T = new A:type(get_turf(src))
				spawn(5)
					T:updateDepth()
					T:updateErodeDepth()
