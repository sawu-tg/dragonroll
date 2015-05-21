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


///
// HARVESTED GOODS, move elsewhere later
///

/obj/loot/nature
	name = "nature thing"
	desc = "vaguely leafy"
	icon = 'sprite/obj/items.dmi'

/obj/loot/nature/stick
	name = "stick"
	desc = "What's brown and sticky?"
	icon_state = "c_tube"
	itemMaterial = new/datum/material/wood1

/obj/loot/nature/leaf
	name = "leafy pile"
	desc = "Make like a tree and leaf."
	icon_state = "leafmatter"
	itemMaterial = new/datum/material/nature1

/obj/loot/nature/rock
	name = "rock chip"
	desc = "An alternative to heavy metal."
	icon_state = "rock"
	itemMaterial = new/datum/material/mineral1