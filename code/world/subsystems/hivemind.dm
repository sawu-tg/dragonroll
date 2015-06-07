var/list/globalNPCs = list()

/datum/controller/hivemind
	name = "NPC Hivemind"
	execTime = 2.5

datum/controller/hivemind/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalNPCs.len])")

datum/controller/hivemind/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalNPCs.len])"

/datum/controller/hivemind/doProcess()
	for(var/A in globalNPCs)
		A:doProcess()
	scheck()