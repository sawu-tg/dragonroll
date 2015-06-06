/datum/windowpane
	var/mob/player

	var/title
	var/base_id
	var/id

	var/update_interval = 5
	var/last_update = 0

	var/initialized = 0

	New(var/mob/M)
		player = M

	Del()
		if(player && player.client)
			winset(player, id, "parent=none")
		..()

	proc/initialize()
		if(!player || !player.client)
			return

		if(id != base_id && !winexists(player,id))
			winclone(player, base_id, id)

		initialized = 1

	proc/update()
		if(!player || !player.client)
			return

		if(!winexists(player,id) || !initialized)
			initialize()

		winset(player, id, "title=\"[title]\"")

/datum/windowpane/stats
	title = "Stats"
	base_id = "pane_browser"
	id = "stats"
	var/statcontent = ""

	update()
		var/mob/player/P = player

		if(!P || !P.client)	return

		var/allstats = "<table style=\"width: 100%;\"><tr>"
		var/currentcolumn = 0
		var/maxcolumn = 2

		var/list/imagestosend = list()

		imagestosend["stat_up"] = icon('sprite/gui/staticons.dmi',"up")
		imagestosend["stat_down"] = icon('sprite/gui/staticons.dmi',"down")
		imagestosend["stat_normal"] = icon('sprite/gui/staticons.dmi',"normal")

		for(var/datum/stat/S in P.playerData.playerStats)
			var/img = "stat_[S.statIcon].png"

			imagestosend[img] = icon('sprite/gui/staticons.dmi',S.statIcon)

			//var/stattext = "<IMG CLASS=icon SRC=\ref['sprite/gui/staticons.dmi'] ICONSTATE='[S.statIcon]'> "
			var/stattext = "<IMG SRC=[img]> "
			var/statprefix = "stat_normal"
			var/statdelta = S.statModified - S.statNormal

			//world << "[S.statName]: [S.statCur] - [S.statOld] = [statdelta]"

			if(statdelta > 0)
				statprefix = "stat_up"
			else if(statdelta < 0)
				statprefix = "stat_down"

			if(S.isLimited)
				stattext += "[S.statName]: </td><td><IMG SRC=[statprefix]>[S.statCurr]/[S.statModified] (Base: [S.statBase])"
			else
				stattext += "[S.statName]: </td><td><IMG SRC=[statprefix]>[S.statModified] (Base: [S.statBase])"

			allstats += "<td>[stattext]</td>"

			currentcolumn++

			if(currentcolumn >= maxcolumn)
				allstats += "</tr><tr>"
				currentcolumn = 0
		allstats += "</tr></table><br>"
		allstats += "<center><b>Organs:</b></center><table style=\"width: 100%;\"><tr>"
		for(var/datum/organ/O in P.playerOrgans)
			allstats += "<td><font color=[RGBtoHSV(rgb(max(255-(O.health*2.5),255),0,0))]><b>[O.name]</b>: [O.health]hp</font></td>"
		allstats += "</tr></table>"

		allstats += "<center><b>Buffs and Debuffs:</b></center><table style=\"width: 100%;\"><tr>"
		var/worldTime = world.time
		for(var/S in P.statuseffects)
			if(S)
				var/count = P.checkEffectStack(S:id)
				allstats += "<td><b><center><font size=2>[S:name][count > 0 ? " x count" : ""] ([(S:applytime + S:maxtime) - worldTime])</font></b><br><font size = 1.5> [S:desc]</font>"

				for(var/statid in S:statchanges) //I'll kill you you nigga
					var/modamt = S:statchanges[statid]
					allstats += "<br>[modamt > 0 ? "<font color = green>+" : "<font color = red>-"][abs(modamt)][statid]</font>"
				allstats += "</center></td>"
		allstats += "</tr></table>"


		if(statcontent != allstats && initialized)
			statcontent = allstats

			for(var/img in imagestosend)
				P << browse_rsc(imagestosend[img],img)

			P << output(allstats, "[id].browser")
			winset(P,null,null)

		..()


/datum/windowpane/inventory
	title = "Inventory"
	base_id = "pane_browser"
	id = "inventory"
	var/htmlcontent = ""

	update()
		var/mob/player/P = player

		if(!P || !P.client)	return

		//var/html = "<title>Inventory</title><html><center>[parseIcon(P.client,P,FALSE)]<br><body style='background:grey'>"
		var/html = "<title>Inventory</title><html><center><br><body style='background:grey'>"
		for(var/obj/I in P.playerInventory)
			html += "<b>[I.name]</b> ([!P.isWorn(I) ? "<a href=?src=\ref[P];function=dropitem;item=\ref[I]><i>Drop</i></a>" : ""][P.isWearable(I) && !P.isWorn(I) ? " | <a href=?src=\ref[P];function=wearitem;item=\ref[I]><i>Equip</i></a>" : (P.isWorn(I) ? "<a href=?src=\ref[P];function=removeitem;item=\ref[I]><i>Remove</i></a>" : "")] | <a href=?src=\ref[P];function=useitem;item=\ref[I]><i>Use</i></a>)<br>"
		html += "</body></center></html>"

		if(htmlcontent != html && initialized)
			htmlcontent = html

			P << output(html, "[id].browser")
			winset(P,null,null)

		..()


/datum/windowpane/debug
	title = "Debug"
	base_id = "pane_browser"
	id = "debug"
	update_interval = 5
	var/debugcontent = ""

	update()
		var/mob/P = player

		if(!P || !P.client)	return

		//var/html = "<title>Inventory</title><html><center>[parseIcon(P.client,P,FALSE)]<br><body style='background:grey'>"
		var/debuginfo
		debuginfo += "CPU: [world.cpu]<BR>"
		debuginfo += "FPS: [world.fps]<BR>"
		debuginfo += "Total Count: [world.contents.len]<BR>"
		if(CS)
			debuginfo += "==== SUBSYSTEMS ====<BR>"
			for(var/datum/controller/C in CS.controllers)
				debuginfo += C.getStat()
				debuginfo += "<BR>"

		if(debugcontent != debuginfo && initialized)
			debugcontent = debuginfo

			P << output(debuginfo, "[id].browser")
			winset(P,null,null)

		..()


/datum/windowpane/verbs
	title = "Verbs"
	base_id = "pane_verbs"
	id = "pane_verbs"
	var/htmlcontent = ""

	initialize()
		..()

		if(player && player.client)
			//world << "setting [id] to default"

			winset(player,"[id].info","is-default=\"true\"")

/datum/windowpane/abilities
	title = "Abilities"
	base_id = "pane_grid"
	id = "abilities"
	var/list/spells = list()

	update()
		var/mob/player/P = player

		if(!P || !P.client)	return

		var/list/delta = P.playerSpellHolders ^ spells

		if(!delta.len)
			return

		var/count

		for(var/obj/spellHolder/A in P.playerSpellHolders)
			count++

			A.updateName()
			P << output(A, "[id].grid:[count]")

		winset(P,"[id].grid","cells = \"[count]\"")
		//winset(P,null,null)

		..()