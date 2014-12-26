/datum/stat
	var/statName = "noname"
	var/statCur = 0
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

/datum/stat/proc/changeMin(var/amount)
	if(amount < statMax)
		statMin = amount

/datum/stat/proc/changeMax(var/amount)
	if(amount > statMin)
		statMax = amount

/datum/stat/proc/change(var/amount)
	if(isLimited)
		if(amount > 0)
			if(statCur + amount <= statMax)
				statCur += amount
		else if(amount < 0)
			if(statCur - amount >= statMin)
				statCur -= amount
	else
		if(amount > 0)
			statCur += amount
		else if(amount < 0)
			statCur -= amount