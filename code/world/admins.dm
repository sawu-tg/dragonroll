/proc/loadAdmins()
	var/F = file("cfg/admins.txt")
	if(F)
		for(var/line in file2list(F))
			globalAdmins += line
	else
		messageSystemAll("Failed to load admins.txt!")

/proc/constructVerbList()
	var/list/L = list()
	L.Add(typesof(/mob/verb))
	. = L

/proc/addAdminVerbs(var/mob/onWho)
	var/list/R = constructVerbList()
	for(var/RR in R)
		var/RRR = new RR
		if(RRR:category == "DM" || RRR:category == "Debug Verbs")
			onWho.verbs += RRR


/proc/remAdminVerbs(var/mob/onWho)
	for(var/V in onWho.verbs)
		if(V:category == "DM")
			onWho.verbs -= V
		if(V:category == "Debug Verbs")
			onWho.verbs -= V