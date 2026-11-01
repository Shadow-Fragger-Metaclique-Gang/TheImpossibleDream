// Pestran pleasure from incisions.
/datum/surgery_step/incise/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	. = ..()

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.patron.type == /datum/patron/divine/pestra)
			C.add_stress(/datum/stressevent/pestran_incision)
			SEND_SIGNAL(C, COMSIG_MOB_INCISE_SUCCESS)


