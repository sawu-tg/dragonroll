///
// WARNING BE TO YE WHO VENTURE BEYOND HERE, THAR LIES YE OLDE SHITTECODDE (This needs a rewrite)
///

/datum/stat
	var/statName = "noname"
	var/statIcon = ""
	var/statOld = 0 // The previous value of a stat before change
	var/statCur = 0 // The unmodified, base value of the stat
	var/statModified = 0 // The modified, inclusive value of the stat
	//statMin/statMax only are used when isLimited = TRUE, ie in case of health/mana.
	var/statMin = 0 // The minimum a stat can reach
	var/statMax = 100 // The Maximum a stat can reach
	var/isLimited = FALSE // Toggles capping between statMin and statMax
	var/list/affecting = list() //???

/datum/stat/New(var/name = "error", var/limit=FALSE, var/cur=0, var/min=0, var/max=100, var/staticon = "")
	if(limit)
		isLimited = limit
		statMin = min
		statMax = max
	statName = name
	statCur = cur
	statModified = cur
	statIcon = staticon

	statOld = statCur

///
// Modifies the minimum of the stat
///
/datum/stat/proc/changeMin(var/amount)
	if(amount < statMax)
		statMin = amount

///
// Modifies the maximum of the stat
///
/datum/stat/proc/changeMax(var/amount)
	if(amount > statMin)
		statMax = amount

///
// Reverts a modified stat to the statOld value. If passed TRUE, does it at once, else it does it by one point
///
/datum/stat/proc/revert(var/full=FALSE)
	if(full)
		setTo(statOld)
	else
		if(statCur > statOld)
			--statCur
		else if(statCur < statOld)
			++statCur

///
// Temp. modifies the stat to the given amount, sets statOld.
///
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

///
// Removes points from the modified amount of the stat
///
/datum/stat/proc/remFrom(var/amount)
	statModified -= amount

///
// Adds points to the modified stat
///
/datum/stat/proc/addTo(var/amount)
	statModified += amount

///
// Changes the stat by the given amount, calls setTo.
///
/datum/stat/proc/change(var/amount)
	//world << "changing [statName] to [statCur + amount]"

	if(isLimited)
		if(amount > 0)
			setTo(min(statMax,statCur + amount))
		else if(amount < 0)
			setTo(max(statMin,statCur + amount))
	else
		setTo(statCur + amount)