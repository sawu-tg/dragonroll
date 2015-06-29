var/list/globalChemicals = list()

proc/addChemicalHolder(var/datum/reagent_holder/RH)
	globalChemicals += RH

proc/removeChemicalHolder(var/datum/reagent_holder/RH)
	globalChemicals -= RH

/datum/controller/chemicals
	name = "Chemical Controller"
	execTime = 2.5

datum/controller/chemicals/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalChemicals.len])")

datum/controller/chemicals/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Count: [globalChemicals.len])"

/datum/controller/chemicals/Initialize()
	generateReagentList()
	generateReactionList()

/datum/controller/chemicals/doProcess()
	for(var/A in globalChemicals)
		A:life()
		scheck()

/client/verb/debug_chemical_list()
	set name = "Debug Chemical Reactions"
	set category = "Debug Verbs"
	for (var/reaction in all_reactions)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[all_reactions[reaction]]\"\n"
		if(islist(all_reactions[reaction]))
			var/list/L = all_reactions[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .