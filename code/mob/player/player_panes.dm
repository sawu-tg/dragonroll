/mob
	var/list/datum/windowpane/panes = list()

	Del()
		for(var/paneid in panes)
			var/datum/windowpane/pane = panes[paneid]

			if(pane)
				sdel(pane)

		..()

	proc/update_panes()
		var/panestring = ""

		for(var/paneid in panes)
			var/datum/windowpane/pane = panes[paneid]

			if(!pane)
				panes.Remove(paneid)
				continue

			panestring += "[pane.id],"

			if(world.time > pane.last_update + pane.update_interval)
				pane.update()
				pane.last_update = world.time

		panestring = copytext(panestring,1,-1)

		winset(src,"tabwindow.tabs","tabs=\"[panestring]\"")

	proc/add_pane(var/panetype)
		var/datum/windowpane/pane = new panetype(src)
		panes[pane.id] = pane
		pane.update()

	proc/rem_pane(var/panetype)
		var/datum/windowpane/pane = new panetype(src)
		for(var/datum/windowpane/P in panes)
			if(P.id == pane.id)
				panes -= P
				del(P)
				del(pane)
				return
		del(pane)