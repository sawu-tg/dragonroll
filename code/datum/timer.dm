/datum/timer
	var/totalTime = 1
	var/owner
	var/ownerProc
	var/procVars

/datum/timer/proc/fire()
	if(totalTime > 0)
		totalTime--
		spawn(1)
			fire()
	else
		call(owner,ownerProc)(procVars)

/datum/timer/New(var/total,var/holder,var/toproc,var/passedData)
	totalTime = total
	owner = holder
	ownerProc = toproc
	procVars = passedData
	fire()