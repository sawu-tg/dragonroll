/datum/controller
	var/isRunning = TRUE

/datum/controller/proc/doProcess()
	if(!isRunning)
		return