var/list/globalWeather = list()

/datum/weatherEffect
	var/name = "weather"
	var/desc = "probably britain"
	var/overlayState

/datum/weatherEffect/New(var/ofname,var/ofdesc,var/ofoverlay)
	..()
	name = ofname
	desc = ofdesc
	if(ofoverlay)
		overlayState = ofoverlay

/datum/weatherEffect/proc/doWeather(var/mob/player/P)
	return

/proc/findWeather(var/ofname)
	for(var/datum/weatherEffect/A in globalWeather)
		if(A.name == ofname)
			return A
	return null

/datum/areaWeather
	var/datum/weatherEffect/WE
	var/area/owner

/datum/areaWeather/New(var/area/T)
	..(T)
	owner = T

/datum/areaWeather/proc/updateWeather(var/datum/weatherEffect/newWE)
	WE = newWE
	if(WE.overlayState)
		owner.icon_state = WE.overlayState