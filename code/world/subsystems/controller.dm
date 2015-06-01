#define PROCESS_DEFAULT_SLEEP_INTERVAL		2	// 2 ticks
#define PROCESS_DEFAULT_CPU_THRESHOLD		90  // 90%

/datum/controller
	var/name = "default"
	var/isRunning = TRUE
	var/execTime = 30
	var/last_fire = 0
	var/next_fire = 0
	var/cpu = 0
	var/cost = 0

	//This stuff is taken from paradise to make lighting not lag or someshit

	var/tmp/sleep_interval = PROCESS_DEFAULT_SLEEP_INTERVAL

	// cpu_threshold - if world.cpu >= cpu_threshold, scheck() will call sleep(1) to defer further work until the next tick. This keeps a process from driving a tick into overtime (causing perceptible lag)
	var/tmp/cpu_threshold = PROCESS_DEFAULT_CPU_THRESHOLD

	// How many times in the current run has the process deferred work till the next tick?
	var/tmp/cpu_defer_count = 0

	// Records the time (server ticks) at which the process last finished sleeping
	var/tmp/last_slept = 0

/datum/controller/proc/Stat()
	stat("[name] | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%)")

/datum/controller/proc/getStat()
	return "[name] | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%)"

/datum/controller/proc/Initialize()
	return

/datum/controller/proc/doProcess()
	if(!isRunning)
		return

/datum/controller/proc/scheck(var/tickId = 0)
	if (!isRunning)
		// The kill proc is the only place where killed is set.
		// The kill proc should have deleted this datum, and all sleeping procs that are
		// owned by it.
		CRASH("A killed process is still running somehow...")

	// For each tick the process defers, it increments the cpu_defer_count so we don't
	// defer indefinitely
	if (world.cpu >= cpu_threshold + cpu_defer_count * 10)
		sleep(1)
		cpu_defer_count++
		last_slept = world.timeofday
	else
		// If world.timeofday has rolled over, then we need to adjust.
		if (world.timeofday < last_slept)
			last_slept -= 864000

		if (world.timeofday > last_slept + sleep_interval)
			// If we haven't slept in sleep_interval ticks, sleep to allow other work to proceed.
			sleep(0)
			last_slept = world.timeofday