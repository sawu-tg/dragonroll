/datum/recipe
	var/name = "default recipe"
	var/desc = "default desc"

	var/list/materials = list() // associative list of ingredients and count
	var/list/product = list() // associative list of produced objects and their count

/datum/recipe/proc/canCraft(var/list/provided, var/override=FALSE)
	if(override)
		return TRUE
	else
		var/list/converted = list()

		for(var/a in provided)
			var/t = a:type
			if(locate(t) in converted)
				converted[t] = converted[t] + 1
			else
				converted[t] = 1

		for(var/i = 1; i < materials.len; i = i + 2)
			var/found = locate(materials[i]) in provided
			if(found)
				if(converted[found:type] >= materials[materials[i]])
					return TRUE
	return FALSE

/datum/recipe/proc/getNeededNames()
	var/list/newList = list()
	for(var/e in materials)
		var/obj/d = new e(src)
		newList += "[d.name] x [materials[e]]"
		del(d)
	return newList

/datum/recipe/proc/getResult(var/list/provided, var/mob/player/crafter, var/override=FALSE)
	if(override)
		for(var/a in product)
			for(var/i = 0; i < product[a]; i++)
				new a(crafter.loc)
	else
		for(var/a in product)
			for(var/i = 0; i < product[a]; i++)
				new a(crafter.loc)
				for(var/m in materials)
					for(var/c = 0; c < materials[m]; c++)
						var/b = locate(m) in provided
						if(b)
							del(crafter.remFromInventory(b))

/datum/recipe/test
	name = "test"
	desc = "you shouldn't see this"

	materials = list(/obj/item/armor/corgisuit = 1, /obj/item/armor/corgihat = 1)
	product = list(/obj/item/armor/streetarmor = 1)

/datum/recipe/test2
	name = "2est"
	desc = "you shouldn't see this either"

	materials = list(/obj/item/armor/corgisuit = 3, /obj/item/armor/corgihat = 4)
	product = list(/obj/item/armor/streetarmor = 1)