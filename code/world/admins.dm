var/list/globalVerbList = list()

/proc/loadAdmins()
	var/F = file("cfg/admins.txt")
	if(F)
		for(var/line in file2list(F))
			globalAdmins += line
			world.SetConfig("APP/admin", ckey("[line]"), "role=root")
	else
		messageSystemAll("Failed to load admins.txt!")

/proc/addAdminVerbs(var/mob/onWho)
	var/list/R = globalVerbList
	for(var/RR in R)
		if(RR:category == "DM" || RR:category == "Debug Verbs")
			onWho.verbs += RR


/proc/remAdminVerbs(var/mob/onWho)
	for(var/V in onWho.verbs)
		globalVerbList |= V
		if(V:category == "DM")
			onWho.verbs -= V
		if(V:category == "Debug Verbs")
			onWho.verbs -= V