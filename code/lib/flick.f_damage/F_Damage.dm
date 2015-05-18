

/******************************************************************


     The F_Damage library was inspired by  Spuzzum's s_damage
     library, which allows you to flash numerical values over
     specific targets in your game.  While similar, F_Damage
     includes support for negative values, targets with pixel
     offsets, and larger numbers, including scientific notation.

     Flick


*******************************************************************



     To use F_Damage, you simply call the f_damage() proc, sending
     the target, numerical value, and color.  This will display
     the value briefly over the target, in the selected color.

proc/f_damage(atom/Target, Value, color)

   {
     Target - The mob, obj, or turf where you would like
              the numbers to display.

     Value  - The number you want to display over the target.

     color  - A hexadecimal color code text string.  You can
              send the code in either 3 or 6 digit format.

                "#ffaacc" is the same as "#fac"

              the "#" is optional.


*******************************************************************/


/******************************************************************

    The following defines set a few of F_damages parameters.

*******************************************************************

   F_damage_layer is the layer your numbers will display on.
   This value needs to be higher than any of your other mob,
   obj, or turf layers.

*/
#ifndef F_damage_layer
#define F_damage_layer 10000
#endif

/*

numWidth is the pixel width of individual digits in your icon file.

*/
#ifndef F_damage_numWidth
#define F_damage_numWidth 7
#endif

/*

The icon to get damage digits from. Please follow the structure in
the provided default.

*/
#ifndef F_damage_icon
#define F_damage_icon 'F_damageFade.dmi'
#endif


/*

F_damage_no_scientific disables scientific representation.

*/
#ifdef F_damage_no_scientific
#define F_Damage_sig_figures 65535
#else
#define F_Damage_sig_figures 6
#endif

/*

Horizontal Alignment values

F_damage offers three modes of horizontal alignment:

F_Damage.LEFT_ALIGN
F_Damage.CENTER_ALIGN
F_Damage.RIGHT_ALIGN

The alignment is an optional extra argument to F_damage().

*/

/*

By default, we will log errors and warnings to world.log. This can be
suppressed using F_damage_suppress_errors and F_damage_suppress_warnings
respectively.

*/
#define F_damage_log_errors
#define F_damage_log_warnings














