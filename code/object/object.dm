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

	var/beingCarried = FALSE
	var/mob/player/carriedBy

/obj/DblClick()
	objFunction(usr)

/obj/verb/pickupItem(mob/user)
	set name = "Pick up"
	set src in oview(1)
	if(!beingCarried)
		var/mob/player/m = user
		if(do_roll(1,20,m.playerData.str.statCur) >= weight + size)
			beingCarried = TRUE
			carriedBy = m
			addProcessingObject(src)


/obj/verb/dropItem(mob/user)
	set name = "Drop item"
	set src in oview(1)
	if(beingCarried)
		var/mob/player/m = user
		if(m == carriedBy)
			beingCarried = FALSE
			carriedBy = null
			remProcessingObject(src)

//the process of an object, ie regenerating lasers, food rotting etc
/obj/proc/doObjProcess()
	if(beingCarried)
		if(do_roll(1,20,carriedBy.playerData.str.statCur) >= weight + size)
			src.loc = carriedBy.loc

//the function of an object when used, IE switching modes or reading books
/obj/proc/objFunction(var/mob/user)
	user << "You used the [name]"