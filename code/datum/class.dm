/datum/class
	var/className = "Default Class"
	var/classDesc = "Generic Class"
	var/classColor = "white"
	var/list/classAbilities = list()
	var/hp_mod = 0
	var/mp_mod = 0
	var/str_mod = 0
	var/dex_mod = 0
	var/con_mod = 0
	var/wis_mod = 0
	var/int_mod = 0
	var/cha_mod = 0


//classes
/datum/class/assassin
	className = "Assassin"
	classDesc = "Stealthy and deadly, the Assassin focuses on dealing massive burst damage, and evading enemies."
	classAbilities = list(/datum/ability/assassinate)
	dex_mod = 2
	int_mod = 2
	str_mod = 2

/datum/class/manaweaver
	className = "Mana Weaver"
	classDesc = "Mana Weavers are creators of Mana-fluid based technology, and focus on crowd control and distracting enemies."
	classAbilities = list(/datum/ability/manablast)
	int_mod = 2
	str_mod = 2
	wis_mod = 2

/datum/class/whitepriest
	className = "White Priest"
	classDesc = "Wielders of light magic, White Priests heal and protect their allies, while smiting down dark foes."
	classAbilities = list(/datum/ability/heal)
	int_mod = 2
	wis_mod = 2
	mp_mod = 2

/datum/class/hunter
	className = "Hunter"
	classDesc = "Fast, agile and precise, Hunters seek out weak enemies and take them down with speed."
	classAbilities = list(/datum/ability/slowbolt)
	dex_mod = 4
	int_mod = 2

/datum/class/herbalist
	className = "Herbalist"
	classDesc = "Herbalists are masters of alchemical concoctions, able to swiftly heal or hinder."
	int_mod = 2
	wis_mod = 2
	con_mod = 2

/datum/class/defender
	className = "Defender"
	classDesc = "Defenders are masters of shield and armor, absorbing damage and taking the brunt of a fight."
	con_mod = 4
	str_mod = 2

/datum/class/knightcommander
	className = "Knight Commander"
	classDesc = "Tough and Stalward, the Knight Commander focuses on buffing their allies and keeping enemies at bay."
	str_mod = 2
	con_mod = 2
	cha_mod = 2

/datum/class/blackpriest
	className = "Black Priest"
	classDesc = "Fragile and deceptive, Black Priests wield dark magic, confusing and debilitating foes."
	int_mod = 2
	wis_mod = 2
	hp_mod = 2