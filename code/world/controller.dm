/datum/controller
	var/name = "default"
	var/isRunning = TRUE
	var/execTime = 30
	var/last_fire = 0
	var/next_fire = 0
	var/cpu = 0
	var/cost = 0

/datum/controller/proc/Stat()
	stat("[name] | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%)")

/datum/controller/proc/doProcess()
	if(!isRunning)
		return