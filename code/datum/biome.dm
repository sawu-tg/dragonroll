var/list/validBiomes = list(/datum/biome/grassland,/datum/biome/desert,/datum/biome/lavaland,/datum/biome/alienlab)

/datum/biome
	var/name = "default"
	var/desc = "default" //dunno, maybe at some point

	var/turfSize = 7 // size of turf spatters
	var/turf/baseTurf
	var/list/validTurfs = list() // valid turfs to generate (grass, dirt, floors)
	var/liquidSize = 7 // size of liquid spatters
	var/list/validLiquids = list() //valid liquids to generate (lava, water, giant pools of tequila)
	var/debrisChance = 15 // chance of placing debris
	var/list/validDebris = list() //valid debris (ruins, obelisks, fat people's orbit)
	var/mobChance = 5 // chance of placing mobs
	var/list/validMobs = list() //valid mobs (animals, villagers, fat people of which the debris orbit)

/datum/biome/grassland
	name = "grassland"
	desc = "grassy and full of life"

	baseTurf = /turf/floor/outside/grass
	validTurfs = list(/turf/floor/outside/grass,/turf/floor/outside/dirt)
	validLiquids = list(/turf/floor/outside/liquid/water)
	validDebris = list(/obj/interact/nature/bush,/obj/interact/nature/rock,/obj/interact/nature/tree)
	validMobs = list(/mob/player/npc/chicken,/mob/player/npc/colonist)

/datum/biome/desert
	name = "desert"
	desc = "9/10 aliens agree on landing here"

	baseTurf = /turf/floor/outside/dirt
	validTurfs = list(/turf/floor/outside/dirt)
	liquidSize = 2
	validLiquids = list(/turf/floor/outside/liquid/water)
	validDebris = list(/obj/interact/nature/bush,/obj/interact/nature/rock)
	validMobs = list(/mob/player/npc/grey,/mob/player/npc/colonist)

/datum/biome/lavaland
	name = "lava-land"
	desc = "you don't even need a toaster for your bread!"

	baseTurf = /turf/floor/outside/dirt
	validTurfs = list(/turf/floor/outside/dirt)
	liquidSize = 6
	validLiquids = list(/turf/floor/outside/liquid/lava)
	validDebris = list(/obj/interact/nature/rock)
	validMobs = list(/mob/player/npc/grey)

/datum/biome/alienlab
	name = " ??? "
	desc = "\[REDACTED]"

	baseTurf = /turf/floor/outside/shimmering
	validTurfs = list(/turf/floor/outside/shimmering)
	liquidSize = 9
	validDebris = list(/turf/wall/shimmering)
	validMobs = list(/mob/player/npc/grey)