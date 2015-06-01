/datum/material
	var/name = "default material"
	var/color = "#FF0000" // the color of the material
	var/matLevel = 1 // (1 - 10) how strong the material is, and what it adds to modifiers
	var/addedWeight = 0 // how much weight is added when this is used
	var/addedForce = 0 // how much force is added when this is used

	var/list/adjectives = list() // ???
	var/prefix = "" // prefix of the material
	var/list/syllables = list("de","fault") // syllables of the material's name
	var/suffix = "" // suffix of the amterial

/datum/material/New()
	..()
	src.build_name()

///
// Reconstructs the name of the material
///
/datum/material/proc/build_name()
	name = "[list2text(adjectives,", ")]"
	if(adjectives.len) name += " "
	name += list2text(list(prefix) + syllables + suffix)

///
// Mixes the name of two materials
///
/datum/material/proc/mix_name(var/datum/material/first, var/datum/material/second)
	adjectives = first.adjectives | second.adjectives

	if(!first.prefix)
		prefix = second.prefix
	else if(!second.suffix)
		prefix = first.prefix
	else
		prefix = pick(first.prefix,second.prefix)

	var/N1 = first.syllables.len
	var/N2 = second.syllables.len
	var/P1 = -round(-N1 * 1/2)
	var/P2 = -round(-N2 * 1/2)

	syllables = first.syllables.Copy(1,P1+1) + second.syllables.Copy(N2-P2+1,0)
	//syllables = first.syllables + second.syllables

	if(!first.suffix)
		suffix = second.suffix
	else if(!second.suffix)
		suffix = first.suffix
	else
		suffix = pick(first.suffix,second.suffix)

	build_name()

///
// Adds the properties of one material to this one
///
/datum/material/proc/inherit(var/obj/inheriting)
	inheriting.color = color
	inheriting.weight += addedWeight
	if(istype(inheriting,/obj/item))
		var/obj/item/i = inheriting
		i.force += addedForce
	if(name != "default") //sue me
		inheriting.name = "[name] [inheriting.name]"

///
// DEBUG: Generates a number of test materials
///
/mob/verb/testAlloy()
	var/mat1 = getRandomMaterial()
	var/datum/material/sickterial = new mat1

	for(var/i = 0, i < 5,i++)
		world << sickterial.name
		var/mat2 = getRandomMaterial()
		sickterial = combineMaterials(sickterial, new mat2)

///
// Returns a random material from all materials
///
/proc/getRandomMaterial()
	var/list/selectionlist = typesof(/datum/material) - /datum/material

	return pick(selectionlist)

///
// Creates a material name from two given names
///
/proc/alloyname(name1,name2)
	var/N1 = lentext(name1)
	var/N2 = lentext(name2)

	var/rname = copytext(name1,1,round(N1 * 2/3)+1) + copytext(name2,round(-N2 * 2/3))

	world << "[name1] + [name2] = [rname]"

	return rname

///
// Cleanses a string of double letters
///
/proc/cullDoubleLetters(text)
	var/currentletter
	var/rtext = ""

	world << text

	for(var/i = 1, i <= lentext(text), i++)
		var/newletter = copytext(text,i,1)

		if(newletter == currentletter)
			continue

		currentletter = newletter
		rtext += newletter

	return rtext

///
// Creates a new material as an average from the two given
///
/proc/combineMaterials(var/datum/material/first, var/datum/material/second)
	var/datum/material/combined = new/datum/material/default
	combined.matLevel = first.matLevel + second.matLevel
	//combined.name = "[first]-[second]" //Sick naming
	//combined.name = alloyname(first.name,second.name)
	combined.mix_name(first,second)
	combined.color = BlendRGBasHSV(first.color,second.color,0.5)
	combined.addedWeight = round((first.addedWeight + second.addedWeight)/2)
	combined.addedForce = round((first.addedForce + second.addedForce)/2)

	return combined



///
// MATERIALS
///

/datum/material/default //Wat
	name = "default" //Kill yourself
	color = "#FFFFFF"
	addedWeight = 0
	matLevel = 10
	addedForce = 0

/datum/material/flesh
	name = "flesh"
	color = "#990000"
	addedWeight = 1
	matLevel = 1
	addedForce = 1


/datum/material/wood1
	name = "hearthwood"
	color = "#8B4513"
	addedWeight = 0
	addedForce = 1

	prefix = "hearth"
	syllables = list()
	suffix = "wood"

/datum/material/nature1
	name = "hearthbush"
	color = "#556B2F"
	addedWeight = 0
	addedForce = 1

	prefix = "hearth"
	syllables = list()
	suffix = "bush"

/datum/material/grass1
	name = "hearthgrass"
	color = "#556B2F"
	addedWeight = 0
	addedForce = 0

	prefix = "hearth"
	syllables = list()
	suffix = "grass"

/datum/material/mineral1
	name = "erdestein"
	color = "#696969"
	addedWeight = 1
	addedForce = 2

	syllables = list("er","de","stein")

/datum/material/iron
	name = "ferrum"
	color = "#808080"
	addedWeight = 1
	addedForce = 2

	syllables = list("ferr")
	suffix = "um"

/datum/material/conducting
	name = "conductium"
	color = "#D2691E"
	addedWeight = 1
	addedForce = 2

	syllables = list("con","duct")
	suffix = "ium"