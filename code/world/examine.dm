/atom/proc/examine(mob/user)
	if(istype(user,/mob/player) && istype(src,/mob/player))
		var/f_name = "\a [src]"
		var/mob/player/P = src
		messageInfo("That's <a href=?src=\ref[user];function=examine;what=\ref[P]><b>[f_name]</b></a>",user,src)
		messageInfo("[P.playerData.returnGender(TRUE)] looks [P.playerData.hp.statCurr > P.playerData.hp.statModified/2 ? "Healthy" : "Hurt"]",user,src)

	if(desc)
		messageInfo("> [desc]",user,src)

//somethign appearign in examine that shouldn't? set its name to null
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	A.examine(src)