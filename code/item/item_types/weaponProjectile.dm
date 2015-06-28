/obj/item/weapon/projectile
	name = "projectile weapon"
	desc = "makes hurty at a distance"
	var/projType = /obj/projectile/arrow
	var/thrownWep = FALSE
	range = 10
	force = 2

/obj/item/weapon/projectile/onUsed(var/mob/user,var/atom/onWhat)
	..()
	var/obj/projectile/P = new projType(onWhat,user,thrownWep)
	P.loc = get_turf(user)
	P.damage = force
	if(thrownWep)
		P.icon = icon
		P.icon_state = icon_state

/obj/item/weapon/projectile/bow
	name = "Bow"
	icon_state = "lbow"
	loot_icon_state = "bow"

/obj/item/weapon/projectile/knife
	name = "Thrown Knife"
	thrownWep = TRUE
	loot_icon_state = "knife"
	icon_state = "knife"