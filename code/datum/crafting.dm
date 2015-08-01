/datum/recipe
	var/name = "default recipe"
	var/desc = "default desc"
	var/listCategory = "Uncategorized"
	var/usesGeneric = TRUE // if this is true, requiredReagents checks for REAGENT_STATE instead of ref id
	var/requiredType // what type needs to be nearby to use it
	var/list/requiredReagents = list() // associative list of required reagents, if using defines, make sure to do "[define]"
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
		//reagents
		var/list/check = requiredReagents.Copy(0)
		var/cont = TRUE
		for(var/A in check)
			for(var/atom/B in provided)
				if(B.reagents)
					for(var/datum/reagent/R in B.reagents.liquidlist)
						if(usesGeneric ? text2num(A) == R.reagentState : A == R.id)
							check[A] -= R.volume
		for(var/A in check)
			if(check[A] > 0)
				cont = FALSE
		if(!cont)
			return FALSE
		//end
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
		sdel(d)
	for(var/m in requiredReagents)
		var/count = requiredReagents[m]
		if(usesGeneric)
			var/name
			if(text2num(m) == REAGENT_STATE_SOLID)
				name = "Solids"
			if(text2num(m) == REAGENT_STATE_LIQUID)
				name = "Liquids"
			if(text2num(m) == REAGENT_STATE_POWDER)
				name = "Powders"
			newList += "[name] x [count]"
		else
			var/datum/reagent/R = reagentList[m]
			var/rname = R.name
			newList += "[rname] x [count]"
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
				var/list/check = requiredReagents.Copy(0)
				for(var/A in check)
					for(var/atom/B in provided)
						if(B.reagents)
							B.reagents.removeliquid(A,check[A])
				if(found.len)
					var/obj/first = found[1]
					var/obj/second = found.len >= 2 ? found[2] : found[1]
					var/datum/material/nm = combineMaterials(first.itemMaterial,second.itemMaterial)
					na.itemMaterial = nm
					na.updateStats()
				for(var/d in found)
					sdel(crafter.remFromInventory(d))
		if(materials[/obj/item/loot/processed/animal/hide])
			giveMedal("Chainsaw-less Massacre",crafter)

/datum/recipe/hatchet
	name = "hatchet"
	desc = "a cutting tool"
	listCategory = "Tools"
	materials = list(/obj/item/loot/nature/stick = 1, /obj/item/loot/nature/rock = 1)
	product = list(/obj/item/weapon/tool/hatchet = 1)

/datum/recipe/hoe
	name = "hoe"
	desc = "a farming tool"
	listCategory = "Tools"
	materials = list(/obj/item/loot/nature/stick = 2, /obj/item/loot/nature/rock = 1)
	product = list(/obj/item/weapon/tool/hoe = 1)

/datum/recipe/customWeapon
	name = "custom weapon"
	desc = "gives you a mould to forge a custom weapon"
	listCategory = "Tools"
	materials = list(/obj/item/loot/nature/stick = 4, /obj/item/loot/nature/rock = 2)
	product = list(/obj/item/weapon/custom = 1)

/datum/recipe/forge
	name = "forge"
	desc = "creates parts for a forge"
	listCategory = "Building"
	materials = list(/obj/item/loot/nature/stick = 3, /obj/item/loot/nature/rock = 5)
	product = list(/obj/item/buildable/forge = 1)

/datum/recipe/campfire
	name = "campfire"
	desc = "creates parts for a campfire"
	listCategory = "Building"
	materials = list(/obj/item/loot/nature/stick = 3, /obj/item/loot/nature/rock = 3)
	product = list(/obj/item/buildable/campfire = 1)

/datum/recipe/campfire/getResult(var/list/provided, var/mob/player/crafter, var/override=FALSE)
	..(provided,crafter,override)
	giveMedal("Warming Glow",crafter)

/datum/recipe/woodwall
	name = "wooden wall"
	desc = "keeps things out"
	listCategory = "Building"
	materials = list(/obj/item/loot/processed/wood = 4)
	product = list(/obj/item/buildable/turf/woodenWall = 1)

/datum/recipe/woodwall/getResult(var/list/provided, var/mob/player/crafter, var/override=FALSE)
	..(provided,crafter,override)
	giveMedal("Wall'em'up",crafter)

/datum/recipe/wooddoor
	name = "wooden door"
	desc = "keeps things out"
	listCategory = "Building"
	materials = list(/obj/item/loot/processed/wood = 2)
	product = list(/obj/item/buildable/turf/woodenDoor = 1)


/datum/recipe/woodboat
	name = "wood boat"
	desc = "makes oceans seem smaller"
	listCategory = "Mounts"
	materials = list(/obj/item/loot/processed/wood = 4)
	product = list(/obj/vehicle/boat = 1)

/datum/recipe/leatherjerkin
	name = "leather jerkin"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 4)
	product = list(/obj/item/armor/jerkin = 1)

/datum/recipe/leatherlshoe
	name = "leather left shoe"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 1)
	product = list(/obj/item/armor/leather_boot_left = 1)

/datum/recipe/leatherrshoe
	name = "leather right shoe"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 1)
	product = list(/obj/item/armor/leather_boot_right = 1)

/datum/recipe/tannedarmor
	name = "tanned coat"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 4)
	product = list(/obj/item/armor/dustercoat = 1)

/datum/recipe/tannedlegs
	name = "tanned pants"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 2)
	product = list(/obj/item/armor/duster_pants = 1)

/datum/recipe/tannedshoel
	name = "tanned left shoe"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 2)
	product = list(/obj/item/armor/duster_shoe_left = 1)

/datum/recipe/tannedshoer
	name = "tanned right shoe"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 2)
	product = list(/obj/item/armor/duster_shoe_right = 1)

/datum/recipe/corgisuit
	name = "corgi suit"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 4)
	product = list(/obj/item/armor/corgisuit = 1)

/datum/recipe/corgihat
	name = "corgi hood"
	desc = "some basic armor"
	listCategory = "Armor"
	materials = list(/obj/item/loot/processed/animal/hide = 1)
	product = list(/obj/item/armor/corgihat = 1)