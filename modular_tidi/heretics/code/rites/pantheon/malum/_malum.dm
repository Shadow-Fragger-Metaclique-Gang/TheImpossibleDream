/obj/structure/ritualcircle/malum
	allowed_patron = /datum/patron/divine/malum
	rites = list(/datum/runeritual/god/malum/bestow_blessing)
	unworthy_message = "This rune references schematics I don't understand."
	rites_title = "Rituals of Creation"

/obj/structure/ritualcircle/malum/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/malum
	abstract_type = /datum/runeritual/god/malum
