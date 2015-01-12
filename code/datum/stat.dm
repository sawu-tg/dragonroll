/datum/stat
	var/statName = "noname"
	var/statOld = 0
	var/statCur = 0 // the base stat
	var/statModified = 0 // the modified stat (ie + racials, item stats)
	//statMin/statMax only are used when isLimited = TRUE, ie in case of health/mana.
	var/statMin = 0
	var/statMax = 100
	var/isLimited = FALSE

/datum/stat/New(var/name = "error", var/limit=FALSE, var/cur=0, var/min=0, var/max=100)
	if(limit)
		isLimited = limit
		statMin = min
		statMax = max
	statName = name
	statCur = cur
	statModified = cur

/datum/stat/proc/changeMin(var/amount)
	if(amount < statMax)
		statMin = amount

/datum/stat/proc/changeMax(var/amount)
	if(amount > statMin)
		statMax = amount

/datum/stat/proc/revert(var/full=FALSE)
	if(full)
		setTo(statOld)
	else
		if(statCur > statOld)
			--statCur
		else if(statCur < statOld)
			++statCur

/datum/stat/proc/setTo(var/amount)
	statOld = statCur
	if(isLimited)
		if(amount >= statMax)
			statCur = statMax
		if(amount <= statMin)
			statCur = statMin
		else
			statCur = amount
	else
		statCur = amount
	statModified = statCur

/datum/stat/proc/change(var/amount)
	if(isLimited)
		if(amount > 0)
			if(statModified + amount <= statMax)
				setTo(statCur + amount)
		else if(amount < 0)
			if(statModified - amount >= statMin)
				setTo(statCur - amount)
	else
		setTo(statCur + amount)