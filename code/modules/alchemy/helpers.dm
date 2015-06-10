/proc/mix_color_from_list(var/list/color_list)
	if(!istype(color_list))
		return

	var/color
	var/vol_counter = 0
	var/vol_temp

	for(var/rcolor in color_list)
		vol_temp = color_list[rcolor]
		vol_counter += vol_temp

		if(!color)
			color = rcolor

		else if (length(color) >= length(rcolor))
			color = BlendRGBasHSV(color, rcolor, vol_temp/vol_counter)
		else
			color = BlendRGBasHSV(rcolor, color, vol_temp/vol_counter)

	return color