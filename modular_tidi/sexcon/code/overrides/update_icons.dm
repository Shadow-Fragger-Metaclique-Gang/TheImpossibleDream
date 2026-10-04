/mob/living/carbon/human/proc/add_belt_toy_overlay(list/standing_front, mutable_appearance/mbeltoverlay)
	if(istype(belt, /obj/item/storage/belt/rogue)) // check if belt has dildo attached
		var/obj/item/storage/belt/rogue/belt_with_dildo = belt
		if(istype(belt_with_dildo.attached_toy, /obj/item/dildo)) // draw dildo in correct position
			var/mutable_appearance/mbeltoverlaydildo = mutable_appearance('modular/icons/obj/lewd/dildo.dmi', "dildo_belt_[belt_with_dildo.attached_toy.dildo_size]", layer = -ABOVE_BODY_FRONT_LAYER)
			mbeltoverlaydildo.color = belt_with_dildo.attached_toy.color // get material color
			mbeltoverlaydildo.pixel_x = mbeltoverlay.pixel_x
			mbeltoverlaydildo.pixel_y = mbeltoverlay.pixel_y
			standing_front += mbeltoverlaydildo

/mob/living/carbon/human/proc/add_chastity_toy_overlay(list/standing_front)
	var/mutable_appearance/chastity_overlay = chastity_attached_toy_overlay()
	if(chastity_overlay)
		standing_front += chastity_overlay

/mob/living/carbon/human/generate_icon_render_key()
	. = ..()
	if(sexcon)
		. += "-[sexcon.bottom_exposed]-[sexcon.hide_pintle_visuals]"
