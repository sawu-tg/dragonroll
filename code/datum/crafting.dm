/datum/recipe
	var/name = "default recipe"
	var/desc = "default desc"

	var/list/materials = list() // associative list of ingredients and count
	var/list/product = list() // associative list of produced objects and their count


///
// Returns whether the recipe can be crafted from the given list. Can be overidden with a boolean.
///
/datum/recipe/proc/canCraft(var/list/provided, var/override=FALSE)
	if(override)
		return TRUE
	else
		var/list/converted = list()

		for(var/a in provided)
			var/t = a:type
			if(converted[t])
				converted[t] = converted[t] + 1
			else
				converted[t] = 1
		var/max = 0
		for(var/i = 1; i <= materials.len; i++)
			var/found = locate(materials[i]) in provided
			if(found)
				if(converted[found:type] >= materials[materials[i]])
					max++
		if(max >= materials.len)
			return TRUE
	return FALSE

///
// Returns names of items needed, and their amount. Returns as a list of strings
///
/datum/recipe/proc/getNeededNames()
	var/list/newList = list()
	for(var/e in materials)
		var/obj/d = new e(src)
		newList += "[d.name] x [materials[e]]"
		del(d)
	return newList

///
// Completes the crafting recipe, from the provided list to the given crafting player.
// Can be overidden with a boolean to spawn items instantly, for no cost.
///
/datum/recipe/proc/getResult(var/list/provided, var/mob/player/crafter, var/override=FALSE)
	if(override)
		for(var/a in product)
			for(var/i = 0; i < product[a]; i++)
				new a(crafter.loc)
	else
		for(var/a in product)
			for(var/i = 0; i < product[a]; i++)
				var/obj/na = new a(crafter.loc)
				var/list/found = list()
				var/list/cloneProv = provided.Copy(0,provided.len+1)
				for(var/m in materials)
					for(var/c = 0; c <= materials[m]; c++)
						var/b = locate(m) in cloneProv
						if(b)
							found += b
							cloneProv -= b
				if(found.len)
					var/obj/first = found[1]
					var/obj/second = found.len >= 2 ? found[2] : found[1]
					var/datum/material/nm = combineMaterials(first.itemMaterial,second.itemMaterial)
					na.itemMaterial = nm
					na.updateStats()
				for(var/d in found)
					del(crafter.remFromInventory(d))

/datum/recipe/hatchet
	name = "hatchet"
	desc = "a cutting tool"

	materials = list(/obj/item/loot/nature/stick = 1, /obj/item/loot/nature/rock = 1)
	product = list(/obj/item/weapon/tool/hatchet = 1)

/datum/recipe/woodwall
	name = "wooden wall"
	desc = "keeps things out"

	materials = list(/obj/item/loot/processed/wood = 4)
	product = list(/obj/item/buildable/turf/woodenWall = 1)

/datum/recipe/wooddoor
	name = "wooden door"
	desc = "keeps things out"

	materials = list(/obj/item/loot/processed/wood = 2)
	product = list(/obj/item/buildable/turf/woodenDoor = 1)


/datum/recipe/woodboat
	name = "wood boat"
	desc = "makes oceans seem smaller"

	materials = list(/obj/item/loot/processed/wood = 4)
	product = list(/obj/vehicle/boat = 1)