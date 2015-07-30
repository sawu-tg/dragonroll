#define INFINITY 1e31	//closer then enough
#define TILE_WIDTH  32
#define TILE_HEIGHT 32
#define TICK_LAG 0.35

#define SAVING_REFLEX 1
#define SAVING_WILL 2
#define SAVING_FORTITUDE 3

#define DTYPE_MELEE 1
#define DTYPE_NONLETHAL 2
#define DTYPE_MASSIVE 3
#define DTYPE_DIRECT 4
#define DTYPE_MAGIC 5
#define DTYPE_ENVIRONMENT 6

#define INTENT_HELP 1
#define INTENT_HARM 2
#define INTENT_SNEAK 3
#define INTENT_DIPLOMACY 4

#define BLEEDING_INTERVAL 240

//npc stuff
#define NPCSTATE_IDLE 1
#define NPCSTATE_MOVE 2
#define NPCSTATE_FIGHTING 3

#define NPCTYPE_PASSIVE 10
#define NPCTYPE_AGGRESSIVE 11
#define NPCTYPE_DEFENSIVE 12

//"Active" states, ie applied in combat
#define ACTIVE_STATE_NORMAL 2
#define ACTIVE_STATE_DAZED 4
#define ACTIVE_STATE_COWERING 8
#define ACTIVE_STATE_DYING 16
#define ACTIVE_STATE_POISONED 32
#define ACTIVE_STATE_HELPLESS 64
#define ACTIVE_STATE_PANICKED 128
#define ACTIVE_STATE_PINNED 256
#define ACTIVE_STATE_PRONE 512
#define ACTIVE_STATE_SHAKEN 1024
#define ACTIVE_STATE_STUNNED 2048

//"Passive" states, ie constant and lasting/ out of combat
#define PASSIVE_STATE_BLINDED_LEFT 2
#define PASSIVE_STATE_BLINDED_RIGHT 4
#define PASSIVE_STATE_EXHAUSTED 8
#define PASSIVE_STATE_FATIGUED 16
#define PASSIVE_STATE_FLATFOOT 32
#define PASSIVE_STATE_NAUSEATED 64
#define PASSIVE_STATE_DISABLED 128
#define PASSIVE_STATE_STABLE 256
#define PASSIVE_STATE_DEAD 512
#define PASSIVE_STATE_DEAF 1024
#define PASSIVE_STATE_UNCONCIOUS 2048

//layers
#define LAYER_INTERFACE MOB_LAYER+100
#define LAYER_LIGHTING MOB_LAYER+10
#define LAYER_OVERLAY MOB_LAYER+1
#define LAYER_UNDERLAY MOB_LAYER-1
#define LAYER_DEFAULT MOB_LAYER
#define LAYER_HIDDEN -99

#define LIGHTING_DECAY_RATE 1 //amount for light to decay to dark
#define LIGHTING_MAX_STATES 7 //how many states of luminosity are in the lighting.dm
#define LIGHTING_MINIMUM_THRESHOLD 0 //the lowest level a light will decay to minus one, -1 means complete darkness.

#define TURF_INSIDE 0
#define TURF_OUTSIDE 1
#define TURF_FULLBRIGHT 2
#define TURF_NOLIGHT 3

#define VEHICLE_PASS_LAND 2
#define VEHICLE_PASS_LIQUID_WATER 4
#define VEHICLE_PASS_LIQUID_ALL 8
#define VEHICLE_PASS_ANY 16

#define GLOBAL_CLICK_DELAY 5

#define ALIGN_NEUTRAL 0
#define ALIGN_EVIL -1
#define ALIGN_GOOD 1

#define FALLOFF_SOUNDS	1
#define SURROUND_CAP	7


///
// REAGENT STATES
///

#define REAGENT_STATE_SOLID 1
#define REAGENT_STATE_LIQUID 2
#define REAGENT_STATE_POWDER 3

///
// RGB DEFINES
///
#define COL_HOSTILE rgb(255,0,0)
#define COL_FRIENDLY rgb(0,255,0)
#define COL_INFO rgb(255,255,0)
#define COL_INFOTICK rgb(255,0,255)

///
// PARTICLE TYPES
///

#define PART_PHYS_SCATTER 2
#define PART_PHYS_WHIRL 4
#define PART_PHYS_FALL 8
#define PART_PHYS_EXPLODE 16

///
// OBJECTIVES
///
#define OBJ_STEAL 1 // steal an objective
#define OBJ_DESTROY 2 // kill/destroy an objective
#define OBJ_RULE 3 // become the leader of your own faction
#define OBJ_USURP 4 // become the leader of another faction
#define OBJ_HITLER 5 // entirely remove a faction from the game
#define OBJ_DISCOVER 6 // find a target
#define OBJ_AVENGE 7 // take revenge on a target

var/list/playerValidHair = list()
var/list/playerValidFacial = list()
var/list/playerList = list()
var/list/procObjects = list()
var/list/levelNames = list()
var/list/regions = list()
var/list/erodeLiquids = list()
var/list/newErodeLiquids = list()

var/list/globalMobList = list()
var/list/globalObjList = list()
var/list/globalAreas = list()

var/datum/controller_master/CS
var/datum/controller/balance/balance
var/datum/controller/diplomacy/diplomacy
var/datum/controller/cartography/cartography
var/datum/controller/chemicals/chemicals
var/datum/controller/antags/antags

var/list/globalAdmins = list()

///
// Non-define defines..?
///

client/AllowUpload(filename, filelength)
	if(filelength >= 524288)  // 512K (0.5M)
		messageError("[filename] is larger than 512k, unable to upload!",src,src)
		return 0
	return 1