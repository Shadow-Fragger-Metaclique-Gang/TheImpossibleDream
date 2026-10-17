/obj/structure/ritualcircle/astrata
	allowed_patron = /datum/patron/divine/astrata
	rites = list(/datum/runeritual/god/astrata/guiding_light)
	unworthy_message = "The rune is unresponsive to touch, as if something deems me unworthy."
	rites_title = "Rituals of the Sun"

/obj/structure/ritualcircle/astrata/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/astrata
	abstract_type = /datum/runeritual/god/astrata
