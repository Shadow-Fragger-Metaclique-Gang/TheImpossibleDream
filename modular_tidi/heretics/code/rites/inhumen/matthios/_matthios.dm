/obj/structure/ritualcircle/matthios
	allowed_patron = /datum/patron/inhumen/matthios
	rites = list(
		/datum/runeritual/god/ascension/matthios,
		/datum/runeritual/god/broken_glass,
		/datum/runeritual/god/matthios/armaments,
		/datum/runeritual/god/matthios/defenestration,
		/datum/runeritual/god/patron_knife/matthios,
		/datum/runeritual/god/dollmaker,
		/datum/runeritual/god/hex/matthios/plunderer
	)
	unworthy_message = "Somehow, I get the feeling touching this will take something from me..."
	rites_title = "Rituals of Transaction"

/obj/structure/ritualcircle/matthios/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/matthios
	abstract_type = /datum/runeritual/god/matthios
