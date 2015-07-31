/obj/item/weapon
	name = "weapon"
	desc = "hits things in a hurty way"
	icon = 'sprite/obj/weapons.dmi'
	loot_icon = 'sprite/obj/weapons.dmi'
	showAsLoot = TRUE
	var/datum/aurapower/enchantment

/obj/item/weapon/proc/enchant(var/datum/aurapower/AP)
	if(AP)
		enchantment = AP
		name = "[AP.name] [name]"
		addProcessingObject(src)
		var/icon/newIcon = icon('sprite/obj/tg_effects/effects.dmi', "nothing")

		var/icon/compare = getFlatIcon(src)

		for(var/count = 1; count < 7; ++count)
			var/icon/I = new('sprite/obj/custom/base.dmi',icon_state = AP.overlay,frame = count)
			var/icon/R = icon('sprite/obj/tg_effects/effects.dmi', "nothing")
			for(var/x = 1; x < 32; ++x)
				for(var/y = 1; y < 32; ++y)
					if(compare.GetPixel(x,y))
						R.DrawBox(I.GetPixel(x,y),x,y)
			newIcon.Insert(R,frame=count)

		var/image/ii = new(newIcon)
		ii.blend_mode = BLEND_ADD
		ii.layer = src.layer + 10
		overlays += ii

/obj/item/weapon/doProcess()
	if(enchantment)
		enchantment.onTick()

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
	loot_icon_state = "hatchet"
	weight = 2
	force = 5
	var/cut_speed = 1
	var/rating = 1
	var/required_level = 1

/obj/item/weapon/tool/hammer
	name = "sledge"
	desc = "crushes and maims."
	icon_state = "axe0"
	loot_icon_state = "sledgehammer"
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
	set hidden = 1
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
	icon_state = "claymore"
	loot_icon_state = "sword"
	loot_icon = 'sprite/obj/custom/base.dmi'
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
		var/image/mask = image('sprite/obj/tg_effects/effects.dmi', "nothing")
		constructed = TRUE
		itemMaterial = bottom.itemMaterial
		mask.overlays += bottom
		itemMaterial = combineMaterials(itemMaterial,middle.itemMaterial)
		mask.overlays += middle
		itemMaterial = combineMaterials(itemMaterial,top.itemMaterial)
		mask.overlays += top
		icon = getFlatIcon(mask)
		force = (top.force + (middle.force/2)) + itemMaterial.addedForce
		weight = (bottom.weight + (middle.weight/2)) + itemMaterial.addedWeight
		name = "[itemMaterial.name] [top.nameCon] [middle.nameCon] [bottom.nameCon]"