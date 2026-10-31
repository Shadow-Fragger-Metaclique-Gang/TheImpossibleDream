// human examining another human override. used for dollmaker tracking and flesh monolith objective
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(heart?.monolith_maker && heart.monolith_maker.resolve() == user)
		. += span_userdanger("THEY HAVE SEEN IT!")

	var/mob/living/carbon/human/examiner = user
	examiner.last_examined = src
