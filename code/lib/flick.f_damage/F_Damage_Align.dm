/**
 * Horizontal alignment datums, used to implement alignment logic.
 */
F_Damage_Horizontal_Alignment
	proc
		align(var/obj/F_damage_num/O, var/target_width, var/damage_length, var/position)

F_Damage_Horizontal_Alignment/left
	align(var/obj/F_damage_num/O, var/target_width, var/damage_length, var/position)
		O.pixel_x = ( position - 2 ) * F_damage_numWidth

F_Damage_Horizontal_Alignment/center
	align(var/obj/F_damage_num/O, var/target_width, var/damage_length, var/position)
		O.pixel_x = ( round( target_width / 2 ) + ( ( position - 1 ) * F_damage_numWidth ) ) - ( ( damage_length / 2 ) * F_damage_numWidth )

F_Damage_Horizontal_Alignment/right
	align(var/obj/F_damage_num/O, var/target_width, var/damage_length, var/position)
		O.pixel_x = target_width + ( position * F_damage_numWidth ) - damage_length * F_damage_numWidth