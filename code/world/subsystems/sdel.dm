var/list/deleted = list()

/datum
	var/garbageCollecting = FALSE
	var/garbageTime = 0


#define GARBAGE_PATIENCE	30 //How long a datum is allowed to sit in limbo before we hard-delete it


//Call this on a datum to start GCing it
/proc/sdel(var/datum/what)
	if(!what || what.garbageCollecting)
		return
	deleted |= what
	what.garbageCollecting = TRUE
	what.garbageTime = world.time
	what.garbageCleanup()


//Called when this datum is being garbage collected
//use this to cleanup any references to this datum
//so it GCs correctly
/datum/proc/garbageCleanup()
	return

/atom/movable/garbageCleanup()
	..()
	loc = null


//Garbage collection controller
/datum/controller/sdel
	name = "Garbage"
	execTime = 2.5
	var/list/deletePass = list()

datum/controller/sdel/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Left: [deleted.len])")

datum/controller/sdel/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Left: [deleted.len])"

/datum/controller/sdel/doProcess()
	set background = 1

	for(var/datum/D in deleted)
		if(D.garbageTime && ((D.garbageTime + GARBAGE_PATIENCE) < world.time)) //Only hard-delete if necessary
			deleted -= D
			spawn(deleted.len)
				del(D)

	scheck()