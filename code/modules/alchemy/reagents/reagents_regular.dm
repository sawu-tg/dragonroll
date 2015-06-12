/datum/reagent/water
	name = "water"
	id = "water"
	color = "#77FFFF55"

/datum/reagent/milk
	name = "milk"
	id = "milk"
	color = "#FFFFFF"


///
// FOOD REAGENTS
///

/datum/reagent/nutrients
	name = "nutrients"
	id = "nutrient"
	color = "#333300"

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/wellfed,15)
		..()

/datum/reagent/rawess
	name = "Raw Essence"
	id = "rawess"
	color = "#FF3300"

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/regenerate,15)
		..()

/datum/reagent/paratoxin
	name = "Paralytic Toxin"
	id = "ptox"
	color = "#6600FF"

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/stun,15)
		..()

/datum/reagent/neurotoxin
	name = "Neurotoxin"
	id = "ntox"
	color = "#FF00FF"

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/poison,15)
		..()

/datum/reagent/suffocatetoxin
	name = "Suffocation Toxin"
	id = "stox"
	color = "#FF0000"

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/suffocating,15)
		..()
/*/datum/reagent/ew
	name = "diluted milk"
	id = "ew"
	color = "#FFFFFF55"

//This is a test donation
/datum/chem_reaction/ew
	id = "ew"

	required_reagents = list("milk" = 2, "water" = 3)
	produced_reagents = list("ew" = 3,"pyrosium" = 1)*/