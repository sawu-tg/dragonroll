/mob/player/npc/boss
	name = "boss"
	desc = "grrr"
	icon_state = ""
	icon = 'sprite/mob/boss.dmi'
	forceRace = /datum/race/Boss
	var/bossLevel = 2 // how many * normal the stats are
	isMonster = TRUE
	npcNature = NPCTYPE_AGGRESSIVE
	alignment = ALIGN_EVIL

/mob/player/npc/boss/New()
	actualIconState = icon_state
	..()
	spawn(10)
		for(var/datum/stat/S in playerData.playerStats)
			S.setBaseTo(S.statModified * bossLevel)
			S.change(S.statModified)
		recalculateBaseStats()
		recalculateStats()
	mobFaction = findFaction("Hostile")
	popup("<b>[name]</b>",COL_HOSTILE,tsize=16,fadetime=0)

///
// Or'otsk, the shadow of Death
///
/mob/player/npc/boss/orotsk
	name = "Or'otsk, the Shadow of Death"
	desc = "He pulses with a dark aura, which seems to leech the very life of it's surroundings"
	icon_state = "death"
	npcSpells = list(/datum/ability/deathbeam,/datum/ability/toxicthrow,/datum/ability/slowbolt)