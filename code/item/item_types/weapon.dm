/obj/item/weapon
	name = "weapon"
	desc = "hits things in a hurty way"
	icon = 'sprite/obj/weapons.dmi'

///
// In the case of weapons, weight > force makes a bashing/crushing object
// and force > weight makes a slashing/cutting object
///

///       ///
// WEAPONS //
///       ///
/obj/item/weapon/tool/hatchet
	name = "hatchet"
	desc = "slices and dices much easier than your fists."
	icon_state = "hatchet"
	weight = 2
	force = 5

/obj/item/weapon/tool/hammer
	name = "sledge"
	desc = "crushes and maims."
	icon_state = "sledgehammer"
	weight = 5
	force = 3

///
// Custom Weapon
///

/obj/item/part
	name = "part"
	var/nameCon = "part"

/obj/item/part/New(var/datum/material/M)
	if(!M)
		itemMaterial = getRandomMaterial()
		reassignMaterial(new itemMaterial())
	else
		reassignMaterial(M)
	..()

/obj/item/part/proc/reassignMaterial(var/datum/material/M)
	if(!M)
		return
	itemMaterial = M
	color = itemMaterial.color

//parts

/obj/item/part/blade
	name = "Blade Part"
	icon = 'sprite/obj/custom/blade.dmi'

/obj/item/part/blade/keen
	name = "Keen Blade Part"
	icon_state = "basic_a"
	nameCon = "Keen"
	force = 5

/obj/item/part/blade/dual
	name = "Dual Blade Part"
	icon_state = "basic_b"
	nameCon = "Dual"
	force = 4

/obj/item/part/blade/short
	name = "Dual Blade Part"
	icon_state = "basic_c"
	nameCon = "Short"
	force = 3

/obj/item/part/blade/fangs
	name = "Fang Blade Part"
	icon_state = "basic_b"
	nameCon = "Fang"
	force = 3

/obj/item/part/hilt
	name = "Hilt Part"
	icon = 'sprite/obj/custom/guard.dmi'

/obj/item/part/hilt/guarding
	name = "Guarding Hilt Part"
	icon_state = "basic_a"
	nameCon = "Guarding"
	force = 1
	weight = 1

/obj/item/part/hilt/deflecting
	name = "Deflecting Hilt Part"
	icon_state = "basic_b"
	nameCon = "Deflecting"
	force = 1
	weight = 2

/obj/item/part/hilt/defending
	name = "Defending Hilt Part"
	icon_state = "basic_c"
	nameCon = "Defending"
	force = 2
	weight = 1

/obj/item/part/hilt/parrying
	name = "Parrying Hilt Part"
	icon_state = "basic_b"
	nameCon = "Parrying"
	weight = 3
	force = 1

/obj/item/part/handle
	name = "Handle Part"
	icon = 'sprite/obj/custom/handles.dmi'

/obj/item/part/handle/blade
	name = "Blade Handle Part"
	icon_state = "basic_a"
	nameCon = "Blade"
	force = 1
	weight = 1

/obj/item/part/handle/claymore
	name = "Claymore Handle Part"
	icon_state = "basic_b"
	nameCon = "Claymore"
	force = 1
	weight = 2

/obj/item/part/handle/cutlass
	name = "Cutlass Handle Part"
	icon_state = "basic_c"
	nameCon = "Cutlass"
	force = 2
	weight = 1

/obj/item/part/handle/knife
	name = "Knife Handle Part"
	icon_state = "basic_b"
	nameCon = "Knife"
	weight = 3
	force = 1

//end
/obj/item/weapon/custom/verb/random()
	set name = "Randomise"
	set src in range()
	var/newType = pick(typesof(/obj/item/part/blade) - /obj/item/part/blade)
	top = new newType
	top.loc = src
	newType = pick(typesof(/obj/item/part/hilt) - /obj/item/part/hilt)
	middle = new newType
	middle.loc = src
	newType = pick(typesof(/obj/item/part/handle) - /obj/item/part/handle)
	bottom = new newType
	bottom.loc = src
	construct()

/obj/item/weapon/custom
	name = "custom weapon"
	desc = "Make it your Way!"
	icon = 'sprite/obj/custom/base.dmi'
	icon_state = "sword"
	var/constructed = FALSE
	var/obj/item/part/blade/top
	var/obj/item/part/hilt/middle
	var/obj/item/part/handle/bottom

/obj/item/weapon/custom/objFunction(var/mob/user,var/obj/item/I)
	if(istype(I,/obj/item/part))
		if(constructed)
			return
		user.DropItem()
		I.loc = src
		if(istype(I,/obj/item/part/blade))
			top = I
		if(istype(I,/obj/item/part/hilt))
			middle = I
		if(istype(I,/obj/item/part/handle))
			bottom = I
	if(!I)
		if(top && bottom && middle && !constructed)
			construct()

/obj/item/weapon/custom/proc/construct()
	if(!constructed)
		constructed = TRUE
		icon_state = ""
		itemMaterial = bottom.itemMaterial
		overlays += bottom
		itemMaterial = combineMaterials(itemMaterial,middle.itemMaterial)
		overlays += middle
		itemMaterial = combineMaterials(itemMaterial,top.itemMaterial)
		overlays += top
		force = (top.force + (middle.force/2)) + itemMaterial.addedForce
		weight = (bottom.weight + (middle.weight/2)) + itemMaterial.addedWeight
		name = "[itemMaterial.name] [top.nameCon] [middle.nameCon] [bottom.nameCon]"