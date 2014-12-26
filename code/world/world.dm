/world
	turf = /turf/floor/lobbyFloor

/proc/chatSay(var/msg as text)
	world << "<font color=blue>\icon[usr][usr]: [msg]</font>"