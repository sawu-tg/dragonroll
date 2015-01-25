/obj/item/mob_spawner
	name = "default item"
	desc = "not very interesting"
	icon = 'sprite/obj/weapons.dmi'
	icon_state = "pouch"
	uuid = "mob_spawner"
	prevent_pickup = 1
	var/mob/player/npc/spawned_mob

/obj/item/mob_spawner/objFunction(var/mob/user)
	user << "You pull a [spawned_mob.name] from the bag!"
	new spawned_mob(user.loc)
	return

/obj/item/mob_spawner/chicken
	name = "chicken infested spell component pouch"
	desc = "You wonder where all the chickens come from."
	uuid = "mob_spawner_chicken"
	spawned_mob = /mob/player/npc/chicken