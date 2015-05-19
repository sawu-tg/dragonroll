/atom/proc/examine(mob/user)
	var/f_name = "\a [src]"

	user << "[parseIcon(user,src)] That's [f_name]"

	if(desc)
		user << " > [desc]"

//somethign appearign in examine that shouldn't? set its name to null
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	A.examine(src)