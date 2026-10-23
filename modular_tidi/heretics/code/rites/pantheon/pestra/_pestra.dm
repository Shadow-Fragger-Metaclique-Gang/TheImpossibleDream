/obj/structure/ritualcircle/pestra
	allowed_patron = /datum/patron/divine/pestra
	rites = list(/datum/runeritual/god/pestra/flylords_triage, /datum/runeritual/god/pestra/vow_of_aesculapius)
	unworthy_message = "I don't want to touch this, it smells like decay..."
	rites_title = "Rituals of Plague"

/obj/structure/ritualcircle/pestra/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/pestra
	abstract_type = /datum/runeritual/god/pestra
