/mob/player/npc/boss
	name = "boss"
	desc = "grrr"
	icon_state = ""
	icon = 'sprite/mob/boss.dmi'
	forceRace = /datum/race/Boss
	statScaling = 3.5 // how many * normal the stats are
	isMonster = TRUE
	npcNature = NPCTYPE_AGGRESSIVE
	alignment = ALIGN_EVIL
	var/bossTurfType

/mob/player/npc/boss/New()
	actualIconState = icon_state
	..()
	mobFaction = findFaction("Hostile")
	popup("<b>[name]</b>",COL_HOSTILE,tsize=16,fadetime=0)
	messageSystemAll("<b>[name]</b> has entered [levelNames[z]]!")
	if(bossTurfType)
		new bossTurfType(get_turf(src))

/mob/player/npc/boss/Move(var/turf/T)
	..(T)
	T = get_turf(T)
	if(bossTurfType)
		if(!istype(T,bossTurfType))
			new bossTurfType(T)

///
// Or'otsk, the shadow of Death
///
/mob/player/npc/boss/orotsk
	name = "Or'otsk, the Shadow of Death"
	desc = "He pulses with a dark aura, which seems to leech the very life of it's surroundings"
	icon_state = "death"
	npcSpells = list(/datum/ability/deathbeam,/datum/ability/toxicthrow,/datum/ability/slowbolt)
	bossTurfType = /turf/floor/balance/evil

/mob/player/npc/boss/gorekin
	name = "Gorekin, the Tender of Flesh"
	desc = "A writhing mass of bastard flesh and magic, it's skin seems to reach out for you, asking you to join it."
	icon_state = "gorekin"
	npcSpells = list(/datum/ability/toxicthrow/gorethrow)
	bossTurfType = /turf/floor/balance/evil/flesh

/mob/player/npc/boss/gorekin/doProcess()
	..()
	if(prob(25))
		if(playerThralls.len < maxThralls)
			var/thrallType = pick(/mob/player/npc/animal/gore,/mob/player/npc/animal/gore/floater,/mob/player/npc/animal/gore/spreader)
			addThrall(thrallType,60)

/mob/player/npc/boss/remrem
	name = "Rem-a'Rem, the Purifier"
	desc = "Though she floats ominously, your mind seems to fill with a calming song."
	icon_state = "remrem"
	npcSpells = list(/datum/ability/taunt,/datum/ability/toxicthrow,/datum/ability/slowbolt)
	bossTurfType = /turf/floor/balance/evil

/mob/player/npc/boss/remrem/New()
	..()
	var/image/I = new('sprite/mob/boss.dmi',icon_state = "remrem_overlay")
	I.layer = LAYER_LIGHTING + 1
	overlays += 1