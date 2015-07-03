/proc/messageArea(var/personal as text,var/others as text, var/mob/toWho, var/fromWhat,var/color="blue")
	var/visibleMessage = toWho == fromWhat ? "\[[fromWhat:name]]" : "\[[fromWhat:name]] > [toWho:name]"
	toWho << "<font color=[color]><b>[visibleMessage]</b>: [personal]</font>"
	for(var/mob/m in oview(world.view,toWho))
		if(m == toWho)
			continue
		m << "<font color=[color]><b>[visibleMessage]</b>: [others]</font>"

/proc/messagePlayer(var/personal as text, var/mob/toWho, var/fromWhat,var/color="blue")
	var/visibleMessage = toWho == fromWhat ? "\[[fromWhat:name]]" : "\[[fromWhat:name]] > [toWho:name]"
	toWho << "<font color=[color]><b>[visibleMessage]</b>: [personal]</font>"

///
// WRAPPER PROCS
//
/proc/messageInfo(var/personal as text, var/mob/toWho, var/fromWhat)
	messagePlayer(personal,toWho,fromWhat,"blue")

/proc/messageError(var/personal as text, var/mob/toWho, var/fromWhat)
	world.log << "ERROR: [personal] from [fromWhat] to [toWho]"
	messagePlayer("<b>[personal]</b>",toWho,fromWhat,"red")

/proc/messageSystem(var/personal as text, var/mob/toWho, var/fromWhat)
	messagePlayer("<b><i>[personal]</i></b>",toWho,fromWhat,"purple")

/proc/messageWarning(var/personal as text, var/mob/toWho, var/fromWhat)
	world.log << "WARNING: [personal] from [fromWhat] to [toWho]"
	messagePlayer("<font size = 6><b><i>[personal]</i></b></font>",toWho,fromWhat,"red")

/proc/messageSystemAll(var/personal as text)
	world.log << "SYSTEM: [personal]"
	for(var/mob/player/M in world)
		if(M.client)
			messageSystem(personal,M,world)

/proc/messageWarningAll(var/personal as text)
	for(var/mob/player/M in world)
		if(M.client)
			messageWarning(personal,M,world)
///
///
///

/proc/messageChat(var/who, var/msg as text)
	who << "<font color=black><b>[usr]</b> [msg]</font>"

/proc/formatspeech(msg)
	if(!msg)
		return " mutters indistinguishably";

	var/ending = copytext(msg, length(msg))

	if (ending == "?")
		return "asks, \"[msg]\"";

	if (ending == "!")
		return "exclaims, \"[msg]\"";

	return "says, \"[msg]\"";