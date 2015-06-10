/mob/player/npc/colonist
	name = "Colonist No-Name"
	npcNature = NPCTYPE_DEFENSIVE
	wanderFuzziness = 5

/mob/player/npc/colonist/New()
	..()
	spawn(15)
		var/obj/item/AB = new/obj/item/weapon/projectile/bow()
		addToInventory(AB)
		takeToActiveHand(AB)