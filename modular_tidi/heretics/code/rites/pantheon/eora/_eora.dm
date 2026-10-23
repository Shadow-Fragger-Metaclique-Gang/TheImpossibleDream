/obj/structure/ritualcircle/eora
	allowed_patron = /datum/patron/divine/eora
	rites = list(/datum/runeritual/god/eora/pacification, /datum/runeritual/god/eora/open_hearth)
	unworthy_message = "I don't have the heart for this..."
	rites_title = "Rituals of Love"

/obj/structure/ritualcircle/eora/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/eora
	abstract_type = /datum/runeritual/god/eora
