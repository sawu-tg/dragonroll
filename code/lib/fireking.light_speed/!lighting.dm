///////////////////////////////////////////
/////////LIGHT SPEED PARAMETERS////////////
///////////////////////////////////////////

#define LIGHTING_ENABLED 1 //set to 0 to disable light
#define LIGHTING_CPU_THROTTLE 25 //if world.cpu exceeds this value, light rendering will not occur
#define LIGHTING_ICON 'lighting_64.dmi' //set this to your lighting icon
#define LIGHTING_LAYER 30 //this is the layer shading will be rendered on
#define LIGHTING_HALF_ICON_SIZE -32 //this is negative half world.icon_size
//so if your world.icon_size is 32, LIGHTING_HALF_ICON_SIZE should be -16

#define LIGHTING_GENERATOR 0 //set to 1 to enable the lighting generator
//Specify your paramters below then run world to generate your own icon

#if LIGHTING_GENERATOR
///////////////////////////////////////////
/////////paramters for generator///////////
///////////////////////////////////////////

var/darkest_alpha = 200 //how dark do you want shading to be
var/lightest_alpha = 0 //how light do you want shading to be
var/detail = 8 //the level of detail for the shading, I don't think its possible to go any higher than 8
var/red = 0 //the color of the shade (not the light)
var/green = 0
var/blue = 0

#endif