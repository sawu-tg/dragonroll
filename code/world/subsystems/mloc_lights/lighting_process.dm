var/list/lighting_update_lights = list()
var/list/lighting_update_overlays = list()

/datum/controller/lighting
	name = "Lighting"
	execTime = LIGHTING_INTERVAL
	var/lastRegionIndex = 1

/datum/controller/lighting/Initialize()
	create_lighting_overlays()


/datum/controller/lighting/Stat()
	stat("<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Lightcount: [lighting_update_lights.len]) (Overlaycount: [lighting_update_overlays.len])")

/datum/controller/lighting/getStat()
	return "<b>[name]</b> | [round(cost,0.001)]ds | (CPU:[round(cpu,1)]%) (Lightcount: [lighting_update_lights.len]) (Overlaycount: [lighting_update_overlays.len])"

/datum/controller/lighting/doProcess()
//	world << "updating [lighting_update_lights.len] lights"

	if(regions.len)
		var/datum/zregion/R = regions[lastRegionIndex]
		R.doProcess()
		++lastRegionIndex
		if(lastRegionIndex > regions.len)
			lastRegionIndex = 1

	for(var/datum/light_source/L in lighting_update_lights)
		if(L.needs_update)
			if(L.destroyed || L.check() || L.force_update)
				L.remove_lum()
				if(!L.destroyed) L.apply_lum()
				L.force_update = 0
			L.needs_update = 0

		scheck()

	lighting_update_lights.Cut()

	for(var/atom/movable/lighting_overlay/O in lighting_update_overlays)
		if(O.needs_update)
			O.update_overlay()
			O.needs_update = 0

		scheck()

	lighting_update_overlays.Cut()