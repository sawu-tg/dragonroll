var/list/all_reactions = list()

//Complain to -tg- about this
proc/generateReactionList()
	all_reactions.Cut()

	var/list/paths = typesof(/datum/chem_reaction) - /datum/chem_reaction

	for(var/path in paths)
		var/datum/chem_reaction/D = new path()
		var/list/reaction_ids = list()

		if(D.required_reagents && D.required_reagents.len)
			for(var/reaction in D.required_reagents)
				reaction_ids += reaction

		world << "[path]"

		// Create filters based on each reagent id in the required reagents list
		for(var/id in reaction_ids)
			if(!all_reactions[id])
				all_reactions[id] = list()
			all_reactions[id] += D
			break // Don't bother adding ourselves to other reagent ids, it is redundant.

/datum/chem_reaction
	var/id = ""

	var/required_heatmin = 0
	var/required_heatmax = INFINITY
	var/list/required_reagents = list()
	var/list/required_catalysts = list()
	var/list/required_items = list()
	var/list/required_container = null

	var/list/produced_reagents = list()

	proc/on_reaction(var/datum/reagents/holder,var/created_volume)
		return