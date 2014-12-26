/obj
	name = "default object"
	desc = "not very interesting"

/obj/DblClick()
	objFunction(usr)

/obj/proc/objFunction(var/mob/user)
	user << "You used the [name]"