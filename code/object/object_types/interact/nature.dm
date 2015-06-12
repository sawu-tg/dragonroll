/obj/interact/nature
	name = "nature thing"
	desc = "grows stuff"
	icon = 'sprite/world/ausflora.dmi'
	anchored = 1
	var/numOfHarvests = 1
	var/list/harvestables = list() // associative list, type count

/obj/interact/nature/objFunction(var/mob/user)
	if(numOfHarvests > 0)
		messagePlayer("You harvest some things from the [src]!",user,src)
		for(var/a in harvestables)
			for(var/i = 0; i < harvestables[a]; i++)
				new a(user.loc)
		--numOfHarvests

/obj/interact/nature/bush
	name = "small bush"
	desc = "Needs a bit of a trim."
	harvestables = list(/obj/item/loot/nature/stick = 4,/obj/item/loot/nature/leaf = 4,/obj/item/seedpack = 1)

/obj/interact/nature/bush/New()
	icon_state = "grassybush_[rand(1,4)]"

/obj/interact/nature/bush/snow
	name = "snowy small bush"
	desc = "Needs a bit of a trim."
	icon = 'sprite/world/snowflora.dmi'

/obj/interact/nature/bush/snow/New()
	icon_state = "snowbush[rand(1,6)]"

/obj/interact/nature/rock
	name = "small rock"
	desc = "Do not bang your head on this."
	icon = 'sprite/world/rocks.dmi'
	harvestables = list(/obj/item/loot/nature/rock = 1)

/obj/interact/nature/rock/New()
	icon_state = "rock[rand(1,5)]"

/obj/interact/nature/tree
	name = "tree"
	desc = "it's seen better days"
	icon = 'sprite/world/actualtree.dmi' //was deadtrees.dmi
	icon_state = "tree_stem"
	//layer = LAYER_OVERLAY
	layer = MOB_LAYER
	density = 1
	pixel_x = -16
	itemMaterial = new/datum/material/wood1
	var/datum/material/leafMaterial = new/datum/material/nature1
	var/list/treeIcons = list()
	harvestables = list(/obj/item/loot/nature/log = 1,/obj/item/loot/nature/stick = 4,/obj/item/loot/nature/leaf = 4)

/obj/interact/nature/tree/objFunction(var/mob/user)
	..()
	messagePlayer("The [src] collapses!",user,src)
	del(src)

/obj/interact/nature/tree/New()
	//icon_state = "tree_[rand(1,6)]"
	icon_update()

/obj/interact/nature/tree/proc/icon_update()
	overlays -= treeIcons
	treeIcons.Cut()

	//Stem
	var/image/I1 = image('sprite/world/actualtree.dmi',src,"tree_stem",dir)
	I1.layer = layer+0.1
	I1.color = itemMaterial.color

	//Leaves
	var/image/I2

	if(leafMaterial)
		I2 = image('sprite/world/actualtree.dmi',src,"tree_leaf",dir)
		I2.layer = layer+0.1
		I2.color = leafMaterial.color

	//Shadow
	var/image/I3 = image('sprite/world/actualtree.dmi',src,"tree_shadow",dir)
	I3.layer = OBJ_LAYER-0.1

	overlays |= I1
	treeIcons |= I1
	overlays |= I2
	treeIcons |= I2
	overlays |= I3
	treeIcons |= I3

/obj/interact/nature/tree/snow
	name = "snowy tree"
	desc = "it's seen warmer days"
	icon = 'sprite/world/deadtrees.dmi'
	icon = 'sprite/world/pinetrees.dmi'
	harvestables = list(/obj/item/loot/nature/log = 1,/obj/item/loot/nature/stick = 4,/obj/item/loot/nature/leaf = 4)

/obj/interact/nature/tree/snow/New()
	icon_state = "pine_[rand(1,3)]"