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