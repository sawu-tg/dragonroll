/obj/structure
	name = "default structure"
	desc = "probably in the way"
	anchored = 1
	density = 1

/obj/structure/door
	name = "door"
	icon = 'sprite/obj/doors/mineral_doors.dmi'
	icon_state = "wood"
	density = 1
	opacity = 1

	var/base_state = "wood"

	var/doorToggleTime = 5 //must be equal to animation time of door sprite
	var/doorOpenTime = 60
	var/doorCounter = 0

	var/toggling = 0
	var/open = 0
	var/is_glassdoor = 0

/obj/structure/door/proc/open()
	icon_state = "[base_state]open"
	flick("[base_state]opening",src)
	toggling = 1

	spawn(doorToggleTime)
		opacity = 0
		density = 0
		toggling = 0
		open = 1
		doorCounter = doorOpenTime
		addProcessingObject(src)

/obj/structure/door/proc/close()
	icon_state = "[base_state]"
	flick("[base_state]closing",src)
	toggling = 1
	remProcessingObject(src)

	spawn(doorToggleTime)
		opacity = !is_glassdoor
		density = 1
		toggling = 0
		open = 0

/obj/structure/door/doProcess()
	if(doorCounter > 0)
		doorCounter--
		if(doorCounter == 0 && !toggling)
			close()
			//flick("[base_state]closing",src)
			//toggling = 1
			//spawn(10)
			//	icon_state = "[base_state]"
			//	density = 1
			//	toggling = 0

/obj/structure/door/Cross(atom/Obstacle)
	if(!open && !toggling)
		open()

	if(open)
		return ..()

/obj/structure/door/old
	icon_state = "oldwood"
	base_state = "oldwood"
	doorToggleTime = 10


///
// RANDOM STRUCTURE GUBBINS
///

/obj/structure/magicbarrel
	name = "magical barrel"
	desc = "what's in here?"
	icon = 'sprite/obj/alchemy/barrel.dmi'
	icon_state = "barrel"
	var/list/containedTypes

/obj/structure/magicbarrel/objFunction(var/mob/user)
	if(containedTypes)
		var/toSpawn = input(user,"Pick what?") as null|anything in containedTypes
		if(toSpawn)
			new toSpawn(get_turf(user))


/obj/structure/magicbarrel/seeds
	name = "Seed Barrel"
	desc = "A big barrel of seeds!"
	containedTypes = list(/obj/item/seedpack)

/obj/structure/magicbarrel/food
	name = "Food Barrel"
	desc = "A big barrel of food!"

/obj/structure/magicbarrel/food/New()
	..()
	containedTypes = typesof(/obj/item/food) - /obj/item/food

/obj/structure/magicbarrel/tools
	name = "Tool and Weapon Barrel"
	desc = "A big barrel of hitting things!"

/obj/structure/magicbarrel/tools/New()
	..()
	containedTypes = typesof(/obj/item/weapon) - /obj/item/weapon

/obj/structure/magicbarrel/procres
	name = "Proc. Resources Barrel"
	desc = "A big barrel of processed resources!"

/obj/structure/magicbarrel/procres/New()
	..()
	containedTypes = typesof(/obj/item/loot/processed) - /obj/item/loot/processed

/obj/structure/magicbarrel/buildables
	name = "Buildables Barrel"
	desc = "A big barrel of building parts!"

/obj/structure/magicbarrel/buildables/New()
	..()
	containedTypes = typesof(/obj/item/buildable) - list(/obj/item/buildable,/obj/item/buildable/train,/obj/item/buildable/turf)


/obj/structure/popupspawn
	name = "Disturbed ground"
	desc = "What could be in here?"
	helpInfo = "Recently disturbed earth, all manner of things could be lurking in this hole!"
	icon = 'sprite/obj/tg_effects/effects.dmi'
	icon_state = "smoke"
	density = 0
	var/popupType = /mob/player/npc/animal/spider
	var/popupSkill = 15
	var/cooldown = 0
	var/maxCooldown = 500

/obj/structure/popupspawn/Cross(var/atom/movable/O)
	if(cooldown <= 0)
		if(istype(O,/mob/player))
			var/mob/player/P = O
			if(P && P.client)
				if(do_roll(1,20,P.playerData.dex.statCurr) < popupSkill)
					var/mob/player/npc/N = new popupType(get_turf(src))
					messageError("\an [N] bursts fourth from the [src]",P,N)
					N.target = P
					cooldown = maxCooldown
					invisibility = 1
					addProcessingObject(src)
	else
		return 1
/obj/structure/popupspawn/doProcess()
	--cooldown
	if(cooldown <= 0)
		invisibility = 1
		remProcessingObject(src)

/obj/structure/popupspawn/thing
	popupType = /mob/player/npc/animal/eater

/obj/structure/popupspawn/goliath
	popupType = /mob/player/npc/animal/eater/goliath

/obj/structure/popupspawn/grub
	popupType = /mob/player/npc/animal/eater/giantgrub

/obj/structure/popupspawn/basilisk
	popupType = /mob/player/npc/animal/eater/basilisk

/obj/structure/popupspawn/carp
	popupType = /mob/player/npc/animal/eater/carp

/obj/structure/popupspawn/hivelord
	popupType = /mob/player/npc/animal/eater/hivelord