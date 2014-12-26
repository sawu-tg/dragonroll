//playable races
var/list/datum/race/playableRaces = list(Human,Golem,Lizard,Slime,Pod,Fly,Jelly)
var/datum/race/Human = new("Human", "Generic human", 0,0,0,0,0,0,0,0)
var/datum/race/Golem = new("Golem", "Generic golem", 0,0,0,0,2,0,0,-2)
var/datum/race/Lizard = new("Lizard", "Generic lizard", 0,0,0,2,-2,0,0,0)
var/datum/race/Slime = new("Slime-person", "Generic slime-person", 0,0,-2,0,2,0,0,0)
var/datum/race/Pod = new("Pod-person", "Generic pod-person", 0,0,0,0,0,0,0,0)
var/datum/race/Fly = new("Fly-person", "Generic fly-person", 0,0,2,0,0,0,-2,-2)
var/datum/race/Jelly = new("Jelly-person", "Generic jelly-person", 0,0,-2,2,0,0,0,0)

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

/datum/race/New(var/name = "errorname", var/desc = "errordesc", var/hp = 0, var/mp = 0, var/str = 0, var/dex = 0, var/con = 0, var/wis = 0, var/int = 0, var/cha = 0)
	raceName = name
	raceDesc = desc
	hp_mod = hp
	mp_mod = mp
	str_mod = str
	dex_mod = dex
	con_mod = con
	wis_mod = wis
	int_mod = int
	cha_mod = cha