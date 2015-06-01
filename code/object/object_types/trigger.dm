var/list/globalTriggers = list()

/obj/trigger
	name = "trigger"
	desc = "generic trigger"
	icon = 'sprite/obj/triggers.dmi'
	icon_state = "trigger_generic"

	density = 0
	anchored = 1

	var/atom/lastTrigger
	var/shouldCheckLast = FALSE

	var/list/extenders = list()
	var/list/triggerOverlay = list() //strided list of iconstate,tiles_x,tiles_y //FUCKS A STRIDED LIST
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

	//set_light(11,9,"#66CCFF")
	set_light(11,9,"#FFFFFF")

	if(triggerOverlay.len)
		updateIcons()

/obj/trigger/Cross(var/atom/a)
	triggering = a
	if(shouldCheckLast)
		if(triggering == lastTrigger)
			return
	lastTrigger = triggering
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
		lastTrigger = null
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
				//world << "Everyday we make another trigger extender" //WE REALLY DO YOU FUCKING NIGGER
				//var/obj/triggerExpander/exp = new /obj/triggerExpander(src)
				//exp.loc = loc
				//exp.x += iconlist[counter+1]
				//exp.y += iconlist[counter+2]
				//If you fucking read this know that I am fucking disappointed.

				var/xoff = iconlist[counter+1]
				var/yoff = iconlist[counter+2]

				var/obj/triggerExpander/E = extenders["[xoff],[yoff]"]

				if(!E)
					E = new /obj/triggerExpander(src)
					E.loc = locate(x+xoff,y+yoff,z)
					extenders["[xoff],[yoff]"] = E

				if(light)
					E.set_light(light.light_range,light.light_power,light.light_color)
				else
					E.set_light(0)
			overlays |= image(icon=(cooldown ? triggerIconCD : triggerIcon),icon_state=iconlist[counter],pixel_x = iconlist[counter+1]*world.icon_size,pixel_y = iconlist[counter+2]*world.icon_size)

/obj/triggerExpander
	name = "expander"
	desc = "expands a trigger"
	mouse_opacity = 0
	anchored = 1
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
	shouldCheckLast = TRUE
	var/exitDir = SOUTH
	var/portalID = "default"
	var/safe = TRUE //if false, players are forced to relinquish safe zone features, such as character changing

/obj/trigger/portal/forceCooldown()
	..()
	updateIcons(TRUE)

/obj/trigger/portal/triggerAction()
	var/mob/player/Ply = triggering

	world << "Player entering [Ply]"

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
		var/choice
		var/shouldTeleport = TRUE
		if(Ply.hasReroll && !teletar.safe)
			choice = alert(triggering,"You are leaving a safe-zone, this will disable character changes and sanctuary effects.","Safe-zone","Continue","Return")
		if(choice)
			switch(choice)
				if("Continue")
					shouldTeleport = TRUE
				if("Return")
					shouldTeleport = FALSE
				else
					lastTrigger = null
		else
			lastTrigger = null
		if(shouldTeleport)
			..()
			teletar.forceCooldown()
			Ply.loc = teletar.loc
			step(triggering,exitDir)
		else
			step(triggering,exitDir)
	else
		lastTrigger = null

/obj/trigger/portal/doProcess()
	..()
	if(triggerCooldown <= 0)
		updateIcons(FALSE)