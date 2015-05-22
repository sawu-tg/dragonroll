//////////////////////////////////////////////////////////////////////////////////////
// If this doesn't happen soon I will lose my fucking sanity
//////////////////////////////////////////////////////////////////////////////////////

obj/interface/slot
	mouse_opacity = 1

	var/mob/player/mymob
	var/id

	var/slotsize //What fits into this

	var/can_equip = 1 //Picking stuff up into hands, equipping corgisuits, etc.
	var/can_drop = 1  //Dropping and unequipping stuff.
	var/can_steal = 1 //Stripping other people

	var/hudx = 0 //Position relative to the centermost slot (0,0), so accepts negatives.
	var/hudy = 0

	Click()
		var/mob/player/P = usr

		if(!P || P != mymob)
			return

		P.selectSlot(id)

	proc/rebuild()
		overlays.Cut()

		for(var/atom/A in contents)
			overlays += icon(icon=A.icon,icon_state=A.icon_state)