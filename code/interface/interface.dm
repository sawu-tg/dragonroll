/obj/interface
	name = "interface obj"
	desc = "interface object"
	icon = 'sprite/gui/guiObj.dmi'
	anchored = TRUE
	layer = LAYER_INTERFACE
	mouse_opacity = 0

/obj/interface/New(var/x,var/y,var/state="box",var/scale=32)
	var/icon/temp = icon(icon=icon,icon_state=state)
	temp.Scale(scale,scale)
	icon = temp
	screen_loc = "[x],[y]"

/obj/interface/proc/showTo(var/mob/M)
	M.client.screen |= src

/obj/interface/objFunction(var/mob/user)

//interface shortcut (ie to an item)
/obj/interface/shortcut
	name = "shortcutContainer"
	desc = "For easy access"
	var/obj/shortcutTo

/obj/interface/shortcut/New(var/x,var/y,var/state="box",var/scale=32,var/obj/shown)
	shortcutTo = shown
	..(x,y,state,scale)

/obj/interface/shortcut/proc/rebuild(var/obj/aswhat)
	overlays.Cut()
	shortcutTo = aswhat
	if(aswhat)
		overlays.Add(icon(icon=aswhat.icon,icon_state=aswhat.icon_state))

//spell container
//holds clickable abilties
/obj/interface/spellContainer
	name = "spellContainer"
	desc = "Holds a spell"
	var/obj/spellHolder/heldSpell
	var/hotKey = 0
	mouse_opacity = 1

/obj/interface/spellContainer/proc/setTo(var/obj/spellHolder/toWhat)
	heldSpell = toWhat
	name = toWhat.name
	desc = toWhat.desc
	overlays.Cut()
	overlays.Add(icon(icon=toWhat.heldAbility.abilityIcon,icon_state=toWhat.heldAbility.abilityState))


/obj/interface/spellContainer/objFunction(var/mob/user)
	if(heldSpell)
		heldSpell.Cast(user)