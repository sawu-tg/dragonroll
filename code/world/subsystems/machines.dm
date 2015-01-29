var/list/globalMachines = list()

/datum/controller/machinery
	name = "Machines"
	execTime = 5

/datum/controller/machinery/Stat()
	stat("[name] | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalMachines.len])")

/datum/controller/doProcess()
	for(var/obj/structure/powered/A in globalMachines)
		A.process()