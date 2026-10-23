/obj/structure/ritualcircle/dendor
	allowed_patron = /datum/patron/divine/dendor
	rites = list(/datum/runeritual/god/dendor/lesser_volf)
	unworthy_message = "I can't interpret such mad scrawlings."
	rites_title = "Rituals of the Beast"

/obj/structure/ritualcircle/dendor/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/dendor
	abstract_type = /datum/runeritual/god/dendor
