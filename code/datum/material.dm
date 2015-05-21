/datum/material
	var/name = "default material"
	var/color = "red"
	var/matLevel = 1 // 1 - 10
	var/addedWeight = 0
	var/addedForce = 0

/datum/material/proc/inherit(var/obj/inheriting)
	inheriting.color = color
	inheriting.weight += addedWeight
	if(istype(inheriting,/obj/item))
		var/obj/item/i = inheriting
		i.force += addedForce
	if(name != "default") //sue me
		inheriting.name = "[name] [inheriting.name]"


/proc/combineMaterials(var/datum/material/first, var/datum/material/second)
	var/datum/material/combined = new/datum/material/default
	combined.name = "[first]-[second]"
	combined.color = first.color + second.color
	combined.matLevel = first.matLevel + second.matLevel
	combined.addedWeight = round((first.addedWeight + second.addedWeight)/2)
	combined.addedForce = round((first.addedForce + second.addedForce)/2)
	return combined



///
// MATERIALS
///

/datum/material/default
	name = "default"
	color = "white"
	addedWeight = 0
	matLevel = 10
	addedForce = 0

/datum/material/wood1
	name = "hearthwood"
	color = "brown"
	addedWeight = 0
	addedForce = 1

/datum/material/nature1
	name = "hearthbush"
	color = "green"
	addedWeight = 0
	addedForce = 1

/datum/material/mineral1
	name = "erdestein"
	color = "grey"
	addedWeight = 1
	addedForce = 2