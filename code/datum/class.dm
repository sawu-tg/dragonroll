/datum/class
	var/className = "Default Class"
	var/classDesc = "Generic Class"
	var/classColor = "white"
	var/list/classAbilities = list(/datum/ability/fireball,/datum/ability/heal)
	var/hp_mod = 0
	var/mp_mod = 0
	var/str_mod = 0
	var/dex_mod = 0
	var/con_mod = 0
	var/wis_mod = 0
	var/int_mod = 0
	var/cha_mod = 0


//classes
/datum/class/Assistant
	className = "Assistant"

/datum/class/Engineer
	className = "Engineer"

/datum/class/Doctor
	className = "Doctor"

/datum/class/Chef
	className = "Chef"

/datum/class/Botanist
	className = "Botanist"

/datum/class/Scientist
	className = "Scientist"

/datum/class/Captain
	className = "Captain"

/datum/class/Officer
	className = "Officer"