/datum/reagent/petrol
	name = "petrol"
	id = "petrol"
	color = "#DAA52055"

	process_fire()
		if(holder.temperature > 500)
			holder.heat(1000,volume)
			firecolor = heat2colour(holder.temperature)
			holder.removeliquid(id,1)
			return 1

/datum/reagent/turpentine
	name = "turpentine"
	id = "turpentine"
	color = "#8B451355"

	process_fire()
		if(holder.temperature > 500)
			holder.heat(1000,volume)
			firecolor = heat2colour(holder.temperature)
			holder.removeliquid(id,1)
			return 1

//Methanol, distillation of wood alcohol
/datum/reagent/pyroxylic_spirit
	name = "pyroxylic spirit"
	id = "pyroxylic_spirit"
	color = "#AAFFAA33"

	process_fire()
		if(holder.temperature > 500)
			holder.heat(1000,volume)
			firecolor = heat2colour(holder.temperature)
			holder.removeliquid(id,1)
			return 1

//diethyl ether. highly flammable and volatile. oil of vitriol and aqua vitae at <150C
/datum/reagent/sweet_vitriol
	name = "sweet vitriol"
	id = "sweet_vitriol"
	color = "#AAFFAA33"

	process_fire()
		if(holder.temperature > 150)
			holder.heat(1000,volume)
			firecolor = heat2colour(holder.temperature)
			holder.removeliquid(id,1)
			return 1

/datum/chem_reaction/sweet_vitriol
	id = "sweet_vitriol"

	required_reagents = list("vitriol" = 1,"aqua_vitae" = 2)
	produced_reagents = list("water" = 2,"sweet_vitriol" = 1)

/datum/reagent/fiery_water
	name = "fiery and burning water"
	id = "fiery_water"
	color = "#AAFFFF33"

	process_fire()
		//holder.heat(200,volume)
		firecolor = heat2colour(holder.temperature)
		return 1

//Burns in water
/datum/reagent/magnesia
	name = "magnesia"
	id = "magnesia"
	color = "#AAFFFF33"

/datum/reagent/heart_of_the_sun
	name = "heart of the sun"
	id = "heart_of_the_sun"
	color = "#AAFFFF33"

//Imaginary substance used to explain combustion
/datum/reagent/phlogiston
	name = "phlogiston"
	id = "phlogiston"
	color = "#FFA52055"

	process_fire()
		if(holder.temperature > 100)
			holder.heat(3000,volume)
			firecolor = heat2colour(holder.temperature)
			holder.removeliquid(id,1)
			return 1

//Universal solvent
/datum/reagent/alkahest
	name = "alkahest"
	id = "alkahest"
	color = "#FFA520"