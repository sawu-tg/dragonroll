/atom
	var/anchored = FALSE
	var/reagentSize = 0
	var/datum/reagent_holder/reagents
	var/alignment = ALIGN_NEUTRAL

/atom/New()
	..()
	if(reagentSize > 0)
		reagents = new(src,reagentSize)

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

	var/move_delay = 4 * TICK_LAG
	var/tmp/last_move = -1000

	//throwing stuff
	var/thrown = FALSE
	var/thrownTarget
	var/thrownTimeout = 30
	var/countedTimeout = 0
	var/turf/lastTurf

 /atom/movable/Move(atom/NewLoc,Dir=0,step_x=0,step_y=0)
 	if(src.loc && get_dist(src,NewLoc) == 1)
 		if(last_move + move_delay > world.time)
 			return 0
 		. = get_dir(src,NewLoc)
 		if(. & . - 1)
 			src.glide_size = sqrt(TILE_WIDTH**2 + TILE_HEIGHT**2) / move_delay * TICK_LAG
 		else if(. < 4)
 			src.glide_size = TILE_HEIGHT / move_delay * TICK_LAG
 		else
 			src.glide_size = TILE_WIDTH / move_delay * TICK_LAG
 		. = ..(NewLoc,Dir,step_x,step_y)
 		if(.)
 			last_move = world.time
 		return .
 	. = ..(NewLoc,Dir,step_x,step_y)

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
			if(do_roll(1,20,A.carriedBy.playerData.str.statCurr) >= A.weight + A.size)
				A.loc = A.carriedBy.loc
			else
				messageArea("You fumble and lose your strength, dropping the [A.carriedBy.carrying]!","[src] drops the [A.carrying]!",A.carriedBy,src)
				A.beDropped()
		if(A.thrown)
			SpinAnimation(5,1)
			if(!loc || !A.thrownTarget)
				return
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


//the function of something when used, IE switching modes or reading books
/atom/proc/objFunction(var/mob/user,var/obj/item/with)
	//
//called when an object is used
/atom/proc/onUsed(var/mob/user,var/atom/onWhat)
	//
/atom/Click(var/object,var/location,var/control,var/params)
	var/mob/player/P = usr
	var/obj/item/A = P.activeHand()
	if(world.time <= P.lastClick + GLOBAL_CLICK_DELAY)
		return
	P.lastClick = world.time
	if(istype(src,/obj/interface))
		objFunction(usr)
		return
	if(P.activeHandEmpty())
		if(!Adjacent(P))
			return
	else
		if(get_dist(P,src) > A.range)
			return
	var/atom/movable/AM = src
	if(P.activeHandEmpty())
		if(istype(AM) && !AM.prevent_pickup && !AM.anchored)
			AM.takeObject()
		else
			objFunction(usr)
	else
		objFunction(usr,A)
		A.onUsed(usr,src)

/atom/movable/proc/throw_at(var/target)
	target = get_turf(target)
	thrownTarget = target
	thrown = TRUE
	addProcessingObject(src)

/obj/effect/overlay/beam
	name="beam"
	icon='sprite/obj/beam.dmi'
	icon_state="b_beam"
	length = 0
	var/time = 0
	var/atom/BeamSource

/obj/effect/overlay/beam/New()
	..()
	spawn(5)
		addProcessingObject(src)

/obj/effect/overlay/beam/garbageCleanup()
	..()
	remProcessingObject(src)
	BeamSource = null

/obj/effect/overlay/beam/doProcess()
	if(!BeamSource || world.time > time)
		sdel(src)

/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget,icon_state="r_beam",icon='sprite/obj/beam.dmi',time=50, maxdistance=100)
	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime=world.time+time
	while(BeamTarget&&world.time<EndTime&&get_dist(src,BeamTarget)<maxdistance&&z==BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		dir=get_dir(src,BeamTarget)	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10,src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of trying to manipulate all the
				sdel(O)							//pieces to a new orientation.
		var/Angle=round(Get_Angle(src,BeamTarget))
		var/icon/I=new(icon,icon_state)
		I.Turn(Angle)
		var/DX=(32*BeamTarget.x+BeamTarget.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTarget.y+BeamTarget.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/length=round(sqrt((DX)**2+(DY)**2))
		for(N,N<length,N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.time = EndTime
			X.BeamSource=src
			if(N+32>length)
				var/icon/II=new(icon,icon_state)
				II.DrawBox(null,1,(length-N),32,32)
				II.Turn(Angle)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(Angle)+32*sin(Angle)*(N+16)/32)
			var/Pixel_y=round(cos(Angle)+32*cos(Angle)*(N+16)/32)
			if(DX==0) Pixel_x=0
			if(DY==0) Pixel_y=0
			if(Pixel_x>32)
				for(var/a=0, a<=Pixel_x,a+=32)
					X.x++
					Pixel_x-=32
			if(Pixel_x<-32)
				for(var/a=0, a>=Pixel_x,a-=32)
					X.x--
					Pixel_x+=32
			if(Pixel_y>32)
				for(var/a=0, a<=Pixel_y,a+=32)
					X.y++
					Pixel_y-=32
			if(Pixel_y<-32)
				for(var/a=0, a>=Pixel_y,a-=32)
					X.y--
					Pixel_y+=32
			X.pixel_x=Pixel_x
			X.pixel_y=Pixel_y
		sleep(3)	//Changing this to a lower value will cause the beam to follow more smoothly with movement, but it will also be more laggy.
					//I've found that 3 ticks provided a nice balance for my use.
