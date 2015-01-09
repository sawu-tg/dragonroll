var/list/globalTriggers = list()

/obj/trigger
	name = "trigger"
	desc = "generic trigger"
	icon = 'sprite/obj/triggers.dmi'
	icon_state = "trigger_generic"

	density = 0

	var/list/triggerOverlay = list() //strided list of iconstate,pixel_x,pixel_y
	var/list/triggerOverlayCD = list()
	var/triggerIcon
	var/triggerIconCD
	var/atom/movable/triggerTarget
	var/atom/movable/triggering

	var/triggerCooldownTime = 0 //the the time it takes to cooldown
	var/triggerCooldown = 0 //the processing cooldown

/obj/trigger/New()
	..()
	globalTriggers |= src
	if(triggerOverlay.len)
		updateIcons()

/obj/trigger/Cross(var/atom/a)
	triggering = a
	doTrigger()

/obj/trigger/proc/canTrigger()
	if(triggerCooldownTime)
		if(triggerCooldown <= 0)
			return TRUE
	else
		return TRUE

/obj/trigger/proc/triggerAction()
	forceCooldown()

/obj/trigger/proc/forceCooldown()
	if(triggerCooldownTime)
		icon = triggerIconCD
		icon_state = triggerOverlayCD
		triggerCooldown = triggerCooldownTime
		addProcessingObject(src)

/obj/trigger/doProcess()
	if(triggerCooldown > 0)
		triggerCooldown--
	else
		icon = triggerIcon
		icon_state = triggerOverlay
		triggering = null
		remProcessingObject(src)

/obj/trigger/proc/doTrigger()
	if(canTrigger())
		triggerAction()

/obj/trigger/proc/updateIcons(var/cooldown = FALSE)
	overlays.Cut()
	var/counter
	var/list/iconlist = (cooldown ? triggerOverlayCD : triggerOverlay)
	for(counter = 1; counter < iconlist.len; counter = counter + 3)
		if(iconlist[counter])
			overlays |= image(icon=(cooldown ? triggerIconCD : triggerIcon),icon_state=iconlist[counter],pixel_x = iconlist[counter+1],pixel_y = iconlist[counter+2])

//shit,1,2,does,1,2

//TRIGGERS

/obj/trigger/portal
	name = "portal"
	desc = "takes you to a far off land!"
	triggerIcon = 'sprite/world/furniture.dmi'
	triggerIconCD = 'sprite/world/furniture.dmi'
	triggerOverlay = list("portal_bottom",0,0,"portal_top",0,32)
	triggerOverlayCD = list("portal_bottom_cd",0,0,"portal_top_cd",0,32)
	triggerCooldownTime = 30
	var/exitDir = SOUTH
	var/portalID = "default"

/obj/trigger/portal/forceCooldown()
	..()
	updateIcons(TRUE)

/obj/trigger/portal/triggerAction()
	var/list/valid = list()
	for(var/obj/trigger/T in globalTriggers)
		if(istype(T,/obj/trigger/portal))
			var/obj/trigger/portal/P = T
			if(P == src)
				continue
			if(P.portalID == portalID)
				valid |= P
	var/obj/trigger/portal/teletar = input(triggering,"Take portal to where?") as null|anything in valid
	if(teletar)
		..()
		teletar.forceCooldown()
		triggering.loc = teletar.loc
		step(triggering,exitDir)

/obj/trigger/portal/doProcess()
	..()
	if(triggerCooldown <= 0)
		updateIcons(FALSE)