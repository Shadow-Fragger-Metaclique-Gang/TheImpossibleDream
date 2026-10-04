/mob/living/carbon/human/Move(NewLoc, direct)
	. = ..()
	if(loc == NewLoc && wear_neck)
		if(mobility_flags & MOBILITY_STAND)
			if(istype(wear_neck, /obj/item/clothing))
				var/obj/item/clothing/N = wear_neck
				N.step_action()
