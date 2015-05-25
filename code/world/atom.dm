/atom
	var/anchored = FALSE

/atom/movable
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
	var/atom/movable/carrying
	var/myOldLayer = 0
	var/myOldPixelY = 0
	var/prevent_pickup = 0

	//throwing stuff
	var/thrown = FALSE
	var/thrownTarget
	var/thrownTimeout = 30
	var/countedTimeout = 0
	var/turf/lastTurf

//done as the atom is added to the processing list
/atom/proc/preProc()
	if(istype(src,/atom/movable))
		var/atom/movable/A = src
		if(A.thrown)
			density = 0

//done as the atom is removed from the processing list
/atom/proc/postProc()
	if(istype(src,/atom/movable))
		var/atom/movable/A = src
		if(!A.thrown)
			density = 1

//the process of an object, ie regenerating lasers, food rotting etc
/atom/proc/doProcess()
	if(istype(src,/atom/movable))
		var/atom/movable/A = src
		if(A.beingCarried)
			if(do_roll(1,20,A.carriedBy.playerData.str.statCur) >= A.weight + A.size)
				A.loc = A.carriedBy.loc
			else
				displayInfo("You fumble and lose your strength, dropping the [A.carriedBy.carrying]!","[src] drops the [A.carrying]!",A.carriedBy,src)
				A.beDropped()
		if(A.thrown)
			SpinAnimation(5,1)
			if(loc != A.thrownTarget:loc)
				if(A.lastTurf == src.loc)
					A.countedTimeout++
				if(A.countedTimeout >= A.thrownTimeout)
					A.thrown = FALSE
					A.thrownTarget = null
					A.countedTimeout = 0
				var/turf/T = get_step_to(A,A.thrownTarget)
				if(T)
					//SUE ME, COMPLAIN, I DAR-null error
					if(!T.density)
						walk_to(src,T,0,0,2)
						A.lastTurf = src.loc
					else
						A.thrown = FALSE
						A.thrownTarget = null
				else
					A.thrown = FALSE
					A.thrownTarget = null
			else
				A.thrown = FALSE
				A.thrownTarget = null

/atom/movable/proc/beDropped()
	if(beingCarried)
		layer = myOldLayer
		pixel_y = myOldPixelY
		beingCarried = FALSE
		carriedBy.carrying = null
		carriedBy = null
		remProcessingObject(src)

/atom/movable/proc/takeObject()
	if(size <= 2)
		var/mob/player/p = usr
		layer = LAYER_DEFAULT
		p.takeToActiveHand(src)
		p.refreshInterface()

/atom/movable/Click()
	var/mob/player/P = usr
	if(istype(src,/obj/interface))
		objFunction(usr)
		return
	if(!Adjacent(P))
		return
	if(P.activeHandEmpty())
		if(!prevent_pickup && !anchored)
			takeObject()
		else
			objFunction(usr)
	else
		objFunction(usr,P.activeHand())

/atom/movable/proc/throw_at(var/target)
	target = get_turf(target)
	thrownTarget = target
	thrown = TRUE
	addProcessingObject(src)

//the function of something when used, IE switching modes or reading books
/atom/movable/proc/objFunction(var/mob/user,var/obj/item/with)
	user << "You use [with ? "the [with] with" : ""] [name]"