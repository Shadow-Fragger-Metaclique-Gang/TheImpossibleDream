/obj/structure/ritualcircle/abyssor
	allowed_patron = /datum/patron/divine/abyssor
	rites = list(/datum/runeritual/god/abyssor/tides)
	unworthy_message = "It looks like half the chalk has been muddled with water. Is that intentional?"
	rites_title = "Rite of the Tides"

/obj/structure/ritualcircle/abyssor/attack_hand(mob/living/user)
	return use_rites(user)

/obj/structure/ritualcircle/abyssor_alt_inactive
	allowed_patron = /datum/patron/divine/abyssor
	rites = list(/datum/runeritual/god/abyssor/crystal_spire, /datum/runeritual/god/abyssor/dreamcraft)
	unworthy_message = "Something pulls at my mind. I feel dizzy for a moment."
	rites_title = "Rites of his dream"

/obj/structure/ritualcircle/abyssor_alt_inactive/can_use_rites(mob/living/user)
	// Allow both Abyssorites and Dreamwalkers to use the rune
	return ..() || HAS_TRAIT(user, TRAIT_DREAMWALKER)

/obj/structure/ritualcircle/abyssor_alt_inactive/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/abyssor
	abstract_type = /datum/runeritual/god/abyssor
