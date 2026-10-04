/mob/living/get_will_block_ambush()
#ifdef MATURESERVER
	if(ishuman(src))
		var/mob/living/carbon/human/M = src
		if(M?.sexcon.current_action && !M?.sexcon.desire_stop) // if we're fucking in the bushes, don't spawn ambush
			return TRUE
#endif
	return ..()
