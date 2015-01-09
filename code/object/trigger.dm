var/list/globalTriggers = list()

/obj/trigger
	name = "trigger"
	desc = "generic trigger"
	icon = 'sprite/obj/triggers.dmi'
	icon_state = "trigger_generic"

	density = 0

	var/list/triggerOverlay = list() //strided list of iconstate,tiles_x,tiles_y
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
			if(counter != 1)
				var/obj/triggerExpander/exp = new /obj/triggerExpander(src)
				exp.loc = loc
				exp.x += iconlist[counter+1]
				exp.y += iconlist[counter+2]
			overlays |= image(icon=(cooldown ? triggerIconCD : triggerIcon),icon_state=iconlist[counter],pixel_x = iconlist[counter+1]*32,pixel_y = iconlist[counter+2]*32)

/obj/triggerExpander
	name = "expander"
	desc = "expands a trigger"
	mouse_opacity = 0
	var/obj/trigger/myParent

/obj/triggerExpander/New(var/obj/trigger/parent)
	myParent = parent
	name = parent.name
	desc = parent.desc
	density = parent.density
	luminosity = parent.luminosity
	opacity = parent.opacity

/obj/triggerExpander/Cross(var/atom/a)
	myParent.Cross(a)

//TRIGGERS

/obj/trigger/portal
	name = "portal"
	desc = "takes you to a far off land!"
	triggerIcon = 'sprite/world/portal.dmi'
	triggerIconCD = 'sprite/world/portal.dmi'
	triggerOverlay = list("portal_bottomleft",0,0,"portal_topleft",0,1,"portal_topright",1,1,"portal_bottomright",1,0)
	triggerOverlayCD = list("portal_bottomleft_cd",0,0,"portal_topleft_cd",0,1,"portal_topright_cd",1,1,"portal_bottomright_cd",1,0)
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