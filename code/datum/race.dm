/datum/race
	var/raceName = "raceless"
	var/raceDesc = "pretty bad"

	var/hp_mod = 0
	var/mp_mod = 0
	var/str_mod = 0
	var/dex_mod = 0
	var/con_mod = 0
	var/wis_mod = 0
	var/int_mod = 0
	var/cha_mod = 0

/datum/race/Human
	raceName = "Human"
	raceDesc = "Generic human"
	hp_mod = 0
	mp_mod = 0
	str_mod = 0
	dex_mod = 0
	con_mod = 0
	wis_mod = 0
	int_mod = 0
	cha_mod = 0

/datum/race/Golem
	raceName = "Golem"
	raceDesc = "Generic golem"
	con_mod = 2
	cha_mod = -2

/datum/race/Lizard
	raceName = "Lizard"
	raceDesc = "Generic lizard"
	dex_mod = 2
	con_mod = -2

/datum/race/Slime
	raceName = "Slime-person"
	raceDesc = "Generic slime-person"
	str_mod = -2
	con_mod = 2

/datum/race/Pod
	raceName = "Pod-person"
	raceDesc = "Generic pod-person"

/datum/race/Fly
	raceName = "Fly-person"
	raceDesc = "Generic fly-person"
	str_mod = 2
	int_mod = -2
	cha_mod = -2

/datum/race/Jelly
	raceName = "Jelly-person"
	raceDesc = "Generic jelly-person"
	str_mod = -2
	dex_mod = 2