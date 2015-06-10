/datum/playerFile
	var/playerName = "player"
	var/playerDesc = "not really that interesting"

	var/datum/race/playerRace // Race datum of the player
	var/list/playerOverlays = list() // A list of extra overlays displayed on the rebuild of a player's icon

	var/playerHair = "hair_bald_s" // The icon_state of the player's hair
	var/playerFacial = "facial_bald_s" // The icon_state of the player's facial hair

	var/playerRacePrefix = "human" // The racial prefix of the player, used for race checking

	var/playerColor = "white" // The color of a player's skin, used to tint them
	var/hairColor = "white" // The color of a player's hair, used to tint it
	var/eyeColor = "white" // The color of a player's eyes, used to tint it.

	var/list/playerExtraDesc = list()

	var/playerGender = 0 //0 = male , 1 = female, 2 = other/genderless
	var/playerGenderShort = "m" // The letter-designation of a race, used for icon changing
	var/customGender = "none" // The custom gender of the player, noun
	var/customGenderA = "none" // The custom gender of the player, pronoun

	var/list/datum/ability/playerAbilities = new // A list of the player's abilities
	var/list/datum/stat/playerStats = new // A list of player's stats
	var/datum/class/playerClass = new // The player's class datum
	var/datum/stat/hp = new("Health","hp",TRUE,10,-10,10,staticon = "hp")
	var/datum/stat/mp = new("Mana","mp",TRUE,10,0,10,staticon = "mp")
	var/datum/stat/ar = new("Armor Rating","ar",FALSE,0,staticon = "res")
	var/datum/stat/def = new("Defence","def",FALSE,10,staticon = "def")
	var/datum/stat/str = new("Strength","str",FALSE,1,staticon = "str")
	var/datum/stat/dex = new("Dexterity","dex",FALSE,1,staticon = "dex")
	var/datum/stat/con = new("Constitution","con",FALSE,1,staticon = "con")
	var/datum/stat/wis = new("Wisdom","wis",FALSE,1,staticon = "crit")
	var/datum/stat/int = new("Intelligence","int",FALSE,1,staticon = "int")
	var/datum/stat/cha = new("Charisma","cha",FALSE,1,staticon = "cha")
	var/datum/stat/save = new("Saving Throw","save",FALSE,1,staticon = "sav")
	var/datum/stat/fort = new("Fortitude Throw","fort",FALSE,1,staticon = "fort")
	var/datum/stat/ref = new("Reflex Throw","ref",FALSE,1,staticon = "reflex")
	var/datum/stat/will = new("Will Throw","will",FALSE,1,staticon = "will")

	// The recipes that the player knows for crafting
	var/list/knownRecipes = list(new/datum/recipe/hoe,new/datum/recipe/woodboat,new/datum/recipe/hatchet,new/datum/recipe/woodwall,new/datum/recipe/wooddoor)

/datum/playerFile/New()
	playerRace = new/datum/race/Human
	playerStats += hp
	playerStats += mp
	playerStats += ar
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

///
// Returns the gender of the player for strings
///
/datum/playerFile/proc/returnGender(var/alternate=FALSE)
	switch(playerGender)
		if(0)
			return alternate ? "He" : "Male"
		if(1)
			return alternate ? "She" : "Female"
		if(2)
			return alternate ? customGenderA : customGender

///
// Assigns the class datum to the player
///
/datum/playerFile/proc/assignClass(var/datum/class/toAssign)
	var/datum/class/T = new toAssign
	playerAbilities.Add(T.classAbilities)
	//hp.change(T.hp_mod)
	//mp.change(T.mp_mod)
	//str.change(T.str_mod)
	//dex.change(T.dex_mod)
	//def.change(def.statCur+T.dex_mod)
	//con.change(T.con_mod)
	//wis.change(T.wis_mod)
	//int.change(T.int_mod)
	//cha.change(T.cha_mod)
	del(T)

///
// Assigns the race datum to the player
///
/datum/playerFile/proc/assignRace(var/datum/race/toAssign)
	//hp.change(toAssign.hp_mod)
	//mp.change(toAssign.mp_mod)
	//str.change(toAssign.str_mod)
	//dex.change(toAssign.dex_mod)
	//def.change(def.statCur+toAssign.dex_mod)
	//con.change(toAssign.con_mod)
	//wis.change(toAssign.wis_mod)
	//int.change(toAssign.int_mod)
	//cha.change(toAssign.cha_mod)