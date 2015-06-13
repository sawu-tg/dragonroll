/datum/controller_master
	var/list/controllers = list()
	var/interval = 1

/datum/controller_master/proc/addControl(var/datum/controller/C)
	controllers |= C
	interval = Gcd(C.execTime, interval)
	interval = round(interval)
	C.Initialize()
	return C

/proc/isRunningSafe(var/what)
	if(CS)
		return CS.isRunning(what)
	return FALSE

/datum/controller_master/proc/isRunning(var/what)
	var/found = controllers.Find(what)
	if(found > 0)
		var/datum/controller/F = controllers[found]
		if(F)
			var/R = F.isRunning
			return R

#define MC_AVERAGE(average, current) (0.8*(average) + 0.2*(current))
// ^ thanks carn

/datum/controller_master/proc/process()
	set background = 1
	var/timer = world.time
	for(var/datum/controller/C in controllers)
		timer += interval
		C.next_fire = timer
	var/cpu
	spawn(0)
		while(TRUE)
			if(interval > 0)
				for(var/datum/controller/C in controllers)
					if(C.isRunning)
						if(C.next_fire <= world.time)
							C.next_fire += C.execTime
							timer = world.timeofday
							cpu = world.cpu
							C.last_fire = world.time
							spawn(0)
								C.doProcess()
							C.cpu = MC_AVERAGE(C.cpu,world.cpu - cpu)
							C.cost = MC_AVERAGE(C.cost, world.timeofday - timer)
							sleep(-1)
				sleep(interval)
			else
				sleep(50)

#undef MC_AVERAGE