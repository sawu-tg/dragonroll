#include "demo.dmp"
#include "demo.dmp"

mob
	icon = 'mob.dmi'

	verb
		Little_Hit()
			set desc="Causes up to 1000 damage to you."
			F_damage(src, rand(-1000, -1), "#ff0000")

		Little_Heal()
			set desc="Heals up to 1000 damage to you."
			F_damage(src, rand(1,1000), "77ff00")

		Big_Hit()
			set desc="Does a crapload of damage to you.  Generally shows in scientific notation."
			F_damage(src, rand(-100000, -10000000), "#ff0")

		Big_Heal()
			set desc="Heals you a bunch.  Generally shows in scientific notation."
			F_damage(src, rand(100000, 10000000), rgb(0,255,255))

		Left_Align()
			F_damage(src, rand(1,1000), "#ff0", F_Damage.LEFT_ALIGN)

		Right_Align()
			F_damage(src, rand(1,1000), "#ff0", F_Damage.RIGHT_ALIGN)

		Big_Test_Left()
			for(var/I in 1 to 1000)
				Left_Align()

		Big_Test_Right()
			for(var/I in 1 to 1000)
				Right_Align()

	Bump(atom/Obstacle)
		if(istype(Obstacle, /mob))
			src << "You run smack into a dummy. Ouch!"
			F_damage(Obstacle, rand(1,1000), "#ffffff")

	dummy
		icon = 'mob.dmi'
		icon_state = "RED"

		New()
			..()
			icon_state = pick("RED", "PINK", "BLUE", "GREEN")
			spawn(20)
				pixel_x = rand(-10, 10)
				pixel_y = rand(-10, 10)


client
	New()
		world << "[src] arrives."
		..()
		src << {"Welcome to the demo for my F_damage library.  While similar to Spuzzum's s_damage library, this libary allows \
for larger numbers, negative values, and target pixel offsets.  To see the effects, click on one of the verbs in the verb \
panel, or bump into one of the dummy mobs.

<b><font color="blue">Verb descriptions:</font></b>

Little Hit - This verb causes a red, floating, negative number to appear above you.
Big Hit - This causes a large, yellow, negative number to appear.  Above certain values, the number appears in scientific \
notation.
Little Heal - This creates a small, green, positive number.
Big Heal - And now, a large, aqua, positive number.  Again, really large numbers appear in scientific notation.

Notice that when bumping into the dummy mobs, the floating numbers pixel offset match the dummy, always centering \
themselves above them.

Have fun,

Flick


"}

	Del()
		world << "[src] leaves."
		..()

	verb
		Say(msg as text)
			world << "<b>[src]:</b> [msg]"
	command_text = "Say "

world
	turf = /turf/grass

turf
	grass
		icon = 'turf.dmi'
		New()
			..()
			if(prob(5))
				new/mob/dummy(src)




