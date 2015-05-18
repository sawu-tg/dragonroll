#include "F_Damage.dm"
#include "Cache.dm"

// Logging.
#define F_DAMAGE_LOG(SEVERITY, MSG) world.log << "\[[SEVERITY] - f_damage\] [MSG]"

#if defined(F_damage_log_errors) && !defined(F_damage_suppress_errors)
	#define F_DAMAGE_ERROR(MSG) F_DAMAGE_LOG("ERROR", MSG)
#else
	#define F_DAMAGE_ERROR(MSG)
#endif

#if defined(F_damage_log_warnings) && !defined(F_damage_suppress_warnings)
	#define F_DAMAGE_WARNING(MSG) F_DAMAGE_LOG("WARNING", MSG)
#else
	#define F_DAMAGE_WARNING(MSG)
#endif

#if defined(F_damage_log_verbose) && !defined(F_damage_suppress_verbose)
	#define F_DAMAGE_VERBOSE(MSG) F_DAMAGE_LOG("INFO", MSG)
#else
	#define F_DAMAGE_VERBOSE(MSG)
#endif

// Magic characters etc.
#define F_DAMAGE_POUND 	 35
#define ZERO 	 48
#define NINE 	 57
#define UPPER_A  65
#define UPPER_F  70
#define LOWER_A  97
#define LOWER_F  102
#define OUT_RANGE(VALUE, MIN, MAX) (VALUE < MIN || VALUE > MAX)

// Global icon cache.
var/__f_damage_Cache/f_damage_cache = new()

// Someone is probably fiddling with this stuff.
obj/F_damage_num
	layer 		= F_damage_layer
	name 		= ""
	icon_state 	= ""
	var
		F_damageValue

proc/F_damage(atom/Target, value, color = "#ff0000", F_Damage_Horizontal_Alignment/halign = F_Damage.CENTER_ALIGN)
	// This should not be our problem, but the API took care of it before ...
	if (istext(color) && text2ascii(color) != F_DAMAGE_POUND)
		color = "#[color]"
	if (!F_validColor(color))
		F_DAMAGE_ERROR("[color] passed to F_damage is not a valid color, context: [Target], [value]")
		return
	if (!isnum(value))
		F_DAMAGE_ERROR("[value] passed to F_damage is not a valid number, context: [Target], [value]")
		return
	if (!istype(Target))
		F_DAMAGE_ERROR("[Target] passed to F_damage is not at least an /atom, context: [Target], [value]")
		return
	var/list/numbers 	= new()
	var/textValue    	= num2text(value, F_Damage_sig_figures)
	var/length		 	= length(textValue)
	var/icon/targetIcon = icon(Target.icon, Target.icon_state, Target.dir) // Here's to hoping this is cheap.
	var/width			= targetIcon.Width()
	var/height			= targetIcon.Height()
	var/icon/I = f_damage_cache.get(color)
	if (I == null)
		I = new(F_damage_icon)
		I.Blend(color, ICON_MULTIPLY)
		f_damage_cache.put(color, I)
	for (var/i in 1 to length)
		var/obj/F_damage_num/O = new()
		halign.align(O, width, length, i)
		O.icon    = I
		O.pixel_y = Target.pixel_y + (height - 7)
		O.F_damageValue = copytext(textValue, i, i + 1)
		numbers += O
	if(ismob(Target) || isobj(Target))
		Target = Target.loc
	for(var/obj/F_damage_num/O in numbers)
		O.loc = Target
		flick(O.F_damageValue, O)
		spawn(10)
			del O

// Silly API exposed code.
proc/F_validColor(value)
	/*
	 * Previous code for this permitted values like 7045 (as num), which clearly makes no sense.
	 * Don't force things to text to attempt to ensure variable sanity, guys.
	 */
	if (!istext(value))
		F_DAMAGE_WARNING("[value] passed to F_validColor was not a text string")
		return FALSE
	if (text2ascii(value) != F_DAMAGE_POUND)
		F_DAMAGE_WARNING("[value] passed to F_validColor does not begin with #")
		return FALSE
	var/length = length(value)
	if (length != 7 && length != 4)
		F_DAMAGE_WARNING("[value] passed to F_validColor is [length] chars long, expecting 4 or 7")
		return FALSE
	for(var/i in (2 to length))
		var/char = text2ascii(value, i)
		if (OUT_RANGE(char, ZERO, NINE) && OUT_RANGE(char, LOWER_A, LOWER_F) && OUT_RANGE(char, UPPER_A, UPPER_F))
			F_DAMAGE_WARNING("[value] passed to F_validColor has an invalid char at position [i], must be 0-9 or a-f or A-F")
			return FALSE
	F_DAMAGE_VERBOSE("[value] passed to F_validColor is a valid colour")
	return TRUE

// Be polite and tidy up.
#undef F_DAMAGE_LOG
#undef F_DAMAGE_ERROR
#undef F_DAMAGE_WARNING
#undef F_DAMAGE_VERBOSE
#undef F_DAMAGE_POUND
#undef ZERO
#undef NINE
#undef UPPER_A
#undef UPPER_F
#undef LOWER_A
#undef LOWER_F
#undef OUT_RANGE
