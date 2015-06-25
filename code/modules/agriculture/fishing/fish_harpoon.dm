/obj/item/food/fish/tuna
	name = "tuna"
	required_level_fishing = 35
	exp_granted_fishing = 80
	level_required_cooking = 30
	exp_granted_cooking = 100

/obj/item/food/fish/swordfish
	name = "swordfish"
	required_level_fishing = 50
	exp_granted_fishing = 100
	level_required_cooking = 45
	exp_granted_cooking = 140

/obj/item/food/fish/shark
	name = "shark"
	required_level_fishing = 76
	exp_granted_fishing = 110
	level_required_cooking = 80
	exp_granted_cooking = 210

/obj/item/food/fish/great_white_shark
	name = "great white shark"
	required_level_fishing = 80
	exp_granted_fishing = 130
	level_required_cooking = 84
	exp_granted_cooking = 212

/obj/item/food/fish/great_white_shark
	name = "great white shark"
	required_level_fishing = 80
	exp_granted_fishing = 130
	level_required_cooking = 84
	exp_granted_cooking = 212

/obj/item/food/fish/sponge
	name = "sponge"
	desc = "Are you feeling it now Mr. Krabs?" // why
	icon_state = "bob"
	required_level_fishing = 100
	exp_granted_fishing = 200
	level_required_cooking = 100
	exp_granted_cooking = 400

/obj/item/food/fish/sponge/New()
	..()
	var/matrix/M = matrix(transform)
	M.Turn(rand(1,360))
	transform = M

/obj/item/food/fish/squid
	name = "squid"
	required_level_fishing = 80
	exp_granted_fishing = 130
	level_required_cooking = 84
	exp_granted_cooking = 212