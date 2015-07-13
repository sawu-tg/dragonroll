var/list/validBiomes = list(/datum/biome/grassland,
	/datum/biome/desert,
	/datum/biome/lavaland,
	/datum/biome/alienlab,
	/datum/biome/snow,
	/datum/biome/meteor)

//var/list/validBiomes = list(/datum/biome/grassland) //uncomment this for biome testing

/datum/biome
	var/name = "default"
	var/desc = "default" //dunno, maybe at some point

	var/turfSize = 7 // size of turf spatters
	var/turf/baseTurf // the base turf of the biome
	var/turf/dirtTurf
	var/list/validTurfs = list() // valid turfs to generate (grass, dirt, floors)
	var/liquidSize = 7 // size of liquid spatters
	var/liquidErode = 7 // size of erosion
	var/list/validLiquids = list() //valid liquids to generate (lava, water, giant pools of tequila)
	var/debrisChance = 15 // chance of placing debris
	var/list/validDebris = list() //valid debris (ruins, obelisks, fat people's orbit)
	var/mobChance = 25 // chance of placing mobs
	var/list/validMobs = list() //valid mobs (animals, villagers, fat people of which the debris orbit)

/datum/biome/grassland
	name = "grassland"
	desc = "grassy and full of life"

	baseTurf = /turf/floor/outside/grass
	dirtTurf = /turf/floor/outside/dirt
	validTurfs = list(/turf/floor/outside/grass,/turf/floor/outside/dirt)
	validLiquids = list(/turf/floor/outside/liquid/water)
	validDebris = list(/obj/interact/nature/bush,/obj/interact/nature/rock,/obj/structure/popupspawn = 0.1, /obj/structure/auranode = 2.5)
	validMobs = list(/mob/player/npc/animal/deer,/mob/player/npc/animal/wasp,/mob/player/npc/animal/bat,/mob/player/npc/animal/spider,/mob/player/npc/animal/cat,/mob/player/npc/animal/bear,/mob/player/npc/animal/cow,/mob/player/npc/animal/chicken,/mob/player/npc/animal/dog,/mob/player/npc/animal/fox,/mob/player/npc/colonist)
/datum/biome/grassland/New()
	validDebris += typesof(/obj/interact/nature/tree)
	..()
/datum/biome/ocean
	name = "ocean"
	desc = "lots of water"
	liquidSize = 30
	liquidErode = 0

	baseTurf = /turf/floor/outside/grass
	dirtTurf = /turf/floor/outside/dirt
	validTurfs = list(/turf/floor/outside/grass,/turf/floor/outside/dirt)
	validLiquids = list(/turf/floor/outside/liquid/water)
	validDebris = list(/obj/interact/nature/bush,/obj/interact/nature/rock,/obj/interact/nature/tree)
	validMobs = list(/mob/player/npc/animal/chicken,/mob/player/npc/animal/crab,/mob/player/npc/animal/dog,/mob/player/npc/colonist)

/datum/biome/desert
	name = "desert"
	desc = "9/10 aliens agree on landing here"

	baseTurf = /turf/floor/outside/dirt
	validTurfs = list(/turf/floor/outside/dirt)
	liquidSize = 2
	liquidErode = 2
	validLiquids = list(/turf/floor/outside/liquid/water)
	validDebris = list(/obj/structure/auranode = 1.5,/obj/interact/nature/bush,/obj/interact/nature/rock,/obj/structure/popupspawn = 0.1,/obj/structure/popupspawn/grub = 0.1)
	validMobs = list(/mob/player/npc/animal/wasp,/mob/player/npc/animal/cat,/mob/player/npc/animal/spider,/mob/player/npc/grey,/mob/player/npc/animal/dog,/mob/player/npc/animal/fox,/mob/player/npc/colonist)

/datum/biome/lavaland
	name = "lava-land"
	desc = "you don't even need a toaster for your bread!"

	baseTurf = /turf/floor/outside/dirt/lava
	validTurfs = list(/turf/floor/outside/dirt/lava)
	liquidSize = 6
	liquidErode = 6
	validLiquids = list(/turf/floor/outside/liquid/lava)
	validDebris = list(/obj/interact/nature/rock,/obj/structure/popupspawn/basilisk = 0.1,/obj/structure/popupspawn/goliath = 0.1,/obj/structure/popupspawn/hivelord = 0.1)
	validMobs = list(/mob/player/npc/animal/bat,/mob/player/npc/animal/spider,/mob/player/npc/grey)

/datum/biome/alienlab
	name = " ??? "
	desc = "\[REDACTED]"

	baseTurf = /turf/floor/outside/shimmering
	validTurfs = list(/turf/floor/outside/shimmering)
	liquidSize = 9
	liquidErode = 9
	validDebris = list(/turf/wall/shimmering)
	validMobs = list(/mob/player/npc/grey)

/datum/biome/snow
	name = "tundra"
	desc = "frosty the generic holiday character may be here."

	baseTurf = /turf/floor/outside/snow
	validTurfs = list(/turf/floor/outside/snow)
	validLiquids = list(/turf/floor/outside/liquid/water/ice)
	validDebris = list(/obj/interact/nature/tree/snow,/obj/interact/nature/bush/snow,/obj/structure/popupspawn/thing = 0.1)
	validMobs = list(/mob/player/npc/animal/deer,/mob/player/npc/animal/bear,/mob/player/npc/colonist,/mob/player/npc/animal/fox,/mob/player/npc/animal/dog)

/datum/biome/meteor
	name = "impact site"
	desc = "meteors can't melt steel beams. 9/11 was an inside job."

	baseTurf = /turf/floor/outside/dirt
	validTurfs = list(/turf/floor/outside/dirt)
	liquidSize = 8
	liquidErode = 0
	validLiquids = list(/turf/floor/outside/liquid/pit)
	validDebris = list(/obj/structure/auranode = 5,/obj/interact/nature/bush,/obj/interact/nature/rock,/obj/structure/popupspawn/thing = 0.1,/obj/structure/popupspawn/goliath = 0.1)
	validMobs = list(/mob/player/npc/animal/bat,/mob/player/npc/animal/spider,/mob/player/npc/grey,/mob/player/npc/colonist)


/datum/biome/darkness
	name = "deep dark"
	desc = "if you're here, you're probably dead"

	baseTurf = /turf/floor/darknessfloor
	validTurfs = list(/turf/floor/darknessfloor)
	liquidSize = 0
	liquidErode = 0
	validLiquids = list()
	validDebris = list()
	validMobs = list()