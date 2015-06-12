/obj/structure/tank
	name = "liquid tank"
	icon = 'sprite/obj/alchemy/tanks.dmi'
	icon_state = "tank"
	density = 1
	opacity = 0

	var/liquidid
	var/glasscolor = "#66FFFF33"
	var/datum/reagent_holder/reagents

	var/image/fill
	var/image/glass
	var/image/burn
	var/image/burnglow

	var/lastratio
	var/lastcolor
	var/lastburn
	var/lastburncolor

/obj/structure/tank/petrol
	liquidid = "petrol"

/obj/structure/tank/water
	liquidid = "water"

/obj/structure/tank/pyrosium
	liquidid = "pyrosium"

/obj/structure/tank/nasty/New()
	..()

	spawn(40)
		world << reagents.addliquid("milk",372)
		world << reagents.addliquid("water",372)

/obj/structure/tank/New()
	..()

	reagents = new(src,1000)

	if(liquidid)
		spawn(rand(40,200))
			reagents.addliquid(liquidid,1000)

	reagents.activate()

	addProcessingObject(src)

/obj/structure/tank/doProcess()
	update_icon()

/obj/structure/tank/proc/update_icon()
	if(!reagents)
		return

	var/ratio = 0

	if(reagents.maxvolume)
		ratio = reagents.currentvolume / reagents.maxvolume
	var/fillstate = "tank_fill0"

	switch(ratio)
		if(0.0001 to 0.25)
			fillstate = "tank_fill10"
		if(0.25 to 0.5)
			fillstate = "tank_fill25"
		if(0.5 to 0.75)
			fillstate = "tank_fill50"
		if(0.75 to 0.8)
			fillstate = "tank_fill75"
		if(0.8 to 0.95)
			fillstate = "tank_fill80"
		if(0.95 to 1.00)
			fillstate = "tank_fill100"

	if(!fill)
		fill = image(icon,src,fillstate)
	if(ratio != lastratio || reagents.color != lastcolor)
		overlays -= fill
		fill.color = reagents.color
		fill.layer = layer + 0.1
		fill.icon_state = fillstate
		overlays += fill

	if(!glass)
		glass = image(icon,src,"tank_glass")
		glass.color = glasscolor
		glass.layer = layer + 0.2
		overlays += glass

	if(reagents.burning != lastburn || lastburncolor != reagents.burncolor)
		overlays -= burn
		overlays -= burnglow

		set_light(4 * reagents.burning,2,reagents.burncolor)

		if(reagents.burning)
			if(!burn)
				burn = image(icon,src,"tank_fire")
			burn.color = reagents.burncolor
			burn.blend_mode = BLEND_ADD
			burn.layer = layer + 0.15

			if(!burnglow)
				burnglow = image(icon,src,"tank_fire")
			burnglow.color = reagents.burncolor
			burnglow.blend_mode = BLEND_ADD
			burnglow.alpha = 0.5
			burnglow.layer = 1000//layer + 0.25
			var/matrix/scale = matrix()
			scale.Scale(1.2,1.2)
			burnglow.transform = scale

			overlays += burn
			overlays += burnglow

	lastcolor = reagents.color
	lastburn = reagents.burning
	lastburncolor = reagents.burncolor
	lastratio = ratio

/obj/structure/tank/examine(mob/user)
	if(desc)
		messageInfo("> [desc]",user,src)

	for(var/datum/reagent/R in reagents.liquidlist)
		messageInfo(">> contains [R.name] ([R.volume]u)",user,src)