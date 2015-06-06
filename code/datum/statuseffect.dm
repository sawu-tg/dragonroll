#define STATUS_TIMED 1 << 0
#define STATUS_EQUIP 1 << 1
#define STATUS_TILE 1 << 2

/mob
	var/list/effectstacks = list()
	var/list/statuseffects = list()

	proc/addStatusEffect(var/effecttype,var/length=0)
		if(!effecttype) return

		var/datum/statuseffect/eff = new effecttype(src)
		if(checkStatusEffect(eff))
			del(eff)
			return
		eff.setTime(length)

		statuseffects |= eff

		return eff

	proc/checkStatusEffect(var/datum/statuseffect/effect)
		for(var/a in statuseffects)
			if(a:id == effect.id)
				return TRUE
		return FALSE

	proc/remStatusEffect(var/datum/statuseffect/eff,var/natural=1)
		if(!eff) return

		statuseffects -= eff
		eff.removeStatus(natural)

	proc/addEffectStack(var/id,var/amt=1)
		if(!id)
			return

		effectstacks[id] += amt

	proc/remEffectStack(var/id,var/amt=1)
		if(!id)
			return

		effectstacks[id] -= amt

	proc/checkEffectStack(var/id)
		if(!id)
			return

		return effectstacks[id]

/mob/player/addStatusEffect()
	. = ..()

	recalculateStats()

/mob/player/remStatusEffect()
	. = ..()

	recalculateStats()

/datum/statuseffect
	var/id = ""
	var/name = "normal"
	var/desc = "report this"
	var/mob/mymob

	var/flags = 0

	var/applytime = 0
	var/maxtime = 0

	//for (de)buffing a stat
	var/list/statchanges = list()

	var/obj/item/equipment //For checking equipmentbound status effects

	var/turf/tile	//For checking tilebound status effects

	var/list/addedstacks = list()

	New(var/mob/target)
		mymob = target
		applytime = world.time

		applyStatus()

	proc/setTime(var/time)
		if(!time)
			flags &= ~STATUS_TIMED
		else
			flags |= STATUS_TIMED

		maxtime = time

		return src

	proc/setEquipment(var/obj/item/I)
		if(!I)
			flags &= ~STATUS_EQUIP
		else
			flags |= STATUS_EQUIP

		equipment = I

		return src

	proc/setTile(var/turf/T)
		if(!T)
			flags &= ~STATUS_TILE
		else
			flags |= STATUS_TILE

		tile = T

		return src

	proc/applyStatus()
		if(!mymob)
			return

		for(var/stack in addedstacks)
			mymob.addEffectStack(stack)

	proc/removeStatus(var/natural = 1)
		if(!mymob)
			return

		for(var/stack in addedstacks)
			mymob.remEffectStack(stack)

		mymob.statuseffects -= src

		if(istype(mymob,/mob/player))
			var/mob/player/P = mymob
			P.recalculateStats()

		del(src)

	proc/tickStatus()
		if(!mymob)
			return

		if((flags & STATUS_TIMED) && world.time > applytime + maxtime)
			removeStatus(1)

		if((flags & STATUS_EQUIP) &&  !(equipment && equipment in mymob.contents))
			removeStatus(1)

		if((flags & STATUS_TILE) && !(tile && mymob in tile.contents))
			removeStatus(1)

	proc/recalculateStat(var/datum/stat/S)
		var/statmod = statchanges[S.statId]

		//world << "[S.statId]: [S.statModified] + [statmod]"

		S.statModified += statmod

