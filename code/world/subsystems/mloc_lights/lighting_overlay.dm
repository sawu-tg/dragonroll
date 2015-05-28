/atom/movable/lighting_overlay
	name = ""
	mouse_opacity = 0
	anchored = 1

	icon = LIGHTING_ICON
	layer = LIGHTING_LAYER
	invisibility = INVISIBILITY_LIGHTING
	blend_mode = BLEND_MULTIPLY
	color = "#000000"

	var/lum_r
	var/lum_g
	var/lum_b

	var/amb_r
	var/amb_g
	var/amb_b

	#if LIGHTING_RESOLUTION != 1
	var/xoffset
	var/yoffset
	#endif

	var/needs_update

/atom/movable/lighting_overlay/New()
	. = ..()
	verbs.Cut()

/atom/movable/lighting_overlay/proc/update_lumcount(delta_r, delta_g, delta_b)
	lum_r += delta_r
	lum_g += delta_g
	lum_b += delta_b

	needs_update = 1
	lighting_update_overlays += src

/atom/movable/lighting_overlay/proc/update_ambience(new_r, new_g, new_b)
	var/turf/T = loc

	if(!T) return

	amb_r = new_r * T.ambient_factor
	amb_g = new_g * T.ambient_factor
	amb_b = new_b * T.ambient_factor

	needs_update = 1
	lighting_update_overlays |= src

/atom/movable/lighting_overlay/proc/update_overlay()
	var/total_r = lum_r + amb_r
	var/total_g = lum_g + amb_g
	var/total_b = lum_b + amb_b

	var/mx = max(total_r, total_g, total_b)
	. = 1 // factor
	if(mx > 1)
		. = 1/mx

	#if LIGHTING_TRANSITIONS == 1
	animate(src,
		color = rgb(total_r * 255 * ., total_g * 255 * ., total_b * 255 * .),
		LIGHTING_INTERVAL - 1
	)
	#else
	color = rgb(total_r * 255 * ., total_g * 255 * ., total_b * 255 * .)
	#endif