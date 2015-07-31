/obj/interact/nature
	name = "nature thing"
	desc = "grows stuff"
	icon = 'sprite/world/ausflora.dmi'
	anchored = 1
	var/numOfHarvests = 1
	var/list/harvestables = list() // associative list, type count

/obj/interact/nature/garbageCleanup()
	..()
	numOfHarvests = null
	harvestables = null

/obj/interact/nature/objFunction(var/mob/user)
	if(harvestable)
		if(numOfHarvests > 0)
			messagePlayer("You harvest some things from the [src]!",user,src)
			for(var/a in harvestables)
				for(var/i = 0; i < harvestables[a]; i++)
					new a(user.loc)
			--numOfHarvests
		else
			harvestable = FALSE
			sdel(src)

/obj/interact/nature/bush
	name = "small bush"
	desc = "Needs a bit of a trim."
	harvestables = list(/obj/item/loot/nature/stick = 4,/obj/item/loot/nature/leaf = 4,/obj/item/seedpack = 1)

/obj/interact/nature/bush/New()
	..()
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
	..()
	icon_state = "rock[rand(1,5)]"

/obj/interact/nature/tree/snow
	name = "snowy tree"
	desc = "it's seen warmer days"
	icon = 'sprite/world/deadtrees.dmi'
	icon = 'sprite/world/pinetrees.dmi'

/obj/interact/nature/tree/snow/New()
	..()
	icon_state = "pine_[rand(1,3)]"