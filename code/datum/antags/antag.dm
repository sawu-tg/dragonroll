/datum/antag
	var/name = "Bad dude"
	var/desc = "Rude and Lewd"
	var/completedObjectives = 0
	var/score = 0
	var/list/antag_objectives = list()

/datum/objective
	var/name = "objective"
	var/desc = "do things"
	var/completed = FALSE
	var/atom/target = null
	var/number = 1
	var/obj_type = OBJ_STEAL