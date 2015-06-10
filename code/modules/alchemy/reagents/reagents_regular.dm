/datum/reagent/water
	name = "water"
	id = "water"
	color = "#77FFFF55"

/datum/reagent/milk
	name = "milk"
	id = "milk"
	color = "#FFFFFF"

/datum/reagent/ew
	name = "diluted milk"
	id = "ew"
	color = "#FFFFFF55"

//This is a test donation
/datum/chem_reaction/ew
	id = "ew"

	required_reagents = list("milk" = 2, "water" = 3)
	produced_reagents = list("ew" = 3,"pyrosium" = 1)