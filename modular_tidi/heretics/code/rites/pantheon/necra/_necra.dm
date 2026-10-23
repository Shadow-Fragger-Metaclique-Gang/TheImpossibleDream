/obj/structure/ritualcircle/necra
	allowed_patron = /datum/patron/divine/necra
	rites = list(
		/datum/runeritual/god/necra/hollow_the_mist,
		/datum/runeritual/god/necra/undermaidens_bargain,
		/datum/runeritual/god/necra/the_toll,
		/datum/runeritual/god/necra/shatter_the_binds,
	)
	unworthy_message = "I hear angered whispering...I probably shouldn't touch this."
	rites_title = "Rituals of Death"

/obj/structure/ritualcircle/necra/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/necra
	abstract_type = /datum/runeritual/god/necra
