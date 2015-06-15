//nitric acid - 2 parts saltpetre in 1 part oil of vitriol
/datum/reagent/aqua_fortis
	name = "aqua fortis"
	id = "aqua_fortis"
	color = "#FFFFFF"

/datum/chem_reaction/aqua_fortis
	id = "aqua_fortis"

	required_reagents = list("saltpetre" = 2,"vitriol" = 1)
	produced_reagents = list("aqua_fortis" = 3)

//Scheidewasser. a.k.a nitro-hydrochloric acid. - aqua fortis and spirit of salt.
/datum/reagent/aqua_regia
	name = "aqua regia"
	id = "aqua_regia"
	color = "#FFFFFF"

/datum/chem_reaction/aqua_regia
	id = "aqua_regia"

	required_reagents = list("aqua_fortis" = 1,"acidum_salis" = 1)
	produced_reagents = list("aqua_regia" = 2)

//arsenic trioxide. Extremely poisonous. - roast orpiment.
/datum/reagent/aqua_tofani
	name = "aqua tofani"
	id = "aqua_tofani"
	color = "#FFFFFF"

//blue vitriol. Pesticide & Herbicide. - copper + hot oil of vitriol
/datum/reagent/bluestone
	name = "bluestone"
	id = "bluestone"
	color = "#FFFFFF"

/datum/chem_reaction/bluestone
	id = "bluestone"

	required_heatmin = T0C + 150
	required_reagents = list("copper" = 1)
	required_catalysts = list("vitriol" = 1)
	produced_reagents = list("bluestone" = 1)

//ore of mercury
/datum/reagent/cinnabar
	name = "cinnabar"
	id = "cinnabar"
	color = "#FFFFFF"

//sulfuric acid. Probably sulfur in water. Also heat green or blue vitriol.
/datum/reagent/vitriol
	name = "oil of vitriol"
	id = "vitriol"
	color = "#FFFFFF"

/datum/chem_reaction/vitriol_from_blue
	id = "vitriol_from_blue"

	required_heatmin = T0C + 500
	required_reagents = list("bluestone" = 1)
	produced_reagents = list("vitriol" = 1)

/datum/chem_reaction/vitriol_from_green
	id = "vitriol_from_green"

	required_heatmin = T0C + 500
	required_reagents = list("green_vitriol" = 1)
	produced_reagents = list("vitriol" = 1)

//ferrous sulfate
/datum/reagent/green_vitriol
	name = "green vitriol"
	id = "green_vitriol"
	color = "#FFFFFF"

//This is a mineral that turns into green vitriol in moist air.
/datum/reagent/marcasite
	name = "marcasite"
	id = "marcasite"
	color = "#FFFFFF"

//Ferric oxide. formed from burning green_vitriol.
/datum/reagent/colcothar
	name = "colcothar"
	id = "colcothar"
	color = "#FFFFFF"

//silver nitrate. corrosive.
/datum/reagent/lapis_infernalis
	name = "lapis infernalis"
	id = "lapis_infernalis"
	color = "#FFFFFF"

//potash in water.
/datum/reagent/lye
	name = "lye"
	id = "lye"
	color = "#FFFFFF"

//potassium carbonate. evaporate lye.
/datum/reagent/potash
	name = "potash"
	id = "potash"
	color = "#FFFFFF"

//bake potash
/datum/reagent/pearlash
	name = "pearlash"
	id = "pearlash"
	color = "#FFFFFF"

//lead monoxide. mineral.
/datum/reagent/massicot
	name = "massicot"
	id = "massicot"
	color = "#FFFFFF"

//fused and powdered massicot
/datum/reagent/litharge
	name = "litharge"
	id = "litharge"
	color = "#FFFFFF"

//red lead. roast litharge.
/datum/reagent/minium
	name = "minium"
	id = "minium"
	color = "#FFFFFF"

//this makes displays. Apparently made from reduction of barite with flour/coke
/datum/reagent/lapis_solaris
	name = "lapis solaris"
	id = "lapis_solaris"
	color = "#FFFFFF"

//salt of the world/thaumaturge's salt
/datum/reagent/salis_mundus
	name = "salis mundus"
	id = "salis_mundus"
	color = "#FFFFFF"

//hydrochloric acid. table salt + oil of vitriol
/datum/reagent/acidum_salis
	name = "acidum salis"
	id = "acidum_salis"
	color = "#FFFFFF"

//ammonium chloride. occurs in volcanic biomes.
/datum/reagent/sal_ammoniac
	name = "sal ammoniac"
	id = "sal_ammoniac"
	color = "#FFFFFF"

//ammonia. decompose sal ammonica in unslaked lime
/datum/reagent/spirit_of_hartshorn
	name = "spirit of hartshorn"
	id = "spirit_of_hartshorn"
	color = "#FFFFFF"

//ammonia carbonate. leavening agent and also as smelling salt.
/datum/reagent/sal_volatile
	name = "sal volatile"
	id = "sal_volatile"
	color = "#FFFFFF"

