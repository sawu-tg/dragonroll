///
// Balance Turfs
///

/turf/floor/balance
	name = "magical floor"
	desc = "where did this come from?"
	turfCreeps = TRUE

/turf/wall/balance
	name = "magical wall"
	desc = "where did this come from?"

///
// EVIL
///
/turf/floor/balance/evil
	name = "Hellish Tiling"
	desc = "It seems to resonate with an evil presence."
	icon_state = "cult"

/turf/floor/balance/evil/New()
	..()
	balance.actsEvil += src
	var/foundIn = FALSE
	for(var/obj/interact/A in src)
		sdel(A)
		foundIn = TRUE
	if(foundIn)
		new/turf/wall/balance/evil(get_turf(src))

/turf/wall/balance/evil
	name = "Hellish Wall"
	desc = "Every time it passes your peripheral vision, it seems to wiggle slightly."
	icon_state = "cult0"
	mineral = "cult"
	walltype = "cult"

/turf/wall/balance/evil/New()
	..()
	balance.actsEvil += src

///
// GOOD
///
/turf/floor/balance/good
	name = "Pristine Tiling"
	desc = "It seems to resonate with an godly presence."
	icon_state = "gold"

/turf/floor/balance/good/New()
	..()
	balance.actsGood += src

/turf/wall/balance/good
	name = "Pristine Wall"
	desc = "The surface seems impossible smooth, with no imperfections to speak of."
	icon_state = "gold0"
	mineral = "gold"
	walltype = "gold"

/turf/wall/balance/good/New()
	..()
	balance.actsGood += src