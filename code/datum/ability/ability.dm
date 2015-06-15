/datum/ability
	var/name = "default name"
	var/desc = "no description"

	var/suppressMessage = FALSE // Causes the ability to not show a message

	var/requiresCheck = FALSE // Toggles the checking of required statistics
	var/skillStatIndex = 1 //index in playerStats that will be rolled for a check
	var/skillStatMin = 0 //minimum of roll required to actually cast
	var/skillStatDifficultyLower = 1 // lower d upper + playerSkills[skillStatIndex] >= skillStatMin
	var/skillStatDifficultyUpper = 6 // The upper of the check
	var/skillStatMax = 10 //if the roll passes this, it's a critical cast
	var/abilityManaMod = 2 //mana cost is level*manaMod

	var/abilityIcon = 'sprite/obj/ability.dmi'
	var/abilityState = "default_icon"

	var/abilityLevel = 1 //level the ability is at
	var/abilityMaxLevel = 10 //max level the ability can reach
	var/abilityModifier = 1 //how much HP the ability takes/gives, abilityModifier*abilityLevel

	var/abilityRange = 3 // range(abilityRange)
	var/abilityHitsPlayers = FALSE // ensures the abilty finds a player (or atom_movable)
	var/abilityEffect = 0 // the flag which the ability will apply on the target

	var/abilityCooldownTimer = 0 // counter used to calculate cds
	var/abilityHasPenalty = FALSE
	var/abilityFizzlePenalty = 1 // abilityCooldown/abilityFizzlePenalty on cast fail
	var/abilityCooldown = 5*60 // how long until this can be used again, *60 for seconds

	var/obj/projectile/abilityCastedProjectile // casted projectile for spell tracking etc

	var/abilityAoe = 0 // if > 0, equals the damage range the ability is cast, if it is negative, its self cast around it
	var/abilityProjectiles = 1 // amount of projectiles cast
	var/obj/effect/abilityIconSelf // the effect path displayed on the user when cast (if any)
	var/obj/projectile/abilityProjectile // the projectile thrown when cast (if any)
	var/obj/effect/abilityIconTarget // the effect path displayed on the target, or in the case of AOE, around it

	var/mob/holder // who holds this spell, for easy access

/datum/ability/garbageCleanup()
	..()
	holder = null

///
// Tests if the ability can be casted, and then casts it.
///
/datum/ability/proc/tryCast(var/caster,var/target)
	if(!caster)
		return
	if(!target)
		return
	if(canCast(caster))
		if(istype(caster,/mob/player))
			caster:playerData.mp.change(abilityLevel * abilityManaMod)
		preCast(caster,target)
		Cast(caster,target)
		postCast(caster,target)

///
// Checks if the player is able to cast the ability
///
/datum/ability/proc/canCast(var/checked)
	if(abilityCooldownTimer <= 0)
		if(!istype(checked,/mob/player))
			return TRUE
		var/datum/stat/checkStat = checked:playerData.playerStats[skillStatIndex]
		if(do_roll(skillStatDifficultyLower,skillStatDifficultyUpper,checkStat.statCurr) >= skillStatMin)
			if(checked:playerData.mp.statCurr >= abilityLevel * abilityManaMod)
				return TRUE
			else
				messagePlayer("You don't have enough mana to cast the spell!",checked,checked)
		else
			if(abilityHasPenalty)
				abilityCooldownTimer = abilityCooldown/abilityFizzlePenalty
			if(!suppressMessage)
				messageArea("You try to cast [name], but it fizzles!","[checked:name] attempts to cast [name], but it fizzles!",checked,image(abilityIcon,icon_state=abilityState))
			return FALSE

///
// Called before casting.
///
/datum/ability/proc/preCast(var/mob/player/casting,var/target)
	if(!suppressMessage)
		messageArea("You begin casting [name].","[casting.name] begins casting [name].",casting,image(abilityIcon,icon_state=abilityState))
	if(abilityIconSelf)
		new abilityIconSelf(casting.loc)

///
// Places an AOE for the ability on the given turf
///
/datum/ability/proc/placeAoe(var/turf/where)
	var/obj/effect/aoe_tile/A = new abilityIconTarget(where)
	A.damage = do_roll(1,abilityModifier*abilityLevel)
	A.length = (abilityModifier*abilityLevel)*60

///
// Casts the ability, from the given player, to the target
///
/datum/ability/proc/Cast(var/mob/player/caster,var/target)
	abilityCooldownTimer = abilityCooldown
	if(abilityHitsPlayers && !istype(target,/atom/movable))
		target = locate(/atom/movable) in target:loc
	if(!istype(target,/atom/movable) && abilityHitsPlayers)
		return
	if(abilityAoe != 0)
		var/max = abilityAoe < 0 ? -abilityAoe : abilityAoe
		var/counter
		for(counter = 1; counter <= max; ++counter)
			for(var/turf/T in circle(abilityAoe < 0 ? holder : target,counter))
				if(!locate(abilityIconTarget) in T)
					new/datum/timer(counter*5,src,"placeAoe",T)
	else
		if(abilityProjectile && target != caster && !caster.Adjacent(target))
			var/list/inArea = oview(abilityRange,caster)
			var/spawned = 0
			for(var/turf/T in inArea)
				if(spawned < abilityProjectiles)
					abilityCastedProjectile = new abilityProjectile(target,caster)
					abilityCastedProjectile.loc = caster.loc
					abilityCastedProjectile.effect = abilityEffect
					abilityCastedProjectile.effectLength = ((abilityModifier < 0 ? -abilityModifier : abilityModifier)*abilityLevel)*60
					if(abilityModifier > 0)
						abilityCastedProjectile.damage = do_roll(1,abilityModifier*abilityLevel)
					else
						abilityCastedProjectile.damage = -do_roll(1,-abilityModifier*abilityLevel)
					spawned++;
		else
			if(istype(target,/mob/player))
				var/mob/player/P = target
				P.addStatusEffect(abilityEffect,((abilityModifier < 0 ? -abilityModifier : abilityModifier)*abilityLevel)*60)
				if(abilityModifier > 0)
					P.popup(abilityModifier*abilityLevel,COL_FRIENDLY)
					P.playerData.hp.change(do_roll(1,abilityModifier*abilityLevel))
				else
					P.takeDamage(do_roll(1,(abilityModifier < 0 ? -abilityModifier : abilityModifier)*abilityLevel),DTYPE_DIRECT)
	cooldownHandler |= src

///
// Called after a succseful cast.
///
/datum/ability/proc/postCast(var/mob/player/caster,var/target)
	if(!suppressMessage)
		messageArea("You cast [name].","[caster.name] cast [name].",caster,image(abilityIcon,icon_state=abilityState))
	//if(abilityIconTarget)
	//	new abilityIconTarget(target:loc)

///
// and Object that holds spells for casting.
///
/obj/spellHolder
	name = "spell holder"
	var/mob/mobHolding
	var/datum/ability/heldAbility

/obj/spellHolder/New(var/datum/ability/a)
	if(!a)
		return
	heldAbility = a
	updateName()
//	name = heldAbility.name
//	if(heldAbility.abilityCooldownTimer)
//		name += " ([round(heldAbility.abilityCooldownTimer/60)]-CD)"

///
// Regenerates the spellHolder's name
///
/obj/spellHolder/proc/updateName()
	name = heldAbility.name
	if(heldAbility.abilityCooldownTimer)
		name += " ([round(heldAbility.abilityCooldownTimer/60)]-CD)"
	desc = heldAbility.desc
	icon = heldAbility.abilityIcon
	icon_state = heldAbility.abilityState

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