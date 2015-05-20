#define SAVING_REFLEX 1
#define SAVING_WILL 2
#define SAVING_FORTITUDE 3

#define DTYPE_BASIC 1
#define DTYPE_NONLETHAL 2
#define DTYPE_MASSIVE 3
#define DTYPE_DIRECT 4

#define INTENT_HELP 1
#define INTENT_HARM 2
#define INTENT_SNEAK 3

#define BLEEDING_INTERVAL 90

//npc stuff
#define NPCSTATE_IDLE 1
#define NPCSTATE_MOVE 2
#define NPCSTATE_FIGHTING 3

#define NPCTYPE_PASSIVE 10
#define NPCTYPE_PASSIVE_MINTIME 10

#define NPCTYPE_AGGRESSIVE 11
#define NPCTYPE_AGGRESSIVE_MINTIME 15

#define NPCTYPE_DEFENSIVE 12
#define NPCTYPE_DEFENSIVE_MINTIME 10

//"Active" states, ie applied in combat
#define ACTIVE_STATE_NORMAL 2
#define ACTIVE_STATE_DAZED 4
#define ACTIVE_STATE_COWERING 8
#define ACTIVE_STATE_DYING 16
#define ACTIVE_STATE_ENTANGLED 32
#define ACTIVE_STATE_GRAPPLE 64
#define ACTIVE_STATE_HELPLESS 128
#define ACTIVE_STATE_PANICKED 256
#define ACTIVE_STATE_PARALYZED 512
#define ACTIVE_STATE_PINNED 1024
#define ACTIVE_STATE_PRONE 2048
#define ACTIVE_STATE_SHAKEN 4096
#define ACTIVE_STATE_STUNNED 8192

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
var/list/playerValidHair = list()
var/list/playerValidFacial = list()
