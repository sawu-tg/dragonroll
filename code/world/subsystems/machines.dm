var/list/globalMachines = list()

/datum/controller/machinery
	name = "Machines"
	execTime = 5

datum/controller/machinery/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])")

datum/controller/machinery/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])"

/datum/controller/machinery/doProcess()
	for(var/obj/structure/powered/A in globalMachines)
		A.process()

		scheck()