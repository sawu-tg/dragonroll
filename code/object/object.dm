/obj
	name = "default object"
	desc = "not very interesting"
	// size and weight determine how difficult it is to pick up and whether the player can throw it far
	// size 1 = small object, like a tool or gun
	// size 2 = two handed object, like a box or a crate
	// size 3 = larger object, like a fridge or a stove
	// size 4 = largest object, like a car or a cow
	// weight is a number between 1 and 10, and is checked against the STR score of a player trying to pick it up. 1d20 vs (weight + size)
	var/size = 0
	var/weight = 0

	var/thrown = FALSE
	var/thrownTarget
	var/beingCarried = FALSE
	var/mob/player/carriedBy
	var/myOldLayer = 0

/obj/DblClick()
	objFunction(usr)

/obj/verb/pickupItem(mob/user)
	set name = "Pick up"
	set src in oview(1)
	if(!beingCarried)
		var/mob/player/m = user
		if(do_roll(1,20,m.playerData.str.statCur) >= weight + size)
			myOldLayer = layer
			layer = MOB_LAYER + 1
			pixel_y = pixel_y + 10
			beingCarried = TRUE
			carriedBy = m
			addProcessingObject(src)

/obj/verb/throwItem(mob/user)
	set name = "Throw item"
	set src in oview(1)
	if(!beingCarried)
		var/target = step(src,usr.dir)
		walk_to(src,target)
	else if(beingCarried)
		var/mob/player/m = user
		if(usr == user)
			if(do_roll(1,20,m.playerData.str.statCur) >= weight + size)
				thrownTarget = input("Throw at what") as null|anything in oview(m.playerData.str.statCur)
				dropItem(m)
				thrown = TRUE
				addProcessingObject(src)

/obj/verb/dropItem(mob/user)
	set name = "Drop item"
	set src in oview(1)
	if(beingCarried)
		var/mob/player/m = user
		if(m == carriedBy)
			layer = myOldLayer
			pixel_y = pixel_y - 10
			beingCarried = FALSE
			carriedBy = null
			remProcessingObject(src)

//the process of an object, ie regenerating lasers, food rotting etc
/obj/proc/doObjProcess()
	if(beingCarried)
		if(do_roll(1,20,carriedBy.playerData.str.statCur) >= weight + size)
			src.loc = carriedBy.loc
		else
			dropItem(carriedBy)
	if(thrown)
		if(loc != thrownTarget:loc)
			step_to(src,thrownTarget)
		else
			thrown = FALSE
			thrownTarget = null

//the function of an object when used, IE switching modes or reading books
/obj/proc/objFunction(var/mob/user)
	user << "You used the [name]"