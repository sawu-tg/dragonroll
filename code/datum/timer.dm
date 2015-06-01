///
// Basic timer datum that fires every decisecond/tick.
///

/datum/timer
	var/totalTime = 1 // The time it counts for
	var/owner // Who called this timer
	var/ownerProc // The proc to be called
	var/procVars // Variables to be passed

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