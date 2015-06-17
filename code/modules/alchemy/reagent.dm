var/list/reagentList = list()

proc/generateReagentList()
	reagentList.Cut()

	for(var/reagenttype in typesof(/datum/reagent) - /datum/reagent)
		var/datum/reagent/R = new reagenttype()

		reagentList[R.id] = R

/datum/reagent
	var/name = "generica"
	var/hidden_name
	var/id = ""

	var/desc = "Report this."
	var/hidden_desc

	var/color = "#FFFFFF"
	var/volume
	var/datum/reagent_holder/holder

	var/reagentState = REAGENT_STATE_LIQUID

	var/firecolor = "#FFFFFF"

	proc/is_equivalent(var/datum/reagent/other)
		return istype(other,type)

	//returns 1 to implicate that this liquid is burning
	proc/process_fire()
		return 0

	//called when a reagent processes on a mob
	proc/processMob(var/mob/on)
		holder.removeliquid(id,1)
		return

	//called when a reagent processes on an obj
	proc/processObj(var/obj/on)
		holder.removeliquid(id,1)
		return