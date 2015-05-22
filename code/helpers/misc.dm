

//Can update this to better logic later on
/atom/proc/Adjacent(var/atom/A)
	if(get_dist(A,src) > 1)
		return 0
	return 1

