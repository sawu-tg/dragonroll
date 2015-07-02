/atom/proc/examine(mob/user)
	var/fullmsg = ""
	if(istype(user,/mob/player) && istype(src,/mob/player))
		var/mob/player/P = src
		var/f_name = "\a [src]"
		fullmsg += "That's <a href=?src=\ref[user];function=examine;what=\ref[P]><b>[f_name]</b></a><br>"
		fullmsg += "[P.playerData.returnGender(TRUE)] looks [P.playerData.hp.statCurr > P.playerData.hp.statModified/2 ? "Healthy" : "Hurt"]<br>"
		fullmsg += "<b>They are wearing:</b><br>"
		for(var/obj/item/I in P.playerEquipped)
			fullmsg += "<b>[P.getSlotName(I.slot)]</b>: [I]<br>"
	if(desc)
		fullmsg += "<br>[desc]<br>"
	if(helpInfo)
		fullmsg += "<i>Your Encyclopedia has this to say about [src]:</i><br>"
		fullmsg += helpInfo
		user:playerEnc[name] = helpInfo
	messageInfo("[fullmsg]",user,src)

//somethign appearign in examine that shouldn't? set its name to null
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	set category = "Objects"
	A.examine(src)