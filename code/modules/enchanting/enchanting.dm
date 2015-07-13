/datum/aurapower
	var/name = "Power"
	var/desc = "Power desc."
	var/overlay = "enchant_overlay3"
	var/modifier = 1
	var/mob/player/owner

/datum/aurapower/proc/onHit(var/target)

/datum/aurapower/proc/onTick()



/obj/structure/auranode
	name = "Font of Power"
	desc = "It glimmers with a mischevious shine.."
	helpInfo = "Fonts of Power can be used, along with a weapon or tool, to imbue enchantments into the used item."
	icon = 'sprite/obj/tg_effects/effects.dmi'
	icon_state = "anom"
	var/containedPower

/obj/structure/auranode/New()
	..()
	containedPower = pick(typesof(/datum/aurapower) - /datum/aurapower)

/obj/structure/auranode/objFunction(var/mob/user,var/obj/item/I)
	if(I)
		if(istype(I,/obj/item/weapon))
			var/obj/item/weapon/W = I
			if(!W.enchantment)
				var/datum/aurapower/AP = new containedPower
				AP.owner = user
				messageInfo("You imbue the [W] with [AP.name]",user,src)
				W.enchant(AP)
				sdel(src)

//various enchantments

/datum/aurapower/vampire
	name = "Vampiric"
	desc = "Drains your target's health."
	overlay = "enchant_overlay2"

/datum/aurapower/vampire/onHit(var/target)
	if(target)
		if(istype(target,/mob/player))
			var/mob/player/P = target
			P.takeDamage(modifier,DTYPE_DIRECT)
			owner.healDamage(modifier)

/datum/aurapower/striking
	name = "Striking"
	desc = "Deals bonus magical damage to your target."
	overlay = "enchant_overlay3"

/datum/aurapower/striking/onHit(var/target)
	if(target)
		if(istype(target,/mob/player))
			var/mob/player/P = target
			P.takeDamage(modifier,DTYPE_MAGIC)