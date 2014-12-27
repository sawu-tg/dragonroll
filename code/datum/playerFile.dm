/datum/playerFile
	var/playerName = "player"
	var/playerDesc = "not really that interesting"

	var/datum/race/playerRace
	var/list/playerOverlays = list()

	var/playerHair = "bald_s"
	var/playerFacial = "bald_s"

	var/playerRacePrefix = "caucasian1"

	var/playerColor = "white"
	var/hairColor = "white"
	var/eyeColor = "white"

	var/list/playerExtraDesc = list()

	var/playerGender = 0 //0 = male , 1 = female, 2 = other/genderless
	var/playerGenderShort = "m"
	var/customGender = "none"

	var/list/datum/stat/playerStats = new
	var/datum/stat/hp = new("Health",TRUE,10,0,10)
	var/datum/stat/mp = new("Mana",TRUE,10,0,10)
	var/datum/stat/def = new("Defence",FALSE,10)
	var/datum/stat/str = new("Strength",FALSE,1)
	var/datum/stat/dex = new("Dexterity",FALSE,1)
	var/datum/stat/con = new("Constitution",FALSE,1)
	var/datum/stat/wis = new("Wisdom",FALSE,1)
	var/datum/stat/int = new("Intelligence",FALSE,1)
	var/datum/stat/cha = new("Charisma",FALSE,1)
	var/datum/stat/save = new("Saving Throw",FALSE,1)
	var/datum/stat/fort = new("Fortitude Throw",FALSE,1)
	var/datum/stat/ref = new("Reflex Throw",FALSE,1)
	var/datum/stat/will = new("Will Throw",FALSE,1)

/datum/playerFile/New()
	playerRace = new/datum/race/Human
	playerStats += hp
	playerStats += mp
	playerStats += def
	playerStats += str
	playerStats += dex
	playerStats += con
	playerStats += wis
	playerStats += int
	playerStats += cha
	playerStats += save
	playerStats += fort
	playerStats += ref
	playerStats += will

/datum/playerFile/proc/returnGender()
	switch(playerGender)
		if(0)
			return "Male"
		if(1)
			return "Female"
		if(2)
			return customGender

/datum/playerFile/proc/assignRace(var/datum/race/toAssign)
	hp.change(toAssign.hp_mod)
	mp.change(toAssign.mp_mod)
	str.change(toAssign.str_mod)
	dex.change(toAssign.dex_mod)
	def.change(def.statCur+toAssign.dex_mod)
	con.change(toAssign.con_mod)
	wis.change(toAssign.wis_mod)
	int.change(toAssign.int_mod)
	cha.change(toAssign.cha_mod)