/datum/reagent_holder
	var/atom/myatom
	var/list/liquidlist = new()
	var/maxvolume
	var/currentvolume = 0
	var/temperature = T20C

	var/color = "#FFFFFF"

	var/airtight = 0 //Whether gas should leak
	var/burning = 0 //Whether the contents are on fire
	var/burncolor = "#FFFFFF"

	var/active = 0

	New(var/atom/A,var/size)
		myatom = A
		maxvolume = size

	proc/isState(var/what)
		var/test = text2num(what)
		if(test == REAGENT_STATE_SOLID)
			return TRUE
		if(test == REAGENT_STATE_POWDER)
			return TRUE
		if(test == REAGENT_STATE_LIQUID)
			return TRUE

	proc/addliquid(var/ref,var/amt)
		calctotal()

		var/transfervolume = min(maxvolume - currentvolume,amt)

		for(var/datum/reagent/l in liquidlist)
			if(l.id == ref)
				l.volume += transfervolume
				transfervolume = 0

		if(transfervolume)
			var/datum/reagent/l = reagentList[ref]

			if(istype(l))
				var/datum/reagent/nl = new l.type()
				nl.volume = transfervolume
				nl.holder = src
				liquidlist += nl
				transfervolume = 0

		if(transfervolume == 0)
			calctotal()
			activate()
			return 1

		return 0

	proc/removeliquid(var/ref,var/amt)
		for(var/datum/reagent/l in liquidlist)
			if(isState(ref) ? l.reagentState == text2num(ref) : l.id == ref)
				l.volume = max(l.volume-amt,0)
				if(l.volume <= 0)
					liquidlist -= l

		calctotal()
		activate()

		return 0

	proc/getliquidamt(var/ref)
		for(var/datum/reagent/l in liquidlist)
			if(l.id == ref)
				return l.volume

		return 0

	proc/hasliquid(var/ref,var/amt)
		for(var/datum/reagent/l in liquidlist)
			if(l.id == ref && l.volume >= amt)
				return 1

		return 0

	//transferring into null will just remove the reagents.
	proc/trans_to(var/datum/reagent_holder/target, var/amount=1, var/multiplier=1)
		if (!target)
			return remove_any(amount)
		if(src.currentvolume <= 0 || amount <= 0)
			return 0
		amount = min(min(amount, src.currentvolume), target.maxvolume-target.currentvolume)
		var/part = amount / src.currentvolume
		for (var/datum/reagent/current_reagent in src.liquidlist)
			var/current_reagent_transfer = current_reagent.volume * part
			target.addliquid(current_reagent.id, (current_reagent_transfer * multiplier))
			src.removeliquid(current_reagent.id, current_reagent_transfer)

		src.calctotal()
		target.calctotal()
		return amount

	//trans_to without taking it.
	proc/copy_to(var/datum/reagent_holder/target, var/amount=1, var/multiplier=1)
		if (!target)
			return
		amount = min(min(amount, src.currentvolume), target.maxvolume-target.currentvolume)
		var/part = amount / src.currentvolume
		for (var/datum/reagent/current_reagent in src.liquidlist)
			var/current_reagent_transfer = current_reagent.volume * part
			target.addliquid(current_reagent.id, (current_reagent_transfer * multiplier))

		target.calctotal()
		return amount

	//trans_to without giving it to anything.
	proc/remove_any(var/amount=1)
		amount = min(amount, src.currentvolume)
		var/part = amount / src.currentvolume
		for (var/datum/reagent/current_reagent in src.liquidlist)
			var/current_reagent_transfer = current_reagent.volume * part
			src.removeliquid(current_reagent.id, current_reagent_transfer)

		src.calctotal()
		return amount

	proc/life()
		var/stillworking = 0

		stillworking |= handle_reactions()
		stillworking |= handle_fire()
		stillworking |= handle_gas()

		var/list/colors = list()

		for(var/datum/reagent/l in liquidlist)
			colors[l.color] = l.volume

		color = mix_color_from_list(colors)

		if(!stillworking)
			deactivate()

	proc/activate()
		if(active)
			return

		active = 1
		addChemicalHolder(src)

	proc/deactivate()
		if(!active)
			return

		active = 0
		removeChemicalHolder(src)

	proc/adjust_temperature(var/newtemp,var/volume)
		//seperate because honk
		if(newtemp > temperature)
			heat(newtemp,volume)
		else
			cool(newtemp,volume)

	proc/heat(var/newheat,var/volume)
		var/heatdiff = newheat - temperature
		newheat = max(temperature,temperature + min(sign(heatdiff) * sqrt(abs(heatdiff)),100))
		temperature = round(((volume * newheat) + (currentvolume * temperature)) / (currentvolume + volume))
		activate()

	proc/cool(var/newcool,var/volume)
		var/cooldiff = newcool - temperature
		newcool = min(temperature,temperature + min(sign(cooldiff) * sqrt(abs(cooldiff)),100))
		temperature = round(((volume * newcool) + (currentvolume * temperature)) / (currentvolume + volume))
		activate()

	//Handle (al)chemical reactions
	proc/handle_reactions()
		var/reaction_occured

		do
			reaction_occured = 0

			for(var/datum/reagent/l in liquidlist)
				for(var/datum/chem_reaction/reaction in all_reactions[l.id])
					if(!reaction)
						continue

					var/datum/chem_reaction/C = reaction

					var/total_required_reagents = C.required_reagents.len
					var/total_matching_reagents = 0
					var/total_required_catalysts = C.required_catalysts.len
					var/total_matching_catalysts= 0
					var/total_required_items = C.required_items.len
					var/total_matching_items = 0

					//Short checks go first.
					if(temperature < C.required_heatmin || temperature > C.required_heatmax)
						world << "temp mismatch"
						continue

					if(C.required_container && !istype(myatom,C.required_container))
						world << "container mismatch"
						continue

					//Check the reagents
					for(var/rid in C.required_reagents)
						if(total_matching_reagents >= total_required_reagents) break
						if(!hasliquid(rid, C.required_reagents[rid]))	break
						total_matching_reagents++

					if(total_matching_reagents < total_required_reagents)
						world << "reagent mismatch"
						continue

					//Not all reactions have catalysts or items so check those last
					for(var/rid in C.required_catalysts)
						if(total_matching_catalysts >= total_required_catalysts) break
						if(!hasliquid(rid, C.required_reagents[rid]))	break
						total_matching_catalysts++

					if(total_matching_catalysts < total_required_catalysts)
						world << "catalyst mismatch"
						continue

					if(total_matching_items < total_required_items)
						world << "item mismatch"
						continue

					world << "reacting"

					//Oh can we react? React then.
					for(var/rid in C.required_reagents)
						removeliquid(rid, C.required_reagents[rid])

					var/created_volume = 0

					for(var/rid in C.produced_reagents)
						created_volume += addliquid(rid,C.produced_reagents[rid])

					C.on_reaction(src, created_volume)
					reaction_occured = 1
		while(reaction_occured)

		return 0

	//Handle fire
	proc/handle_fire()
		var/list/firecolors = list()
		var/finalburn = 0

		for(var/datum/reagent/l in liquidlist)
			var/lvol = l.volume
			var/lburn = l.process_fire()

			finalburn |= lburn //funfact, bitwise OR should be much faster than if()

			if(l && lburn && l.firecolor)
				firecolors[l.firecolor] = lvol

		burncolor = mix_color_from_list(firecolors)
		burning = finalburn

		return finalburn

	//Handle fumes escaping
	proc/handle_gas()
		return 0

	proc/calctotal()
		currentvolume = 0

		for(var/datum/reagent/l in liquidlist)
			currentvolume += l.volume

	proc/handle_procs()
		if(istype(myatom,/mob))
			for(var/datum/reagent/R in liquidlist)
				R.processMob(myatom)
		else if(istype(myatom,/obj))
			for(var/datum/reagent/R in liquidlist)
				R.processObj(myatom)


/mob/verb/debugChemicals(var/obj/O in view())
	set name = "Debug Reagents"
	set category = "Debug Verbs"

	for(var/datum/reagent/a in reagents.liquidlist)
		world << "Reagent [a.name]"
		world << "> ID: [a.id]"
		world << "> Vol: [a.volume]"