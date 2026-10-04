/mob/living/carbon/human/proc/human_modular_examine_lines(mob/user, observer_privilege, m1, m2, m3)
	var/list/lines = list()
	var/list/ext_lines = human_modular_examine_extension(user, observer_privilege, m1, m2, m3)
	if(length(ext_lines))
		lines += ext_lines
	return lines

/mob/living/carbon/human/proc/human_chastity_examine_lines(mob/user, m1, m2, m3)
	. = list()
	// chastity cages go HERE, where they SHOULD'VE FUCKING GONE.
	var/obj/item/chastity/worn_chastity = chastity_device
	if(worn_chastity)
		var/chastity_name = get_item_examine_label(worn_chastity, user)
		var/cage_exposed = get_location_accessible(src, BODY_ZONE_PRECISE_GROIN)
		var/do_we_know_chat = (user == src)
		if(cage_exposed)
			. += "[m1] secured in [chastity_name]. "
		else if(do_we_know_chat)
			. += span_italics("[m1] covertly secured in [chastity_name]. ")

	var/chastity_toy_line = human_chastity_toy_examine_line(user, m2, m3)
	if(chastity_toy_line)
		. += chastity_toy_line

/mob/living/carbon/human/proc/human_brand_examine_lines(m2)
	. = list()
	if(branded) // we are branded, now check what bodypart brands we've got. genital brands handled separately.
		for(var/obj/item/bodypart/branded_bodypart as anything in bodyparts)
			if(length(branded_bodypart.branded_writing) && get_location_accessible(src, branded_bodypart.body_zone))
				. += span_info("[capitalize(m2)] [LOWER_TEXT(branded_bodypart.name)] has been branded with ") + "[span_boldwarning(branded_bodypart.branded_writing)]."
			if(istype(branded_bodypart, /obj/item/bodypart/chest))
				var/obj/item/bodypart/chest/chest = branded_bodypart
				if(length(chest.branded_writing_on_buttocks) && get_location_accessible(src, BODY_ZONE_PRECISE_GROIN))
					. += span_info("[capitalize(m2)] hindquarters has been branded with ") + "[span_boldwarning(chest.branded_writing_on_buttocks)]."
				if(length(chest.branded_writing_on_stomach) && get_location_accessible(src, BODY_ZONE_PRECISE_STOMACH))
					. += span_info("[capitalize(m2)] stomach has been branded with ") + "[span_boldwarning(chest.branded_writing_on_stomach)]."
			else if(istype(branded_bodypart, /obj/item/bodypart/head))
				var/obj/item/bodypart/head/neck = branded_bodypart
				if(length(neck.branded_writing_on_neck) && get_location_accessible(src, BODY_ZONE_PRECISE_NECK))
					. += span_info("[capitalize(m2)] neck has been branded with ") + "[span_boldwarning(neck.branded_writing_on_neck)]."

/mob/living/carbon/human/proc/human_sex_status_examine_lines(mob/user, observer_privilege, m1, m2, m3)
	. = list()
	// Leashed pet status effect message
	if(has_status_effect(/datum/status_effect/leash_pet))
		. += span_warning("A leash is hooked to their collar. They are being led like a pet.")

	// Knotted effect message
	if(has_status_effect(/datum/status_effect/knot_tied))
		. += span_warning("A knot is locked inside [p_them()]. [m1] being pulled around like a pet.")

	// Facial/Creampie/Body shot effect message
	var/datum/status_effect/facial/facial = has_status_effect(/datum/status_effect/facial)
	var/datum/status_effect/facial/external/external = has_status_effect(/datum/status_effect/facial/external)
	var/datum/status_effect/facial/internal/creampie = null
	var/datum/status_effect/creampie_leak/drip = null
	if(observer_privilege || get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		creampie = has_status_effect(/datum/status_effect/facial/internal)
		drip = has_status_effect(/datum/status_effect/creampie_leak/long)
		if(!drip)
			drip = has_status_effect(/datum/status_effect/creampie_leak)
	var/any_cum_effect = facial || external || creampie
	if(any_cum_effect || drip)
		var/show_detail = (user == src) || observer_privilege
		if(!show_detail && isliving(user))
			var/mob/living/L = user
			show_detail = (L.STAPER >= 8 && L.STAINT >= 5)
		if(!show_detail)
			if(any_cum_effect)
				. += span_warning("[m1] covered in something glossy!")
		else
			if(external)
				. += span_aiprivradio("[capitalize(m2)] body is [!external.has_dried_up ? "covered in cum" : "covered in dried cum"]!")
			if(facial)
				. += span_aiprivradio("[capitalize(m2)] face is [!facial.has_dried_up ? "glazed with cum" : "plastered with dried cum"]!")
			if(creampie && (!drip || !(drip.orifice & ~SEX_PART_TAIL_MAW)))
				. += span_aiprivradio("[capitalize(m2)] crotch is [!creampie.has_dried_up ? "a cummy mess" : "stained with dried cum"]!")
			if(drip && drip.orifice != SEX_PART_TAIL_MAW)
				var/is_long = istype(drip, /datum/status_effect/creampie_leak/long)
				switch(drip.orifice & ~SEX_PART_TAIL_MAW)
					if(SEX_PART_CUNT)
						. += span_aiprivradio("[m1] [is_long ? "gushing cum from [m2] sex" : "trickling cum from [m2] sex"]!")
					if(SEX_PART_ANUS)
						. += span_aiprivradio("[m1] [is_long ? "leaking heavily from [m2] ass" : "leaking cum from [m2] ass"]!")
					if(SEX_PART_SLIT_SHEATH)
						. += span_aiprivradio("[m1] [is_long ? "leaking heavily from [m2] slit" : "trickling cum from [m2] slit"]!")
					if(SEX_PART_CUNT|SEX_PART_ANUS)
						. += span_aiprivradio("[m1] [is_long ? "leaking heavily from both [m2] holes" : "dripping cum from both [m2] holes"]!")
					else
						. += span_aiprivradio("[m1] [is_long ? "leaking a heavy load" : "dripping cum from [m2] nethers"]!")
	. += human_modular_examine_lines(user, observer_privilege, m1, m2, m3)
