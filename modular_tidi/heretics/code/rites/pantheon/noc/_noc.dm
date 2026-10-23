/obj/structure/ritualcircle/noc
	allowed_patron = /datum/patron/divine/noc
	rites = list(/datum/runeritual/god/noc/moonlight_dance, /datum/runeritual/god/noc/moonlight_inspiration)
	unworthy_message = "I can't make any sense of this..."
	rites_title = "Rituals of the Moon"

/obj/structure/ritualcircle/noc/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/noc
	abstract_type = /datum/runeritual/god/noc
