var/list/globalMachines = list()

/datum/controller/machinery
	name = "Machines"
	execTime = 15

/datum/controller/machinery/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])")

/datum/controller/machinery/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])"

/datum/controller/machinery/doProcess()
	if(globalMachines.len)
		for(var/obj/structure/powered/A in globalMachines)
			spawn(1)
				A.process()
	scheck()