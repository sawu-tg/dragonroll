#define STATUS_TIMED 1 << 0
#define STATUS_EQUIP 1 << 1
#define STATUS_TILE 1 << 2

/mob
	var/list/effectstacks = list()
	var/list/statuseffects = list()

	proc/addStatusEffect(var/effecttype,var/length=0)
		if(!effecttype) return

		var/datum/statuseffect/eff = new effecttype(src)
		if(eff.maxstack && checkStatusEffect(eff) >= eff.maxstack)
			del(eff)
			return
		eff.applyStatus()
		eff.setTime(length)

		statuseffects |= eff

		return eff

	proc/checkStatusEffect(var/datum/statuseffect/effect)
		var/n = 0
		for(var/a in statuseffects)
			if(a && a:id == effect.id)
				n++
		return n

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

	var/maxstack = 0 //0 for infinite

	//for (de)buffing a stat
	var/list/statchanges = list()

	var/obj/item/equipment //For checking equipmentbound status effects

	var/turf/tile	//For checking tilebound status effects

	var/list/addedstacks = list()

	var/removed = 0

	New(var/mob/target)
		mymob = target
		applytime = world.time

	Del()
		if(!removed)
			world << "HONK, STATUS EFFECT WAS DELETED WITHOUT REMOVING IT FIRST"
			CRASH("WAKE ME UP INSIDE")
		..()

	proc/setTime(var/time)
		if(!time)
			flags &= ~STATUS_TIMED
		else
			flags |= STATUS_TIMED

			//world << "Set [id] to timed ([time])"

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

			//if(mymob.client)
			//	world << "adding [stack] to [mymob]"

	proc/removeStatus(var/natural = 1)
		if(!mymob)
			return

		for(var/stack in addedstacks)
			mymob.remEffectStack(stack)
			//if(mymob.client)
			//	world << "removing [stack] from [mymob]"

		mymob.statuseffects -= src

		removed = 1

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

