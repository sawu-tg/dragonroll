#define LIGHTING_INTERVAL 10 // frequency, in 1/10ths of a second, of the lighting process

#define LIGHTING_FALLOFF 1 // type of falloff to use for lighting; 1 for circular, 2 for square
#define LIGHTING_LAMBERTIAN 1 // use lambertian shading for light sources
#define LIGHTING_HEIGHT 1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone
#define LIGHTING_TRANSITIONS 0 // smooth, animated transitions, similar to /tg/station

#define LIGHTING_RESOLUTION 1 // resolution of the lighting overlays, powers of 2 only, max of 32
#define LIGHTING_LAYER LAYER_LIGHTING // drawing layer for lighting overlays
#define LIGHTING_ICON 'sprite/world/lighting_overlay.dmi' // icon used for lighting shading effects

#define INVISIBILITY_LIGHTING 0
#define CLAMP01(x) max(0, min(1, x))