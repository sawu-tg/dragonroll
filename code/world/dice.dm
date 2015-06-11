///
// Rolls a dice x times, for dice amount, adding bonus on post roll
///

/proc/do_roll(var/times,var/dice,var/bonus)
	var/rolled = 0
	for(var/i = 0; i < times; ++i)
		rolled += rand(1,dice)
	rolled += bonus
	. = rolled
///
// Calculates if a player can pass a saving throw
///
/proc/savingThrow(var/mob/player/try, var/bonus, var/stat=SAVING_REFLEX)
	if(!try.playerData)
		return pick(TRUE,FALSE) //no stats? screw you have some rnd

	var/datum/playerFile/data = try.playerData
	var/datum/stat/compare
	switch(stat)
		if(SAVING_REFLEX)
			compare = data.ref
			bonus += data.dex.statCurr
		if(SAVING_WILL)
			compare = data.will
			bonus += data.wis.statCurr
		if(SAVING_FORTITUDE)
			compare = data.fort
			bonus += data.con.statCurr
	if(do_roll(1,20,bonus) >= data.save.statCurr + compare.statCurr)
		return TRUE

	return FALSE