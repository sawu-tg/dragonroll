/mob/player/npc/animal
	name = "animal"
	desc = "grrr"
	icon_state = "clown"
	icon = 'sprite/mob/animal.dmi'
	isMonster = TRUE
	var/isHostile = FALSE
	var/list/droppedItems = list()

	//submerging stuff
	var/submerged = FALSE
	var/submergeEffect
	var/submergeType
	var/minSubmergeTime = 10*60
	var/lastSubmerge = 0

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

		for(var/A in droppedItems)
			for(var/I = 0; I < droppedItems[A]; ++I)
				new A(src)
	classChange(/datum/class/beast)

/mob/player/npc/animal/proc/submerge()
	if(submerged)
		return
	if(submergeType)
		if(!istype(get_turf(src),submergeType))
			return
	messageArea("You submerge","[src] sinks into the [get_turf(src)]", src, src,color="red")
	lastSubmerge = world.time
	submerged = TRUE
	invisibility += 1

/mob/player/npc/animal/proc/unsubmerge()
	messageArea("You return","[src] rises from the [get_turf(src)]", src, src,color="red")
	submerged = FALSE
	invisibility -= 1
	if(invisibility < 0)
		invisibility = 0

/mob/player/npc/animal/Move(var/turf/T)
	T = get_turf(T)
	if(submerged)
		if(!istype(T,submergeType))
			return 0
	..(T)

/mob/player/npc/animal/doProcess()
	if(submerged)
		if(lastSubmerge + minSubmergeTime >= world.time)
			unsubmerge()
		if(submergeEffect)
			createEffect(get_turf(src),submergeEffect,3)
	..()

/mob/player/npc/animal/chicken
	name = "Chicken"
	desc = "You wonder where it came from."
	icon_state = "chicken_white"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/chicken/New()
	icon_state = "chicken_[pick("brown","white","black")]"
	..()

/mob/player/npc/animal/fox
	name = "Fox"
	desc = "Smarter than most things."
	icon_state = "fox"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/dog
	name = "Dog"
	desc = "Some call him \"Ian\""
	icon_state = "corgi"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap)

/mob/player/npc/animal/dog/New()
	icon_state = pick("corgi","lisa","pug","tamaskan","shepard")
	..()

/mob/player/npc/animal/crab
	name = "Crab"
	desc = "Comes with six conveniently attached sticks."
	icon_state = "crab"
	droppedItems = list(/obj/item/food/meat/fish = 2)
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/crab/New()
	icon_state = pick("evilcrab","crab")
	..()

/mob/player/npc/animal/cow
	name = "Cow"
	desc = "She likes to moo-ve it."
	icon_state = "cow"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/bear
	name = "Bear"
	desc = "Smarter than the average."
	icon_state = "bear"
	isHostile = TRUE
	droppedItems = list(/obj/item/food/meat/bear = 2)
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
	droppedItems = list(/obj/item/food/meat/spider = 2)
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
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/assassinate/leap,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/cat/New()
	icon_state = pick("cat","cat2")
	..()
	spawn(15)
		if(prob(0.1))
			name = "Miauw"


/mob/player/npc/animal/bat
	name = "Bat"
	desc = "No men here."
	icon_state = "bat"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)

/mob/player/npc/animal/wasp
	name = "Wasp"
	desc = "Pollinates figs. And nightmares."
	icon_state = "wasp"
	isHostile = TRUE
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/assassinate/gore,/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/deer
	name = "Deer"
	desc = "Neigh!."
	icon_state = "deer"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer)


///
// Popup animals
///

/mob/player/npc/animal/eater
	name = "Eater"
	desc = "It looks hungry..."
	icon_state = "otherthing"
	droppedItems = list(/obj/item/food/meat/generic = 2)
	npcSpells = list(/datum/ability/heal/lickwounds,/datum/ability/deathbeam/leer,/datum/ability/assassinate/gore,/datum/ability/toxicthrow/spit)

/mob/player/npc/animal/eater/goliath
	name = "Goliath"
	icon_state = "Goliath"

/mob/player/npc/animal/eater/giantgrub
	name = "Giant Grub"
	icon_state = "Goldgrub"

/mob/player/npc/animal/eater/basilisk
	name = "Basilisk"
	icon_state = "Basilisk"

/mob/player/npc/animal/eater/carp
	name = "Carp"
	icon_state = "carp"

/mob/player/npc/animal/eater/hivelord
	name = "Hivelord"
	icon_state = "Hivelord"


///
// Monsters of Gorekin
///

/mob/player/npc/animal/gore
	name = "Son of Gorekin"
	desc = "Maybe it's born with it, maybe it's a horrible ancient curse."
	helpInfo = "These monsters will spread extremely quickly. Destroy with much predjudice."
	icon_state = "horror"
	submergeEffect = /obj/effect/blood
	npcSpells = list(/datum/ability/assassinate/gore)

/mob/player/npc/animal/gore/unsubmerge()
	..()
	for(var/cdir in alldirs)
		bloodSpray(cdir,1,1,1)

/mob/player/npc/animal/gore/doProcess()
	..()
	if(!isDisabled())
		if(!submerged)
			if(prob(5))
				submerge()

/mob/player/npc/animal/gore/floater
	name = "Daughter of Gorekin"
	icon_state = "floatinghorror"
	npcSpells = list(/datum/ability/toxicthrow/gorethrow)

/mob/player/npc/animal/gore/spreader
	name = "Blood of Gorekin"
	desc = "Disgusting, wobbly and reeks of blood."
	icon_state = "coagblood"

/mob/player/npc/animal/gore/spreader/Move(var/turf/T)
	T = get_turf(T)
	if(T)
		if(!istype(T,/turf/floor/balance/evil/flesh))
			new/turf/floor/balance/evil/flesh(T)
	..(T)

///
// SLIMES
///

/mob/player/npc/animal/slime
	name = "Slime"
	desc = "Blib blobs all over you!."
	icon_state = "slime"

	droppedItems = list(/obj/item/food/meat/generic = 2)

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
