/obj/structure/ritualcircle/ravox
	allowed_patron = /datum/patron/divine/ravox
	rites = list(/datum/runeritual/god/ravox/vow)
	unworthy_message = "I feel a scornful gaze. This rune isn't for me."
	rites_title = "Rituals of Justice"

/obj/structure/ritualcircle/ravox/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/ravox
	abstract_type = /datum/runeritual/god/ravox
