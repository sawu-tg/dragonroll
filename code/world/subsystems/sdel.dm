var/list/deleted = list()

/proc/sdel(var/what)
	if(!what)
		return
	deleted |= what
	if(istype(what,/obj) || istype(what,/mob))
		spawn(5)
			if(what) // make sure we haven't already been collected
				what:loc = null

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
	deletePass = deleted.Copy(0,deleted.len)
	for(var/A in deletePass)
		deleted -= A
		spawn(deleted.len)
			del(A)
	scheck()