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

	var/abilityIcon = 'sprite/obj/ability.dmi'
	var/abilityState = "default_icon"

	var/abilityLevel = 1 //level the ability is at
	var/abilityMaxLevel = 10 //max level the ability can reach
	var/abilityModifier = 1 //how much HP the ability takes/gives, abilityModifier*abilityLevel

	var/abilityRange = 3 // range(abilityRange)

	var/abilityCooldownTimer = 0 // counter used to calculate cds
	var/abilityHasPenalty = FALSE
	var/abilityFizzlePenalty = 1 // abilityCooldown/abilityFizzlePenalty on cast fail
	var/abilityCooldown = 5*60 // how long until this can be used again, *60 for seconds

	var/obj/effect/abilityIconSelf // the effect path displayed on the user when cast (if any)
	var/obj/projectile/abilityProjectile // the projectile thrown when cast (if any)
	var/obj/effect/abilityIconTarget // the effect path displayed on the target

	var/mob/holder // who holds this spell, for easy access

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
	if(abilityIconSelf)
		new abilityIconSelf(casting.loc)

/datum/ability/proc/Cast(var/mob/player/caster,var/target)
	abilityCooldownTimer = abilityCooldown
	if(abilityProjectile && target != caster)
		var/obj/projectile/p = new abilityProjectile(target)
		p.loc = caster.loc
		if(abilityModifier > 0)
			p.damage = do_roll(1,abilityModifier*abilityLevel)
		else
			p.damage = -do_roll(1,-abilityModifier*abilityLevel)
	else
		if(istype(target,/mob/player))
			var/mob/player/P = target
			if(abilityModifier > 0)
				P.playerData.hp.change(do_roll(1,abilityModifier*abilityLevel))
			else
				P.playerData.hp.change(-do_roll(1,-abilityModifier*abilityLevel))
	cooldownHandler |= src

/datum/ability/proc/postCast(var/mob/player/caster,var/target)
	if(!suppressMessage)
		displayInfo("You cast [name].","[caster.name] cast [name].",caster,image(abilityIcon,icon_state=abilityState))
	if(abilityIconTarget)
		new abilityIconTarget(target:loc)

/obj/spellHolder
	name = "spell holder"
	var/mob/mobHolding
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
	usr << "<font color=green><b>Drag [name] to the slot slot you wish to assign it to!</b></font>"

/obj/spellHolder/MouseDrag(var/srcO,var/overO,var/srcLoc,var/overLoc)
	src.mouse_drag_pointer = image(icon=heldAbility.abilityIcon,icon_state=heldAbility.abilityState)

/obj/spellHolder/MouseDrop(var/obj/interface/over)
	src.mouse_drag_pointer = null
	if(over && istype(over,/obj/interface/spellContainer))
		var/obj/interface/spellContainer/t = over
		t.setTo(src)

/obj/spellHolder/proc/Cast(var/mob/user)
	if(mobHolding)
		mobHolding.casting = TRUE
		mobHolding.castingSpell = src
		mobHolding.client.mouse_pointer_icon = image(icon='sprite/obj/ability.dmi',icon_state="all")

//ABILITIES
/datum/ability/fireball
	name = "Fireball"
	desc = "Shoots a ball of fire"
	abilityRange = 8
	abilityModifier = -2
	abilityCooldown = 5*60
	abilityState = "staff"
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/fireball/blue
	abilityIconTarget = /obj/effect/target

/datum/ability/heal
	name = "Heal"
	desc = "Heals a target"
	abilityRange = 8
	abilityModifier = 1
	abilityCooldown = 1*60
	abilityState = "wand"
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/fireball/green
	abilityIconTarget = /obj/effect/heal