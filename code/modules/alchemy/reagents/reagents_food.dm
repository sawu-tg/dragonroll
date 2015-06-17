/datum/reagent/milk
	name = "milk"
	id = "milk"
	color = "#FFFFFF"

/datum/reagent/honey
	name = "milk"
	id = "honey"
	color = "#FFFFFF"

/datum/reagent/water
	name = "water"
	id = "water"
	color = "#77FFFF55"


///
// FOOD REAGENTS
///

/datum/reagent/nutrients
	name = "nutrients"
	id = "nutrient"
	color = "#333300"
	reagentState = REAGENT_STATE_POWDER

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/wellfed,15)
		..()

/datum/reagent/rawess
	name = "Raw Essence"
	id = "rawess"
	color = "#FF3300"
	reagentState = REAGENT_STATE_POWDER

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/regenerate,15)
		..()

/datum/reagent/paratoxin
	name = "Paralytic Toxin"
	id = "ptox"
	color = "#6600FF"
	reagentState = REAGENT_STATE_POWDER

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/stun,15)
		..()

/datum/reagent/neurotoxin
	name = "Neurotoxin"
	id = "ntox"
	color = "#FF00FF"
	reagentState = REAGENT_STATE_POWDER

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/poison,15)
		..()

/datum/reagent/suffocatetoxin
	name = "Suffocation Toxin"
	id = "stox"
	color = "#FF0000"
	reagentState = REAGENT_STATE_POWDER

	processMob(var/mob/player/who)
		who:addStatusEffect(/datum/statuseffect/suffocating,15)
		..()

//ethanol
/datum/reagent/aqua_vitae
	name = "aqua vitae"
	id = "aqua_vitae"
	color = "#FFFFFF"

//sap from the acacia
/datum/reagent/gum_arabic
	name = "gun arabic"
	id = "gum_arabic"
	color = "#FFFFFF"
	reagentState = REAGENT_STATE_SOLID