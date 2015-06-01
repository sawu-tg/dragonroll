/obj/item/mob_spawner
	name = "default item"
	desc = "not very interesting"
	icon = 'sprite/obj/weapons.dmi'
	icon_state = "tome"
	uuid = "mob_spawner"
	prevent_pickup = 1
	var/mob/player/npc/spawned_mob

/obj/item/mob_spawner/objFunction(var/mob/user)
	var/mob/m = new spawned_mob(user.loc)
	user << "You pull a [m.name] from the bag!"
	return

/obj/item/mob_spawner/genie
	name = "bejewled leather spell book"
	desc = "Smells of the desert."
	icon_state = "lamp"
	uuid = "tome"
	spawned_mob = /mob/player/npc/genie

/obj/item/mob_spawner/chicken
	name = "chicken infested spell book"
	desc = "You wonder where all the chickens come from."
	uuid = "mob_spawner_chicken"
	spawned_mob = /mob/player/npc/chicken