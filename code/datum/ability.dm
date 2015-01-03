/datum/ability
	var/name = "default name"
	var/desc = "no description"

	var/suppressMessage = FALSE

	var/requiresCheck = FALSE
	var/skillStatIndex = 1 //index in playerStats that will be rolled for a check
	var/skillStatMin = 0 //minimum of roll required to actually cast
	var/skillStatDifficultyLower = 1 // lower d upper + playerSkills[skillStatIndex] >= skillStatMin
	var/skillStatDifficultyUpper = 6
	var/skillStatMax = 10 //if the roll passes this, it's a critical cast

	var/abilityIcon = 'sprite/ability.dmi'
	var/abilityState = "default_icon"

	var/abilityLevel = 1
	var/abilityMaxLevel = 10

	var/abilityRange = 3 // range(abilityRange)

	var/abilityCooldownTimer = 0 // counter used to calculate cds
	var/abilityHasPenalty = FALSE
	var/abilityFizzlePenalty = 1 // abilityCooldown/abilityFizzlePenalty on cast fail
	var/abilityCooldown = 5*60 // how long until this can be used again, *60 for seconds


/datum/ability/proc/tryCast(var/mob/player/caster,var/target)
	if(canCast(caster))
		preCast(caster,target)
		Cast(caster,target)
		postCast(caster,target)

/datum/ability/proc/canCast(var/mob/player/checked)
	if(abilityCooldownTimer == 0)
		var/datum/stat/checkStat = checked.playerData.playerStats[skillStatIndex]
		if(do_roll(skillStatDifficultyLower,skillStatDifficultyUpper,checkStat.statCur) >= skillStatMin)
			return TRUE
		else
			if(abilityHasPenalty)
				abilityCooldownTimer = abilityCooldown/abilityFizzlePenalty
			if(!suppressMessage)
				displayInfo("You try to cast [name], but it fizzles!","[checked.name] attempts to cast [name], but it fizzles!",checked,image(abilityIcon,icon_state=abilityState))
			return FALSE

/datum/ability/proc/preCast(var/mob/player/casting,var/target)
	if(!suppressMessage)
		displayInfo("You begin casting [name].","[casting.name] begins casting [name].",casting,image(abilityIcon,icon_state=abilityState))

/datum/ability/proc/Cast(var/mob/player/caster,var/target)
	abilityCooldownTimer = abilityCooldown
	cooldownHandler.Add(src)

/datum/ability/proc/postCast(var/mob/player/caster,var/target)
	if(!suppressMessage)
		displayInfo("You cast [name].","[caster.name] cast [name].",caster,image(abilityIcon,icon_state=abilityState))

/obj/spellHolder
	name = "spell holder"
	var/datum/ability/heldAbility

/obj/spellHolder/New(var/datum/ability/a)
	if(!a)
		return
	heldAbility = a
	name = heldAbility.name
	if(heldAbility.abilityCooldownTimer)
		name += " ([round(heldAbility.abilityCooldownTimer/60)]-CD)"
	desc = heldAbility.desc

/obj/spellHolder/proc/updateName()
	name = heldAbility.name
	if(heldAbility.abilityCooldownTimer)
		name += " ([round(heldAbility.abilityCooldownTimer/60)]-CD)"

/obj/spellHolder/Click()
	var/target = input("Cast [name] on who?") as null|anything in range(heldAbility.abilityRange)
	if(target)
		heldAbility.tryCast(usr,target)

//ABILITIES
/datum/ability/test_spell
	name = "Test spell"
	desc = "Testing spell"




