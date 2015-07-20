/obj/interact/nature/tree
	name = "tree"
	desc = "it's seen better days"
	icon = 'sprite/world/actualtree.dmi' //was deadtrees.dmi
	icon_state = ""
	//layer = LAYER_OVERLAY
	layer = MOB_LAYER
	density = 1
	pixel_x = -16
	itemMaterial = new/datum/material/wood
	var/datum/material/leafMaterial = new/datum/material/woodleaf
	var/list/treeIcons = list()
	harvestables = list(/obj/item/loot/nature/log = 1)
	var/required_level = 1
	var/cut_time = 30
	var/exp_granted = 25
	var/being_cut = FALSE
	doesColor = FALSE



/obj/interact/nature/tree/objFunction(var/mob/player/user, var/obj/item/I)
	if(being_cut)
		return
	if(!harvestable)
		messagePlayer("This tree has already been chopped down; wait for it to regrow.",user,src)
		return
	if(istype(I, /obj/item/weapon/tool/hatchet))
		var/obj/item/weapon/tool/hatchet/H = I
		if(required_level > user.playerData.woodcutting.statCurr)
			messagePlayer("You aren't good enough at woodcutting to chop down this tree.",user,src)
			return
		if(H.required_level > user.playerData.woodcutting.statCurr)
			messagePlayer("You aren't good enough at woodcutting to use this hatchet.",user,src)
			return
		messagePlayer("You start chopping at [src]!",user,src)
		for(var/i = 0; i < 4; ++i)
			spawn(i*10)
				playsound(get_turf(src), 'sound/effects/woodhit.ogg', 50, 1)
		being_cut = TRUE
		for(var/a in harvestables)
			for(var/i = 0; i < harvestables[a]; i++)
				sleep(cut_time*H.cut_speed)
				new a(user.loc)
				messagePlayer("You harvest a [src] log.",user,src)
				user.playerData.woodcutting.addxp(exp_granted, user)
		being_cut = FALSE
		messagePlayer("You finish cutting down the tree!",user,src)
		harvestable = FALSE
		icon_update()
		sdel(src)
		return

/obj/interact/nature/tree/New()
	..()
	icon_update()

/obj/interact/nature/tree/proc/icon_update()
	overlays -= treeIcons
	overlays.Cut()
	treeIcons.Cut()

	//Stem
	var/image/I1 = image('sprite/world/actualtree.dmi',src,"[harvestable ? "tree_stem" : "tree_stump"]",dir)
	I1.layer = layer+0.1
	I1.color = itemMaterial.color

	overlays |= I1
	treeIcons |= I1
	if(harvestable)
		//Leaves
		var/image/I2

		if(leafMaterial)
			I2 = image('sprite/world/actualtree.dmi',src,"tree_leaf",dir)
			I2.layer = layer+0.1
			I2.color = leafMaterial.color

		overlays |= I2
		treeIcons |= I2

	//Shadow
	var/image/I3 = image('sprite/world/actualtree.dmi',src,"tree_shadow",dir)
	I3.layer = OBJ_LAYER-0.1
	overlays |= I3
	treeIcons |= I3

/obj/interact/nature/tree/oak
	name = "oak tree"
	required_level = 15
	cut_time = 50
	exp_granted = 37.5
	harvestables = list(/obj/item/loot/nature/log/oak = 3)
	harvest_delay = 150
	itemMaterial = new/datum/material/oak

/obj/interact/nature/tree/willow
	name = "willow tree"
	required_level = 30
	cut_time = 70
	exp_granted = 67.5
	harvestables = list(/obj/item/loot/nature/log/willow = 6)
	harvest_delay = 200
	itemMaterial = new/datum/material/willow

/obj/interact/nature/tree/teak
	name = "teak tree"
	required_level = 35
	cut_time = 80
	exp_granted = 85
	harvestables = list(/obj/item/loot/nature/log/teak = 9)
	harvest_delay = 250
	itemMaterial = new/datum/material/teak

/obj/interact/nature/tree/maple
	name = "maple tree"
	required_level = 45
	cut_time = 100
	exp_granted = 100
	harvestables = list(/obj/item/loot/nature/log/maple = 12)
	harvest_delay = 300
	itemMaterial = new/datum/material/maple
	leafMaterial = new/datum/material/mapleleaf

/obj/interact/nature/tree/mahogany
	name = "mahogany tree"
	required_level = 50
	cut_time = 120
	exp_granted = 125
	harvestables = list(/obj/item/loot/nature/log/mahogany = 15)
	harvest_delay = 350
	itemMaterial = new/datum/material/mahogany

/obj/interact/nature/tree/yew
	name = "yew tree"
	required_level = 60
	cut_time = 170
	exp_granted = 175
	harvestables = list(/obj/item/loot/nature/log/yew = 21)
	harvest_delay = 400
	itemMaterial = new/datum/material/yew
	leafMaterial = new/datum/material/yewleaf

/obj/interact/nature/tree/magic
	name = "magic tree"
	required_level = 75
	cut_time = 250
	exp_granted = 250
	harvestables = list(/obj/item/loot/nature/log/magic = 25)
	harvest_delay = 450
	itemMaterial = new/datum/material/magic
	leafMaterial = new/datum/material/magicleaf

/obj/interact/nature/tree/elder
	name = "elder tree"
	required_level = 90
	cut_time = 300
	exp_granted = 325
	harvestables = list(/obj/item/loot/nature/log/elder = 31)
	harvest_delay = 500
	itemMaterial = new/datum/material/elder
	leafMaterial = null // no leaves

/obj/interact/nature/tree/snow
	name = "snowy tree"
	desc = "it's seen warmer days"
	harvestables = list(/obj/item/loot/nature/log/snowy = 3)
	required_level = 54
	cut_time = 130
	exp_granted = 140.2
	harvest_delay = 325
	itemMaterial = new/datum/material/snow_wood
	leafMaterial = new/datum/material/snowleaf

/obj/interact/nature/tree/snow/New()
	..()
	icon_state = "pine_[rand(1,3)]"