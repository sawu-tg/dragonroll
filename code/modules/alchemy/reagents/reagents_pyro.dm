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

/datum/reagent/pyrosium
	name = "pyrosium"
	id = "pyrosium"
	color = "#FFA52055"

	process_fire()
		if(holder.temperature > 100)
			holder.heat(3000,volume)
			firecolor = heat2colour(holder.temperature)
			holder.removeliquid(id,1)
			return 1