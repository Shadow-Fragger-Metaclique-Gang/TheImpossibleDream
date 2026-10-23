/obj/structure/ritualcircle/xylix
	allowed_patron = /datum/patron/divine/xylix
	rites = list(/datum/runeritual/god/xylix/stagehands_silence)
	unworthy_message = "Every time I'm about to get it, it turns into something else."
	rites_title = "The Twin-Mask's Trickeries"

/obj/structure/ritualcircle/xylix/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/xylix
	abstract_type = /datum/runeritual/god/xylix
