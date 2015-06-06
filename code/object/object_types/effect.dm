/obj/effect
	name = "effect"
	desc = "generic effect"
	layer = LAYER_DEFAULT
	icon = 'sprite/obj/effects.dmi'
	var/length = 1 // how long it runs for
	var/procTime = 0 // internal, used to count down
	var/repeat = FALSE // repeat the animation?
	var/repeatTimes = 2 //how many times to repeat
	var/repeatCounter = 0 //counted repeats

/obj/effect/New()
	..()
	procTime = length
	addProcessingObject(src)

/obj/effect/doProcess()
	if(procTime <= 0)
		if(repeat && repeatCounter < repeatTimes)
			procTime = length
			++repeatCounter
		else
			del(src)
	else
		--procTime

/obj/effect/aoe_tile
	name = "aoe tile"
	desc = "This is the tile of a spell! Watch out!"
	layer = LAYER_OVERLAY
	var/damage = 1

/obj/effect/aoe_tile/New()
	..()
	spawn(10)
		for(var/a in loc)
			if(istype(a,/mob/player))
				doAOEAct(a)

/obj/effect/aoe_tile/proc/doAOEAct(var/atom/what)
	if(istype(what,/mob/player))
		var/mob/player/P = what
		P.playerData.hp.change(damage)
	del(src)

/obj/effect/aoe_tile/Bump(var/atom/what)
	..()
	doAOEAct(what)

/obj/effect/aoe_tile/Cross(var/atom/what)
	..()
	doAOEAct(what)


//effects

/obj/effect/aoe_tile/flame
	name = "Fire"
	desc = "Hot hot HOT!"
	icon = 'sprite/world/fire.dmi'
	icon_state = "1"
	length = 15

/obj/effect/aoe_tile/flame/New()
	icon_state = "[pick(1,2,3)]"
	set_light(3,3,"#FF5500")
	..()

/obj/effect/aoe_tile/bolster
	name = "Bolstering Force"
	desc = "Gives you that pickup"
	icon = 'sprite/obj/tg_effects/effects.dmi'
	icon_state = "medi_holo"
	length = 60 // FIX THIS, WHY IS THIS TAKING THE LENGTH

/obj/effect/aoe_tile/bolster/doAOEAct(var/atom/what)
	if(istype(what,/mob/player))
		var/mob/player/P = what
		P.addStatusEffect(/datum/statuseffect/bolster,length)
	del(src)

/obj/effect/target
	name = "Targeted"
	desc = "There is a reticule targeting this location."
	length = 4.75
	repeat = TRUE
	icon_state = "effect_target"

/obj/effect/explode_single
	name = "Explosion"
	desc = "Warning: should not be looked at."
	length = 4.05
	repeat = FALSE
	icon_state = "effect_explode_single"

/obj/effect/explode_multiple
	name = "Explosion"
	desc = "Warning: should not be looked at."
	length = 4.05
	repeat = FALSE
	icon_state = "effect_explode_multiple"

/obj/effect/heal
	name = "Red Cross"
	desc = "May signify something healthy."
	length = 5
	repeat = FALSE
	icon_state = "effect_heal"

/obj/effect/poison
	name = "Toxic"
	desc = "Signifies something is marginally more toxic than the average garbage can."
	length = 3
	repeat = TRUE
	icon_state = "effect_poison"

/obj/effect/strike
	name = "Slash"
	desc = "Rending through space-time at the speed of 3.15 ticks."
	length = 3.15
	repeat = FALSE
	icon_state = "effect_strike"

/obj/effect/pow
	name = "Poof"
	desc = "Clouds of indetermined origin."
	length = 4.05
	repeat = FALSE
	icon_state = "effect_pow"

/obj/effect/explosion_shrap
	name = "Shrapnel"
	desc = "Warning: If you see this, it's too late."
	length = 4.05
	repeat = FALSE
	icon = 'sprite/obj/tg_effects/effects.dmi'
	icon_state = "explosion_particle"

/obj/effect/sparks
	name = "Spark"
	desc = "Zzzzzzzap."
	length = 4.05
	repeat = FALSE
	icon = 'sprite/obj/tg_effects/effects.dmi'
	icon_state = "sparks"