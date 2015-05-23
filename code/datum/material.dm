/datum/material
	var/name = "default material"
	var/color = "#FF0000"
	var/matLevel = 1 // 1 - 10
	var/addedWeight = 0
	var/addedForce = 0

	var/list/adjectives = list()
	var/prefix = ""
	var/list/syllables = list("de","fault")
	var/suffix = ""

/datum/material/New()
	..()

	src.build_name()

/datum/material/proc/build_name()
	name = "[list2text(adjectives,", ")]"
	if(adjectives.len) name += " "
	name += list2text(list(prefix) + syllables + suffix)

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

/datum/material/proc/inherit(var/obj/inheriting)
	inheriting.color = color
	inheriting.weight += addedWeight
	if(istype(inheriting,/obj/item))
		var/obj/item/i = inheriting
		i.force += addedForce
	if(name != "default") //sue me
		inheriting.name = "[name] [inheriting.name]"

/mob/verb/testAlloy()
	var/mat1 = getRandomMaterial()
	var/datum/material/sickterial = new mat1

	for(var/i = 0, i < 5,i++)
		world << sickterial.name
		var/mat2 = getRandomMaterial()
		sickterial = combineMaterials(sickterial, new mat2)

/proc/getRandomMaterial()
	var/list/selectionlist = typesof(/datum/material) - /datum/material

	return pick(selectionlist)

/proc/alloyname(name1,name2)
	var/N1 = lentext(name1)
	var/N2 = lentext(name2)

	var/rname = copytext(name1,1,round(N1 * 2/3)+1) + copytext(name2,round(-N2 * 2/3))

	world << "[name1] + [name2] = [rname]"

	return rname

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