/mob/player/npc/animal
	name = "animal"
	desc = "grrr"
	icon_state = "clown"
	icon = 'sprite/mob/animal.dmi'
	isMonster = TRUE
	var/isHostile = FALSE
	var/list/droppedItems = list()

/mob/player/npc/animal/New()
	actualIconState = icon_state
	..()
	spawn(1)
		if(isHostile)
			npcNature = NPCTYPE_AGGRESSIVE
			alignment = ALIGN_EVIL
			mobFaction = findFaction("Hostile")
		else
			mobFaction = findFaction("Wildlife")
	classChange(/datum/class/beast)

/mob/player/npc/animal/chicken
	name = "Chicken"
	desc = "You wonder where it came from."
	icon_state = "chicken_white"
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/chicken/New()
	icon_state = "chicken_[pick("brown","white","black")]"
	..()

/mob/player/npc/animal/fox
	name = "Fox"
	desc = "Smarter than most things."
	icon_state = "fox"
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/dog
	name = "Dog"
	desc = "Some call him \"Ian\""
	icon_state = "corgi"
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap)

/mob/player/npc/animal/dog/New()
	icon_state = pick("corgi","lisa","pug","tamaskan","shepard")
	..()

/mob/player/npc/animal/crab
	name = "Crab"
	desc = "Comes with six conveniently attached sticks."
	icon_state = "crab"
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/crab/New()
	icon_state = pick("evilcrab","crab")
	..()

/mob/player/npc/animal/cow
	name = "Cow"
	desc = "She likes to moo-ve it."
	icon_state = "cow"
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/bear
	name = "Bear"
	desc = "Smarter than the average."
	icon_state = "bear"
	isHostile = TRUE
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap)

/mob/player/npc/animal/bear/New()
	icon_state = pick("brownbear","bearfloor")
	..()

/mob/player/npc/animal/spider
	name = "Spider"
	desc = "Spins webs and climbs aquaducts."
	icon_state = "guard"
	var/hasBabies = TRUE
	isHostile = TRUE
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/taunt/web,/datum/ability/assassinate/leap,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/spider/New()
	icon_state = pick("guard","hunter","nurse")
	..()

/mob/player/npc/animal/spider/doProcess()
	if(checkEffectStack("dead") > 0)
		if(hasBabies)
			messageArea("Your babies burst fourth!","Spiderlings burst fourth from the corpse of [src]", src, src,"red")
			for(var/i = 0; i < rand(3,6); ++i)
				new/mob/player/npc/animal/spider/baby(get_turf(src))
			hasBabies = FALSE
	..()

/mob/player/npc/animal/spider/baby
	name = "Spiderling"
	hasBabies = FALSE

/mob/player/npc/animal/spider/baby/New()
	..()
	playerData.hp.setBaseTo(1)
	var/matrix/newtransform = matrix()
	newtransform.Scale(0.5)
	animate(src,transform = newtransform,time = 0.1,loop = 0)

/mob/player/npc/animal/cat
	name = "Cat"
	desc = "Fond of fiddles and spoons."
	icon_state = "cat"
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/cat/New()
	icon_state = pick("cat","cat2")
	..()

/mob/player/npc/animal/bat
	name = "Bat"
	desc = "No men here."
	icon_state = "bat"
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/wasp
	name = "Wasp"
	desc = "Pollinates figs. And nightmares."
	icon_state = "wasp"
	isHostile = TRUE
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/deer
	name = "Deer"
	desc = "Neigh!."
	icon_state = "deer"
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

///
// SLIMES
///

/mob/player/npc/animal/slime
	name = "Slime"
	desc = "Blib blobs all over you!."
	icon_state = "slime"

	hasOtherDeath = TRUE
	isHostile = TRUE

	var/food = 0
	var/stage = "baby"
	var/maxFood = 120

	var/feedInterval = 60

	var/myColor = "green"
	var/myFace = "aslime-:3"

	var/mob/player/fedOn

	var/hasChangedState = FALSE

	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/slime/New()
	..()
	spawn(5)
		icon = 'sprite/mob/slimes.dmi'
		update_icon()

/mob/player/npc/animal/slime/doProcess()
	if(food < -(maxFood/2))
		myFace = "aslime-pout"
		hasChangedState = TRUE
	if(food < -(maxFood))
		myFace = "aslime-sad"
		hasChangedState = TRUE
	if(npcState == NPCSTATE_FIGHTING)
		myFace = "aslime-angry"
		hasChangedState = TRUE
	if(target)
		if(istype(target,/mob/player))
			fedOn = target
	if(fedOn)
		loc = get_turf(fedOn)
		feedInterval--
		if(feedInterval <= 0)
			feedInterval = initial(feedInterval)
			fedOn.takeDamage(1,DTYPE_DIRECT)
			food = food + 10 > maxFood ? maxFood : food + 10
			myFace = "aslime-mischevious"
			hasChangedState = TRUE
			if(fedOn.checkEffectStack("dead"))
				fedOn = null
	if(food >= maxFood/2 && stage != "adult")
		stage = "adult"
		hasChangedState = TRUE
	else if(food < maxFood/2 && stage != "baby")
		stage = "baby"
		hasChangedState = TRUE
	if(food >= maxFood)
		myFace = "aslime-:33"
		hasChangedState = TRUE
		doSplit(rand(1,4))
		food = 0
		isHostile = FALSE
		target = null
		fedOn = null
	if(hasChangedState)
		hasChangedState = FALSE
		update_icon()
	..()

/mob/player/npc/animal/slime/proc/doSplit(var/times)
	for(var/I = 0; I < times; ++I)
		var/mob/player/npc/animal/slime/S = new(get_turf(src))
		S.myColor = myColor
		food -= round(food/times)
		S.food = round(food/times)

/mob/player/npc/animal/slime/update_icon()
	if(checkEffectStack("dead") > 0)
		icon_state = "[myColor] [stage] slime dead"
	else if(fedOn)
		icon_state = "[myColor] [stage] slime eat"
	else
		icon_state = "[myColor] [stage] slime"
	overlays.Cut()
	overlays += image(icon,icon_state = myFace)
