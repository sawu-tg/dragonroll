var/global/list/deleted = list()
var/global/totalSDeletions = 0
var/global/failedSDeletions = 0
var/global/list/failedTypes = list()

/datum
	var/garbageCollecting = FALSE
	var/garbageTime = 0


#define GARBAGE_PATIENCE	300 //How long a datum is allowed to sit in limbo before we hard-delete it


//Call this on a datum to start GCing it
/proc/sdel(var/datum/what)
	if(!what || what.garbageCollecting)
		return
	totalSDeletions++
	what.garbageCollecting = TRUE
	what.garbageTime = world.time
	what.garbageCleanup()
	deleted["\ref[what]"] = what.garbageTime


//Called when this datum is being garbage collected
//use this to cleanup any references to this datum
//so it GCs correctly


//The best way to write a garbageCleanup() proc
//is to have the datum cleanup it's references to other objects
//and those that reference it.
//if the datum "contains" things (such as mobs + organs)
//then it should sdel the things it "contains"
/datum/proc/garbageCleanup()
	tag = null //REMINDER THAT TAGGED OBJECTS ARE IMMORTAL

/atom/movable/garbageCleanup()
	..()
	loc = null

//Garbage collection controller
/datum/controller/sdel
	name = "Garbage"
	execTime = 2.5
	var/list/deletePass = list()

datum/controller/sdel/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) | (Left: [deleted.len]) | (Failed: [getSDelFailures()])")

datum/controller/sdel/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) | (Left: [deleted.len]) | (Failed: [getSDelFailures()])"

/datum/controller/sdel/doProcess()
	set background = 1

	for(var/dref in deleted)
		var/datum/D = locate(dref)
		var/gctime = deleted[dref]

		if(!D)
			deleted -= dref
			continue
		else if((D.garbageTime + GARBAGE_PATIENCE) < world.time)
			if(D.garbageTime && D.garbageTime == gctime) //Only hard-delete if necessary and it's the same object. I hope this works.
				deleted -= D
				failedSDeletions++
				failedTypes["[D.type]"]++
				del(D)
			deleted -= dref

	scheck() //why is this out here!?

//This is a debug verb
/mob/verb/getFailedTypeDeletes()
	set name = "List Failed GCs"
	set category = "Debug Verbs"

	for(var/stype in failedTypes)
		usr << "[stype]: x[failedTypes[stype]]"

/proc/getSDelFailures()
	. = 0
	if(failedSDeletions && totalSDeletions)
		. = failedSDeletions/totalSDeletions

	. = "[.*100]%"

