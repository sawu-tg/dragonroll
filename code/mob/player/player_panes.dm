/mob
	var/list/datum/windowpane/panes = list()

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

		//world << "tabs=\"[panestring]\""

		winset(src,"tabwindow.tabs","tabs=\"[panestring]\"")

	proc/add_pane(var/panetype)
		var/datum/windowpane/pane = new panetype(src)
		panes[pane.id] = pane
		pane.update()