/obj/structure/ritualcircle/graggar
	allowed_patron = /datum/patron/inhumen/graggar
	rites = list(
		/datum/runeritual/god/ascension/graggar,
		/datum/runeritual/god/broken_glass,
		/datum/runeritual/god/graggar/armaments,
		/datum/runeritual/god/graggar/war_ritual,
		/datum/runeritual/god/patron_knife/graggar,
	)
	unworthy_message = "I hear a distant war cry in the back of my mind as I touch this..."
	rites_title = "Rituals of Violence"

/obj/structure/ritualcircle/graggar/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/graggar
	abstract_type = /datum/runeritual/god/graggar
