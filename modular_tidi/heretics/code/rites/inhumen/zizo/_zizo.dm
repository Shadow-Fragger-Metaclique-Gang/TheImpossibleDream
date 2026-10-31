/obj/structure/ritualcircle/zizo
	allowed_patron = /datum/patron/inhumen/zizo
	rites = list(
		/datum/runeritual/god/ascension/zizo,
		/datum/runeritual/god/broken_glass,
		/datum/runeritual/god/zizo/armaments,
		/datum/runeritual/god/zizo/chant_of_insight,
		/datum/runeritual/god/zizo/dance_of_the_demiurge,
		/datum/runeritual/god/zizo/raise_deadite,
		/datum/runeritual/god/patron_knife/zizo,
		/datum/runeritual/god/dollmaker,
		/datum/runeritual/god/hex/zizo/veiled_eyes,
		/datum/runeritual/god/hex/zizo/false_witness
	)
	unworthy_message = "Touching it sends a cold shock up my arm. I shouldn't be trying to use this..."
	rites_title = "Rituals of Ambition"

/obj/structure/ritualcircle/zizo/attack_hand(mob/living/user)
	return use_rites(user)

/datum/runeritual/god/zizo
	abstract_type = /datum/runeritual/god/zizo
