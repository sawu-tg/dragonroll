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

	var/playerStatPoints = 12 // how many stat points the player can buy
	var/playerSkillPoints = 2 // how many skills the player can buy

	var/list/playerAbilities = new // A list of the player's abilities
	var/list/playerSkills = list()
	var/list/datum/stat/playerStats = new // A list of player's stats
	var/datum/class/playerClass = new // The player's class datum

	//Stats
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

	//Skills
	var/datum/stat/woodcutting/woodcutting = new("Woodcutting","wc",FALSE,1,staticon = "res")
	var/datum/stat/mining = new("Mining","mn",FALSE,1,staticon = "res")
	var/datum/stat/fishing/fishing = new("Fishing","fh",FALSE,1,staticon = "res")
	var/datum/stat/firemaking/firemaking = new("Firemaking","fm",FALSE,1,staticon = "res")
	var/datum/stat/crafting = new("Crafting","ct",FALSE,1,staticon = "res")
	var/datum/stat/cooking = new("Cooking","ck",FALSE,1,staticon = "res")

	// The recipes that the player knows for crafting
	var/list/knownRecipes = list(new/datum/recipe/tortilla,new/datum/recipe/piecrust,new/datum/recipe/pizzacrust,new/datum/recipe/dough,new/datum/recipe/hoe,new/datum/recipe/woodboat,new/datum/recipe/hatchet,new/datum/recipe/woodwall,new/datum/recipe/wooddoor)

/datum/playerFile/New()
	playerRace = new/datum/race/Human
	//stats
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
	//skills
	playerSkills += woodcutting
	playerSkills += firemaking
	playerSkills += mining
	playerSkills += fishing
	playerSkills += crafting
	playerSkills += cooking
	woodcutting.statCurr++
	firemaking.statCurr++
	fishing.statCurr++
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
	sdel(T)

///
// Assigns the race datum to the player
///
/datum/playerFile/proc/assignRace(var/datum/race/toAssign)