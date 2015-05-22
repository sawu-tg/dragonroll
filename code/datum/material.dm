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

/mob/verb/testAlloy()
	var/mat1 = getRandomMaterial()
	var/datum/material/sickterial = new mat1

	for(var/i = 0, i < 5,i++)
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
	combined.name = alloyname(first.name,second.name)
	combined.color = BlendRGBasHSV(first.color,second.color)
	combined.addedWeight = round((first.addedWeight + second.addedWeight)/2)
	combined.addedForce = round((first.addedForce + second.addedForce)/2)
	return combined



///
// MATERIALS
///

/datum/material/default //Wat
	name = "default" //Kill yourself
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

/datum/material/iron
	name = "ferrum"
	color = "gray"
	addedWeight = 1
	addedForce = 2

/datum/material/conducting
	name = "conductium"
	color = "orange"
	addedWeight = 1
	addedForce = 2