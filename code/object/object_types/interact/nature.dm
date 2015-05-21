/obj/interact/nature
	name = "nature thing"
	desc = "grows stuff"
	icon = 'sprite/world/ausflora.dmi'
	anchored = 1
	var/numOfHarvests = 1
	var/list/harvestables = list() // associative list, type count

/obj/interact/nature/objFunction(var/mob/user)
	if(numOfHarvests > 0)
		displayTo("You harvest some things from the [src]!",user,src)
		for(var/a in harvestables)
			for(var/i = 0; i < harvestables[a]; i++)
				new a(user.loc)
		--numOfHarvests

/obj/interact/nature/bush
	name = "small bush"
	desc = "Needs a bit of a trim."
	harvestables = list(/obj/loot/nature/stick = 4,/obj/loot/nature/leaf = 4)

/obj/interact/nature/bush/New()
	icon_state = "grassybush_[rand(1,4)]"

/obj/interact/nature/rock
	name = "small rock"
	desc = "Do not bang your head on this."
	icon = 'sprite/world/rocks.dmi'
	harvestables = list(/obj/loot/nature/rock = 1)

/obj/interact/nature/rock/New()
	icon_state = "rock[rand(1,5)]"

/obj/interact/nature/tree
	name = "tree"
	desc = "it's seen better days"
	icon = 'sprite/world/deadtrees.dmi'
	layer = LAYER_OVERLAY
	density = 1
	harvestables = list(/obj/loot/nature/log = 1,/obj/loot/nature/stick = 4,/obj/loot/nature/leaf = 4)

/obj/interact/nature/tree/objFunction(var/mob/user)
	..()
	displayTo("The [src] collapses!",user,src)
	del(src)

/obj/interact/nature/tree/New()
	icon_state = "tree_[rand(1,6)]"