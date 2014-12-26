/world
	turf = /turf/floor/voidFloor
	view = 11

/proc/do_roll(var/times,var/dice,var/bonus)
	var/rolled = 0
	var/count = times
	while(count > 0)
		rolled += rand(1,dice)
		--count
	rolled += bonus
	return rolled

/proc/parseIcon(var/mob/toWhere, var/parse)
	var/icon/i
	if(istype(parse,/mob))
		var/mob/m = parse
		i = icon(m.icon)
		for(var/o in m.overlays)
			i.Blend(icon(icon=o:icon,icon_state=o:icon_state),ICON_OVERLAY)
			if(o:color)
				i.Blend(o:color,ICON_MULTIPLY)
		return {"<img src="\ref[fcopy_rsc(i)]">"}
	if(istype(parse,/obj))
		var/obj/m = parse
		i = icon(m.icon,m.icon_state)
		for(var/o in m.overlays)
			i.Blend(icon(icon=o:icon,icon_state=o:icon_state),ICON_OVERLAY)
			if(o:color)
				i.Blend(o:color,ICON_MULTIPLY)
		return {"<img src="\ref[fcopy_rsc(i)]">"}
	else
		return parse

/proc/displayInfo(var/personal as text,var/others as text, var/mob/toWho, var/fromWhat)
	toWho << "<font color=blue>[parseIcon(toWho,fromWhat)] > [parseIcon(toWho,toWho)] | [personal]</font>"
	for(var/mob/m in orange(world.view))
		m << "<font color=blue>[parseIcon(m,fromWhat)] > [parseIcon(m,toWho)] | [others]</font>"

/proc/chatSay(var/msg as text)
	world << "<font color=black>\icon[usr][usr]: [msg]</font>"