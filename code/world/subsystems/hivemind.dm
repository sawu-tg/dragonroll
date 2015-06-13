var/list/globalNPCs = list()
var/list/pendingRemoval = list()

/datum/controller/hivemind
	name = "NPC Hivemind"
	execTime = 2.5

datum/controller/hivemind/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalNPCs.len])")

datum/controller/hivemind/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalNPCs.len])"

/datum/controller/hivemind/doProcess()
	set background = 1
	for(var/A in globalNPCs)
		spawn(-1)
			A:doProcess()
	scheck()