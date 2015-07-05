/obj/item/weapon/tool/automaton_rune
	name = "automaton rune"
	desc = "makes things happen automatically!"
	helpInfo = "These runes can be used to program an automaton to do different tasks!"
	icon_state = "rune"
	showAsLoot = FALSE

/obj/item/weapon/tool/automaton_rune/proc/runeProc(var/rInp)
	return

/obj/item/weapon/tool/automaton_rune/order
	name = "order rune"

/obj/item/weapon/tool/automaton_rune/target
	name = "target rune"

/obj/item/weapon/tool/automaton_rune/range
	name = "range rune"

/obj/structure/automaton
	name = "automaton"
	desc = "automates things"
	icon = 'sprite/world/stationobjs.dmi'
	icon_state = "automaton"
	helpInfo = "This strange construct will automatically do tasks when loaded with the appropriate runes.<br>It requires a range, order and target rune to function"
	var/isActive = FALSE
	var/workTimer = 0 // internal, used to count down
	var/maxWorkTimer = 5 // the timer will get to this and call it's procs
	var/obj/item/weapon/tool/automaton_rune/order/myOrder
	var/obj/item/weapon/tool/automaton_rune/target/myTarget
	var/obj/item/weapon/tool/automaton_rune/range/myRange

/obj/structure/automaton/doProcess()
	if(isActive)
		if(workTimer >= maxWorkTimer)
			workTimer = 0
			var/list/targets = myTarget.runeProc(myRange.runeProc())
			for(var/A in targets)
				myOrder.runeProc(A)
		else
			++workTimer

/obj/structure/automaton/objFunction(var/mob/player/user,var/obj/item/I)
	if(I)
		if(istype(I,/obj/item/weapon/tool/automaton_rune))
			user.DropItem()
			I.loc = src
			if(istype(I,/obj/item/weapon/tool/automaton_rune/order))
				myOrder = I
				messageInfo("You set [src]'s order to [I]",user,src)

			if(istype(I,/obj/item/weapon/tool/automaton_rune/target))
				myTarget = I
				messageInfo("You set [src]'s target to [I]",user,src)

			if(istype(I,/obj/item/weapon/tool/automaton_rune/range))
				myRange = I
				messageInfo("You set [src]'s range to [I]",user,src)
	else
		if(!myOrder)
			messageInfo("[src] requires an order rune to function!",user,src)
			return
		if(!myTarget)
			messageInfo("[src] requires a target rune to function!",user,src)
			return
		if(!myRange)
			messageInfo("[src] requires an range rune to function!",user,src)
			return
		isActive = !isActive
		if(isActive)
			addProcessingObject(src)
		else
			remProcessingObject(src)
		icon_state = "automaton[isActive ? "_on" : ""]"
		messageInfo("You turn the [src] [isActive ? "on" : "off"].",user,src)

/////
// RUNE TYPES
/////

//ORDER
/obj/item/weapon/tool/automaton_rune/order/farm
	name = "harvest rune"
	desc = "This rune enables an automaton to harvest from tilled soil."

/obj/item/weapon/tool/automaton_rune/order/farm/runeProc(var/rInp)
	if(istype(rInp,/turf/floor/outside/farm))
		var/turf/floor/outside/farm/F = rInp
		if(F.FG)
			if(F.FG.curGrowthStage >= F.FG.growthStages)
				F.doHarvest()

//TARGET
/obj/item/weapon/tool/automaton_rune/target/area
	name = "area rune"
	desc = "This rune enables an automaton to target things in a square."

/obj/item/weapon/tool/automaton_rune/target/area/runeProc(var/rInp)
	return range(get_turf(src),rInp)

//RANGE

/obj/item/weapon/tool/automaton_rune/range/three
	name = "three rune"
	desc = "This rune enables an automaton to have a range of 3"

/obj/item/weapon/tool/automaton_rune/range/three/runeProc(var/rInp)
	return 3