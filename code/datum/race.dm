/datum/race
	var/raceName = "raceless"
	var/raceDesc = "pretty bad"

	var/list/icon_prefix = "caucasian1"
	var/raceEyes = "eyes"
	var/list/race_overlays = list()
	var/shouldColorRace = FALSE

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
	icon_prefix = list("caucasian1","caucasian2","caucasian3","latino","mediterranean","asian1","asian2","arab","indian","african1","african2","albino")

/datum/race/Golem
	raceName = "Golem"
	raceDesc = "Generic golem"
	icon_prefix = list("golem")
	shouldColorRace = TRUE
	con_mod = 2
	cha_mod = -2

/datum/race/Lizard
	raceName = "Lizard"
	raceDesc = "Generic lizard"
	icon_prefix = list("lizard")
	shouldColorRace = TRUE
	dex_mod = 2
	con_mod = -2

/datum/race/Slime
	raceName = "Slime-person"
	raceDesc = "Generic slime-person"
	icon_prefix = list("slime")
	shouldColorRace = TRUE
	str_mod = -2
	con_mod = 2

/datum/race/Pod
	raceName = "Pod-person"
	raceDesc = "Generic pod-person"
	icon_prefix = list("pod")
	shouldColorRace = TRUE

/datum/race/Fly
	raceName = "Fly-person"
	raceDesc = "Generic fly-person"
	raceEyes = "eyes_fly"
	icon_prefix = list("fly")
	str_mod = 2
	int_mod = -2
	cha_mod = -2

/datum/race/Jelly
	raceName = "Jelly-person"
	raceDesc = "Generic jelly-person"
	icon_prefix = list("jelly")
	raceEyes = "eyes_jelly"
	shouldColorRace = TRUE
	str_mod = -2
	dex_mod = 2

/datum/race/Ape
	raceName = "Ape-person"
	raceDesc = "Generic ape-person"
	icon_prefix = list("ape")
	race_overlays = list("ape_overlay")
	shouldColorRace = TRUE
	str_mod = 2
	dex_mod = -3
	int_mod = 1

/datum/race/Spider
	raceName = "Spider-person"
	raceDesc = "Generic ape-person"
	raceEyes = "eyes_spider"
	icon_prefix = list("spider")
	shouldColorRace = TRUE
	str_mod = 2
	cha_mod = -2

/datum/race/Spidertaur
	raceName = "Spidertaur"
	raceDesc = "Generic ape-person"
	raceEyes = "eyes_spider"
	icon_prefix = list("spidertaur")
	shouldColorRace = TRUE
	str_mod = 3
	cha_mod = -3

/datum/race/Robot
	raceName = "Robot"
	raceDesc = "Generic robot"
	icon_prefix = list("robot")
	str_mod = 2
	con_mod = 2
	wis_mod = -2
	cha_mod = -2

/datum/race/Hologram
	raceName = "Hologram"
	raceDesc = "Generic hologram"
	icon_prefix = list("hologram")
	shouldColorRace = TRUE
	str_mod = 2
	con_mod = 1
	dex_mod = 1
	wis_mod = -2
	cha_mod = -2