/datum/race
	var/raceName = "raceless"
	var/raceDesc = "pretty bad"

	var/list/icon_prefix = list("human") // The race prefix of a player, given to the player
	var/raceEyes = "eyes" // The eye overlay the race uses
	var/list/race_overlays = list() // Extra overlays added to the race on a player's icon rebuild
	var/shouldColorRace = FALSE // If TRUE, the race is tinted

	//All mods should balance to 0
	var/hp_mod = 0
	var/mp_mod = 0
	var/str_mod = 0
	var/dex_mod = 0
	var/con_mod = 0
	var/wis_mod = 0
	var/int_mod = 0
	var/cha_mod = 0

	// A List of slots that the race has
	var/list/slots = list(/obj/interface/slot/hand/left,
		/obj/interface/slot/hand/right,
		/obj/interface/slot/foot/left,
		/obj/interface/slot/foot/right,
		/obj/interface/slot/pocket/left,
		/obj/interface/slot/pocket/right,
		/obj/interface/slot/chest,
		/obj/interface/slot/groin,
		/obj/interface/slot/head)

/datum/race/Human
	raceName = "Human"
	raceDesc = "The Human race, descended from the Terran people, are a well rounded, hardy people with no particular upsides, or downsides."
	icon_prefix = list("human")
	shouldColorRace = TRUE

/datum/race/Golem
	raceName = "Golem"
	raceDesc = "Golems, risen from the spell of a magical sorceror, or some natural occurence, aren't particularly bright, or charismatic, but their hardy earthen bodys make them durable in combat."
	icon_prefix = list("golem")
	shouldColorRace = TRUE
	con_mod = 2
	str_mod = 1
	int_mod = -1
	cha_mod = -2

/datum/race/Lizard
	raceName = "Lizard"
	raceDesc = "Lizard-people, from a distant, burning swamp planet, are deft, hardy (and ugly) people, but years of infighting, consuming toxic carp and swamp gas, has left them lacking the intelligence for all but the most menial tasks."
	icon_prefix = list("lizard")
	shouldColorRace = TRUE
	dex_mod = 2
	con_mod = 1
	cha_mod = -1
	int_mod = -2

/datum/race/Slime
	raceName = "Slime-person"
	raceDesc = "The result of chemical experimentation, a Slime-person is a regular human turned into a Slime-analogue. The process ruins most of the nervous system, making them a bit dim-witted, and their lack of any significant body form, makes them extremely hardy, at the cost of being weaker."
	icon_prefix = list("slime")
	shouldColorRace = TRUE
	str_mod = -2
	int_mod = -2
	con_mod = 4

/datum/race/Pod
	raceName = "Pod-person"
	raceDesc = "Pod people are horrific abominations of nature, the result of human DNA injected into engineered plant pods that reform the dead into a (mostly) human state."
	icon_prefix = list("pod")
	shouldColorRace = TRUE

/datum/race/Fly
	raceName = "Fly-person"
	raceDesc = "Fly-people are the result of a terrible bluespace accident, enhancing the scientist's natural strength and dexterity, but severely damaging his mind."
	raceEyes = "eyes_fly"
	icon_prefix = list("fly")
	str_mod = 2
	dex_mod = 2
	int_mod = -2
	cha_mod = -2

/datum/race/Jelly
	raceName = "Jelly-person"
	raceDesc = "Jelly-people are large, humanoid shaped jellies, or perhaps a Slime trying to impersonate a person. Lacking any form of bodily besides what it has absorbed, it lacks any noticeable strength."
	icon_prefix = list("jelly")
	raceEyes = "eyes_jelly"
	shouldColorRace = TRUE
	str_mod = -2
	int_mod = -1
	con_mod = 1
	dex_mod = 2

/datum/race/Ape
	raceName = "Ape-person"
	raceDesc = "Ape-people are devolved and sub-human, whether from some accident, or naturel de-evolution. They have evoled natural simian skills, such as strength and dexterity, but the process of de-evolution has ruined their wisdom."
	icon_prefix = list("ape")
	race_overlays = list("ape_overlay")
	shouldColorRace = TRUE
	str_mod = 1
	dex_mod = 1
	int_mod = 1
	wis_mod = -3

/datum/race/Spider
	raceName = "Spider-person"
	raceDesc = "Spider-people are the result of freak lab accident, creating a mixture of spider and humanoid DNA. Possesses all of the natural upsides of a spider, with the downside of being horrifying to see."
	raceEyes = "eyes_spider"
	icon_prefix = list("spider")
	shouldColorRace = TRUE
	str_mod = 2
	int_mod = 1
	cha_mod = -3

/datum/race/Spidertaur
	raceName = "Spidertaur"
	raceDesc = "Spidertaurs are a freakier lab accident, the result of trying to repair the damage done with Spider-people. The result was a horrific merging of giant spiders and spider-people, with massive strength."
	raceEyes = "eyes_spider"
	icon_prefix = list("spidertaur")
	shouldColorRace = TRUE
	str_mod = 3
	cha_mod = -3

/datum/race/Robot
	raceName = "Robot"
	raceDesc = "Robots are primarily servants, created for one purpose or another. Occasionally one will go rogue upon realising it's own existence and attempt to murder everything. It's hardy metal body makes it durable in combat, but lack of it's own mind makes it terrible for social situations."
	icon_prefix = list("robot")
	str_mod = 2
	con_mod = 2
	wis_mod = -2
	cha_mod = -2

/datum/race/Hologram
	raceName = "Hologram"
	raceDesc = "Holograms are robotic endoskeletons, surrounded by an outer holographic layer. The mix of robotics and projectors make for a strong body and mind, but the holographics create an uncanny image, making some people uncomfortable."
	icon_prefix = list("hologram")
	shouldColorRace = TRUE
	con_mod = 2
	int_mod = 2
	wis_mod = -2
	cha_mod = -2


//NPC only races
/datum/race/Grey
	raceName = "Greylien"
	raceDesc = "If it starts screaming conjuctions, you better run."
	icon_prefix = list("grey")
	shouldColorRace = TRUE
	con_mod = -4
	int_mod = 2
	wis_mod = 2

/datum/race/Genie
	raceName = "Genie"
	raceDesc = "A Mystical, bouyant being. Noted to indulge in cross-dressing as elderly maids."
	icon_prefix = list("genie")
	shouldColorRace = TRUE
	int_mod = 3
	wis_mod = 3