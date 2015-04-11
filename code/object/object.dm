/obj
	name = "default object"
	desc = "not very interesting"

/mob/player/verb/pickupItem(var/mob/user)
	set name = "Pick up"
	set src = usr
	var/what = input("Pick up what?") as null|anything in filterList(/atom/movable/,oview(1))
	if(what)
		if(what:anchored)
			return
		var/atom/movable/a = what
		var/mob/player/m = src
		if(do_roll(1,20,m.playerData.str.statCur) >= a.weight + a.size)
			a.myOldLayer = a.layer
			a.myOldPixelY = a.pixel_y
			a.layer = LAYER_OVERLAY
			a.pixel_y = a.pixel_y + 10
			a.beingCarried = TRUE
			a.carriedBy = m
			m.carrying = a
			addProcessingObject(a)
		else
			displayTo("You can't quite seem to pick [a] up!",m,a)

/mob/player/verb/throwItem(mob/user)
	set name = "Throw/Kick"
	set src = usr
	if(!carrying)
		var/list/excluded = list(src)
		excluded |= src.contents
		var/kickWhat = input("What do you want to kick?") as null|anything in filterList(/atom/movable/,view(1),excluded)
		if(kickWhat)
			if(kickWhat:anchored)
				return
			var/target = step(kickWhat,usr.dir)
			walk_to(kickWhat,target)
	else
		var/atom/movable/a = carrying
		var/mob/player/m = user
		if(do_roll(1,20,m.playerData.str.statCur) >= a.weight + a.size)
			var/t = input("Throw at what") as null|anything in filterList(/atom/movable,oview(max(m.playerData.str.statCur - (a.weight + a.size),1)))
			if(t)
				a.thrownTarget = t
				dropItem(m)
				a.thrown = TRUE
				addProcessingObject(a)

/mob/player/verb/dropItem(mob/user)
	set name = "Drop"
	set src = usr
	if(carrying)
		displayInfo("You drop the [carrying]!","[src] drops the [carrying]!",src,carrying)
		carrying.beDropped()