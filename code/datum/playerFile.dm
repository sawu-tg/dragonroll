/datum/playerFile
	var/playerName = "player"
	var/playerDesc = "not really that interesting"
	var/datum/race/playerRace

	var/gender = 0 //0 = male , 1 = female, 2 = other/genderless

	var/list/datum/stat/playerStats = new
	var/datum/stat/hp = new("Health",TRUE,100,0,100)
	var/datum/stat/mp = new("Mana",TRUE,100,0,100)
	var/datum/stat/str = new("Strength",FALSE,1)
	var/datum/stat/dex = new("Dexterity",FALSE,1)
	var/datum/stat/con = new("Constitution",FALSE,1)
	var/datum/stat/wis = new("Wisdom",FALSE,1)
	var/datum/stat/int = new("Intelligence",FALSE,1)
	var/datum/stat/cha = new("Charisma",FALSE,1)

/datum/playerFile/New()
	playerRace = Human
	playerStats += hp
	playerStats += mp
	playerStats += str
	playerStats += dex
	playerStats += con
	playerStats += wis
	playerStats += int
	playerStats += cha

/datum/playerFile/proc/assignRace(var/datum/race/toAssign)
	hp.change(toAssign.hp_mod)
	mp.change(toAssign.mp_mod)
	str.change(toAssign.str_mod)
	dex.change(toAssign.dex_mod)
	con.change(toAssign.con_mod)
	wis.change(toAssign.wis_mod)
	int.change(toAssign.int_mod)
	cha.change(toAssign.cha_mod)