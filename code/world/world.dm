/world
	turf = /turf/floor/lobbyFloor

/proc/chatSay(var/msg as text)
	world << "<FONT COLOR=BLUE>\icon[usr][usr]: [msg]</FONT>"