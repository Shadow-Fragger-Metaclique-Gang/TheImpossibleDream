/obj/structure/ritualcircle/baotha
	allowed_patron = /datum/patron/inhumen/baotha
	rites = list(
		/datum/runeritual/god/ascension/baotha,
		/datum/runeritual/god/broken_glass,
		/datum/runeritual/god/baotha/armaments,
		/datum/runeritual/god/baotha/joybringer,
		/datum/runeritual/god/baotha/fertility_boon,
		/datum/runeritual/god/patron_knife/baotha,
		/datum/runeritual/god/dollmaker
	)
	unworthy_message = "I feel my fingers going numb, and my arms heaving with unseen weight. I shouldn't be trying to use this..."
	rites_title = "Rituals of Unity"

/obj/structure/ritualcircle/baotha/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/baotha
	abstract_type = /datum/runeritual/god/baotha
