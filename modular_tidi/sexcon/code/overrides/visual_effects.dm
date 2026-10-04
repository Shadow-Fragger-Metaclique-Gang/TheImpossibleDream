/obj/effect/temp_visual/heart/sex_effects_invisible
	duration = 4 SECONDS
	plane = GAME_PLANE_UPPER
	icon_state = null

/obj/effect/temp_visual/heart/sex_effects_invisible/Initialize(mapload, mob/seers, custom_state = "redheart")
	. = ..()
	layer = prob(50) ? ABOVE_MOB_LAYER : BELOW_MOB_LAYER
	var/image/I = image(icon = 'modular_tidi/sexcon/icons/erpeffects.dmi', icon_state = custom_state, layer = layer, loc = src)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/People, "erp_effect", I, seers)
	I.alpha = 255
	I.appearance_flags = RESET_ALPHA
	I.pixel_x = rand(-10, 10)
	I.pixel_y = rand(-10, 10)
	animate(I, pixel_x = I.pixel_x + rand(-5, 5), pixel_y = I.pixel_y + rand(28, 40), alpha = 0, time = duration)
